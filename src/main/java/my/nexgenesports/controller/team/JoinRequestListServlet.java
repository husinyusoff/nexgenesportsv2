package my.nexgenesports.controller.team;

import my.nexgenesports.model.JoinRequest;
import my.nexgenesports.model.Team;
import my.nexgenesports.service.team.TeamService;
import my.nexgenesports.dao.team.JoinRequestDao;
import my.nexgenesports.dao.team.JoinRequestDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/team/joinRequests")
public class JoinRequestListServlet extends HttpServlet {
    private final TeamService teamService      = new TeamService();
    private final JoinRequestDao joinRequestDao = new JoinRequestDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String me = session == null ? null : (String) session.getAttribute("username");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 1) Which teams am I a leader/co-leader of?
        List<Integer> myTeams = teamService
            .listTeamsForUser(me).stream()
            .filter(t -> teamService.listMembers(t.getTeamID()).stream()
                .anyMatch(m -> m.getUserID().equals(me)
                             && "Active".equals(m.getStatus())
                             && (m.getTeamRole().equals("Leader")
                              || m.getTeamRole().equals("Co-Leader"))))
            .map(Team::getTeamID)
            .collect(Collectors.toList());

        // 2) Load all pending requests for those teams
        List<JoinRequest> requests = new ArrayList<>();
        for (int tid : myTeams) {
            try {
                requests.addAll(joinRequestDao.listPendingByTeam(tid));
            } catch (SQLException e) {
                throw new ServletException("Failed to load join requests", e);
            }
        }

        // 3) Build a teamID → teamName map
        Map<Integer,String> teamNameMap = new HashMap<>();
        for (JoinRequest jr : requests) {
            Team t = teamService.getTeamById(jr.getTeamID());
            teamNameMap.put(t.getTeamID(), t.getTeamName());
        }

        // 4) Must include the CSRF token on this GET so your filter will allow it
        String csrf = (String) session.getAttribute("csrfToken");
        req.setAttribute("csrfToken", csrf);

        // 5) Push into request
        req.setAttribute("requests",    requests);
        req.setAttribute("teamNameMap",  teamNameMap);
        req.setAttribute("ctx",         req.getContextPath());

        req.getRequestDispatcher("/joinRequests.jsp").forward(req, resp);
    }

    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    HttpSession session = req.getSession(false);
    String me = (String) session.getAttribute("username");
    if (me == null) {
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
        return;
    }

    int teamID    = Integer.parseInt(req.getParameter("teamID"));
    int requestID = Integer.parseInt(req.getParameter("requestID"));
    boolean accept= "accept".equals(req.getParameter("decision"));

    // perform the accept/reject
    teamService.respondToJoin(teamID, requestID, accept, me);

    // figure out which teams I'm an officer of
    List<Integer> myTeams = teamService.listTeamsForUser(me).stream()
        .filter(t -> teamService.listMembers(t.getTeamID()).stream()
            .anyMatch(m ->
                m.getUserID().equals(me) &&
                "Active".equals(m.getStatus()) &&
                (m.getTeamRole().equals("Leader") || m.getTeamRole().equals("Co-Leader"))
            )
        )
        .map(Team::getTeamID)
        .collect(Collectors.toList());

    // collect any remaining pending requests for those teams
    List<JoinRequest> remaining = new ArrayList<>();
    try {
        for (int tid : myTeams) {
            remaining.addAll(joinRequestDao.listPendingByTeam(tid));
        }
    } catch (SQLException e) {
        throw new ServletException("Failed to reload pending requests", e);
    }

    String ctx = req.getContextPath();
    if (remaining.isEmpty()) {
        // no more requests → go back to manage page
        resp.sendRedirect(ctx + "/team/manage");
    } else {
        // still have requests → go back to the list
        resp.sendRedirect(ctx + "/team/joinRequests");
    }
}

}
