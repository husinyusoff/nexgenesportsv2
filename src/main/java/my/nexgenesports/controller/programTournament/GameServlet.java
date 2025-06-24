package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.Game;
import my.nexgenesports.service.programTournament.GameService;
import my.nexgenesports.util.PermissionChecker;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/games/*")
public class GameServlet extends HttpServlet {
    private final GameService svc = new GameService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        @SuppressWarnings("unchecked")
        List<String> effectiveRoles = (List<String>) session.getAttribute("effectiveRoles");
        String chosenRole = (String) session.getAttribute("role");
        String position   = (String) session.getAttribute("position");

        String pathInfo = req.getPathInfo(); // null, "/new", "/edit", "/details"
        String base     = "/games";

        // Compute permissions ONCE, push into request
        boolean canList    = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base);
        boolean canView    = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/details");
        boolean canCreate  = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/new");
        boolean canEdit    = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/edit");
        boolean canDelete  = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/delete");

        req.setAttribute("canList", canList);
        req.setAttribute("canView", canView);
        req.setAttribute("canCreate", canCreate);
        req.setAttribute("canEdit", canEdit);
        req.setAttribute("canDelete", canDelete);

        // 1) LIST
        if (pathInfo == null || "/".equals(pathInfo)) {
            if (!canList) {
                resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                return;
            }
            req.setAttribute("games", svc.listGames());
            req.getRequestDispatcher("/gameList.jsp")
               .forward(req, resp);
            return;
        }

        switch (pathInfo) {
            case "/new":
                if (!canCreate) {
                    resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                    return;
                }
                // empty form
                req.getRequestDispatcher("/gameForm.jsp").forward(req, resp);
                break;

            case "/edit":
                if (!canEdit) {
                    resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                    return;
                }
                String eid = req.getParameter("id");
                if (eid != null) {
                    req.setAttribute("game", svc.find(Integer.parseInt(eid)));
                }
                req.getRequestDispatcher("/gameForm.jsp").forward(req, resp);
                break;

            case "/details":
                if (!canView) {
                    resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                    return;
                }
                String did = req.getParameter("id");
                if (did == null) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                req.setAttribute("game", svc.find(Integer.parseInt(did)));
                req.getRequestDispatcher("/gameDetails.jsp").forward(req, resp);
                break;

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        @SuppressWarnings("unchecked")
        List<String> effectiveRoles = (List<String>) session.getAttribute("effectiveRoles");
        String chosenRole = (String) session.getAttribute("role");
        String position   = (String) session.getAttribute("position");

        String pathInfo = req.getPathInfo(); // "/new", "/edit", "/delete"
        String base     = "/games";

        boolean canCreate = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/new");
        boolean canEdit   = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/edit");
        boolean canDelete = PermissionChecker.hasAccess(effectiveRoles, chosenRole, position, base + "/delete");

        if ("/delete".equals(pathInfo)) {
            if (!canDelete) {
                resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                return;
            }
            String id = req.getParameter("id");
            if (id != null) svc.deleteGame(Integer.parseInt(id));

        } else if ("/edit".equals(pathInfo)) {
            if (!canEdit) {
                resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                return;
            }
            Game g = new Game();
            g.setGameName(req.getParameter("gameName"));
            g.setGenre(req.getParameter("genre"));
            String gid = req.getParameter("gameID");
            if (gid != null && !gid.isEmpty()) {
                g.setGameID(Integer.parseInt(gid));
                svc.updateGame(g);
            }

        } else if ("/new".equals(pathInfo)) {
            if (!canCreate) {
                resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                return;
            }
            Game g = new Game();
            g.setGameName(req.getParameter("gameName"));
            g.setGenre(req.getParameter("genre"));
            svc.createGame(g);

        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/games");
    }
}
