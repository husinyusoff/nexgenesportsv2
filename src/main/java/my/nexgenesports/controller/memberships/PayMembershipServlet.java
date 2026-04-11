package my.nexgenesports.controller.memberships;

import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.service.memberships.MembershipService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/payMembership")
public class PayMembershipServlet extends HttpServlet {
    private final MembershipService ms = new MembershipService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) Auth
        HttpSession session = req.getSession(false);
        String userId = (session != null)
                      ? (String) session.getAttribute("username")
                      : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2) Grab the sessionId param
        String sessionId = req.getParameter("sessionId");
        if (sessionId == null) {
            resp.sendRedirect(req.getContextPath() + "/manageMembership");
            return;
        }

        // 3) Create or reuse the PENDING membership record
        // 3) Create unpersisted membership record for display
        UserClubMembership m = new UserClubMembership();
        try {
            m.setUserId(userId);
            m.setSession(ms.getSessionById(sessionId));
            m.setStatus("PENDING");
        } catch (SQLException e) {
            throw new ServletException("Failed to load membership session", e);
        }

        // 4) Expose for checkout.jsp
        req.setAttribute("paymentType", "membership");
        req.setAttribute("ucm",          m);
        req.setAttribute("amount",       m.getSession().getFee());
        req.setAttribute("description",  m.getSession().getSessionName());

        // 5) Forward into the shared checkout page
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }
}
