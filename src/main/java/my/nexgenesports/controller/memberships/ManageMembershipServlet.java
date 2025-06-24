package my.nexgenesports.controller.memberships;

import my.nexgenesports.model.ClubBenefit;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.PassBenefit;
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
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/manageMembership")
public class ManageMembershipServlet extends HttpServlet {

    private final MembershipService ms = new MembershipService();
    private final PassService ps = new PassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("username") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            UserClubMembership currentMembership = ms.getCurrentMembership(userId);
            List<MembershipSession> upcomingSessions = ms.listUpcomingSessions(userId);

            MembershipSession activeSession = ms.getActiveSession();
            req.setAttribute("activeSession", activeSession);

            List<ClubBenefit> clubBenefits = activeSession == null
                    ? List.of()
                    : ms.listBenefits(activeSession.getSessionId());

            UserGamingPass currentPass = ps.getCurrentPass(userId);
            List<PassTier> passTiers = ps.listPassTiers();
            Map<Integer, List<PassBenefit>> passBenefitsMap = new HashMap<>();
            for (PassTier t : passTiers) {
                passBenefitsMap.put(t.getTierId(), ps.listBenefits(t.getTierId()));
            }

            req.setAttribute("currentMembership", currentMembership);
            req.setAttribute("upcomingSessions", upcomingSessions);
            req.setAttribute("clubBenefits", clubBenefits);

            req.setAttribute("currentPass", currentPass);
            req.setAttribute("passTiers", passTiers);
            req.setAttribute("passBenefitsMap", passBenefitsMap);

            req.setAttribute("today", LocalDate.now());

            req.getRequestDispatcher("manageMembership.jsp")
                    .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
