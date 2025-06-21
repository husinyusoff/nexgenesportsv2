// src/main/java/my/nexgenesports/controller/ManageMembershipServlet.java
package my.nexgenesports.controller.memberships;

import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageMembership")
public class ManageMembershipServlet extends HttpServlet {
    private final MembershipService ms = new MembershipService();
    private final PassService       ps = new PassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = (session != null) ? (String)session.getAttribute("username") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            UserClubMembership currentM = ms.getCurrentMembership(userId);
            List<MembershipSession> upcoming = ms.listUpcomingSessions(userId);

            UserGamingPass currentP    = ps.getCurrentPass(userId);
            List<PassTier> tiers      = ps.listPassTiers();

            req.setAttribute("currentMembership", currentM);
            req.setAttribute("upcomingSessions",  upcoming);
            req.setAttribute("currentPass",       currentP);
            req.setAttribute("passTiers",         tiers);

            req.getRequestDispatcher("manageMembership.jsp")
               .forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
