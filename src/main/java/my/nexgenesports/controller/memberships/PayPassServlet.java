// src/main/java/my/nexgenesports/controller/general/PayPassServlet.java
package my.nexgenesports.controller.memberships;

import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.service.memberships.PassService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/payPass")
public class PayPassServlet extends HttpServlet {
    private final PassService ps = new PassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) Auth check
        HttpSession session = req.getSession(false);
        String userId = (session != null)
                      ? (String) session.getAttribute("username")
                      : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2) Get tierId parameter
        String tierIdStr = req.getParameter("tierId");
        if (tierIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/manageMembership");
            return;
        }

        // 3) Create PENDING pass record
        UserGamingPass p;
        try {
            int tierId = Integer.parseInt(tierIdStr);
            p = ps.createPending(userId, tierId);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to initialize pass payment", e);
        }

        // 4) Expose into checkout.jsp
        req.setAttribute("ugp",    p);
        req.setAttribute("amount", p.getTier().getPrice());

        // 5) Forward to shared checkout page
        req.getRequestDispatcher("/checkout.jsp")
           .forward(req, resp);
    }
}
