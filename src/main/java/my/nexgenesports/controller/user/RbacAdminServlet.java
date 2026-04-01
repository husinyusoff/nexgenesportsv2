// src/main/java/my/nexgenesports/controller/rbac/RbacAdminServlet.java
package my.nexgenesports.controller.user;

import my.nexgenesports.model.Page;
import my.nexgenesports.model.RolePosition;
import my.nexgenesports.service.user.RbacService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/admin/rbac")
public class RbacAdminServlet extends HttpServlet {
    private final RbacService svc = new RbacService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Page> pages                = svc.listPages();
            List<RolePosition> rps          = svc.listRolePositions();
            Map<Integer,Set<Integer>> perms = svc.mapAllPermissions();

            req.setAttribute("pages", pages);
            req.setAttribute("rps",    rps);
            req.setAttribute("perms",  perms);

            // forward into WEB-INF so it can't be browsed directly
            req.getRequestDispatcher("/rbacAdmin.jsp")
               .forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load RBAC admin data", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 0) CSRF protection
        HttpSession session = req.getSession(false);
        String sessionToken = (session != null) ? (String) session.getAttribute("csrfToken") : null;
        String submitted    = req.getParameter("csrfToken");
        if (sessionToken == null || submitted == null || !sessionToken.equals(submitted)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        try {
            // 1) collect inherit‐permission flags (checkbox names: inherit_{pageId})
            Map<Integer,Boolean> inheritMap = new HashMap<>();
            for (Page p : svc.listPages()) {
                boolean inh = req.getParameter("inherit_" + p.getPageId()) != null;
                inheritMap.put(p.getPageId(), inh);
            }

            // 2) collect explicit permissions (checkbox names: perm_{pageId}_{rpId})
            Map<Integer,Set<Integer>> permMap = new HashMap<>();
            for (String key : req.getParameterMap().keySet()) {
                if (key.startsWith("perm_")) {
                    String[] parts = key.split("_");
                    int pageId       = Integer.parseInt(parts[1]);
                    int rolePosId    = Integer.parseInt(parts[2]);
                    permMap
                      .computeIfAbsent(pageId, k -> new HashSet<>())
                      .add(rolePosId);
                }
            }

            // 3) persist everything in one shot
            svc.syncAll(inheritMap, permMap);

            // 4) redirect back with a success flag
            resp.sendRedirect(req.getContextPath() + "/admin/rbac?ok=1");
        } catch (SQLException e) {
            throw new ServletException("Failed to save RBAC changes", e);
        }
    }
}
