package my.nexgenesports.controller.team;

import my.nexgenesports.model.JoinRequest;
import my.nexgenesports.model.Team;
import my.nexgenesports.model.TeamMember;
import my.nexgenesports.service.team.TeamService;
import my.nexgenesports.dao.team.JoinRequestDao;
import my.nexgenesports.dao.team.JoinRequestDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import my.nexgenesports.service.general.ServiceException;

@WebServlet("/team/manage")
public class TeamManageServlet extends HttpServlet {

    private static final Logger log = Logger.getLogger(TeamManageServlet.class.getName());

    private final TeamService teamService = new TeamService();
    private final JoinRequestDao joinRequestDao = new JoinRequestDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) session + login check
        HttpSession session = req.getSession(false);
        String userID = session != null
                ? (String) session.getAttribute("username")
                : null;
        if (userID == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2) load all teams the user is an Active member of
        List<Team> activeTeams = teamService.listTeamsForUser(userID);

        // 3) load all pending join-requests this user has issued
        List<JoinRequest> pendingRequests = Collections.emptyList();
        try {
            pendingRequests = joinRequestDao.listPendingByUser(userID);
        } catch (SQLException ex) {
            log.log(Level.SEVERE, "Could not load pending join-requests", ex);
        }

        // 4) resolve those pending requests back to Team objects
        List<Team> pendingTeams = new ArrayList<>();
        for (JoinRequest jr : pendingRequests) {
            pendingTeams.add(teamService.getTeamById(jr.getTeamID()));
        }

        // 5) merge both lists for the summary table
        List<Team> allTeams = new ArrayList<>();
        allTeams.addAll(activeTeams);
        allTeams.addAll(pendingTeams);

        // 6) for each team, load active members and counts
        Map<Integer, List<TeamMember>> membersByTeam = new HashMap<>();
        Map<Integer, Integer> memberCount = new HashMap<>();
        for (Team t : allTeams) {
            List<TeamMember> members = teamService.listMembers(t.getTeamID());
            membersByTeam.put(t.getTeamID(), members);
            memberCount.put(t.getTeamID(), members.size());
        }

        // 7) figure out this user’s role on each Active team
        Map<Integer, String> userRoleMap = new HashMap<>();
        for (Team t : activeTeams) {
            for (TeamMember m : membersByTeam.get(t.getTeamID())) {
                if (m.getUserID().equals(userID) && "Active".equals(m.getStatus())) {
                    userRoleMap.put(t.getTeamID(), m.getTeamRole());
                    break;
                }
            }
        }

        // … after you build userRoleMap …
        boolean canViewRequests = userRoleMap.values().stream()
                .anyMatch(r -> "Leader".equals(r) || "Co-Leader".equals(r));
        req.setAttribute("canViewRequests", canViewRequests);

        // 9) build map teamID→requestID for “Cancel Request”
        Map<Integer, Integer> pendingRequestMap = new HashMap<>();
        for (JoinRequest jr : pendingRequests) {
            pendingRequestMap.put(jr.getTeamID(), jr.getRequestID());
        }

        // 10) stash everything & render
        req.setAttribute("teams", allTeams);
        req.setAttribute("membersByTeam", membersByTeam);
        req.setAttribute("memberCount", memberCount);
        req.setAttribute("userRoleMap", userRoleMap);
        req.setAttribute("pendingRequestMap", pendingRequestMap);
        req.setAttribute("canViewRequests", canViewRequests);
        req.setAttribute("ctx", req.getContextPath());

        req.getRequestDispatcher("/manageTeam.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "disband" -> {
                    int teamId = Integer.parseInt(req.getParameter("teamID"));
                    teamService.disbandTeam(teamId, userID);
                }
                case "leave" -> {
                    int teamId = Integer.parseInt(req.getParameter("teamID"));
                    teamService.leaveTeam(teamId, userID);
                }
                case "changeRole" -> {
                    int teamId = Integer.parseInt(req.getParameter("teamID"));
                    String targetUser = req.getParameter("targetUserID");
                    String newRole = req.getParameter("newRole");
                    teamService.changeRole(teamId, targetUser, newRole, userID);
                }
                case "setCapacity" -> {
                    int teamId = Integer.parseInt(req.getParameter("teamID"));
                    int capacity = Integer.parseInt(req.getParameter("capacity"));
                    teamService.setCapacity(teamId, capacity, userID);
                }
                case "removeMember" -> {
                    int teamId = Integer.parseInt(req.getParameter("teamID"));
                    String targetUser = req.getParameter("targetUserID");
                    teamService.removeMember(teamId, targetUser, userID);
                }
                case "respondToJoin" -> {
                    int teamId = Integer.parseInt(req.getParameter("teamID"));
                    int requestID = Integer.parseInt(req.getParameter("requestID"));
                    boolean accept = "accept".equals(req.getParameter("decision"));
                    teamService.respondToJoin(teamId, requestID, accept, userID);
                }
                default ->
                    throw new ServiceException("Unknown action: " + action);
            }
        } catch (ServiceException e) {
            session.setAttribute("manageError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/team/manage");

        // then redirect back so GET will render the updated view:
        resp.sendRedirect(req.getContextPath() + "/team/manage");
    }
}
