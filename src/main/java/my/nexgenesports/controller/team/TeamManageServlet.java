package my.nexgenesports.controller.team;

import my.nexgenesports.model.Team;
import my.nexgenesports.model.TeamMember;
import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.team.TeamService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/team/manage")
public class TeamManageServlet extends HttpServlet {

    private final TeamService teamService = new TeamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");

        // 1) load all teams the user belongs to
        List<Team> teams = teamService.listTeamsForUser(userID);

        // 2) build helper maps
        Map<Integer, Integer> membersCountMap = new HashMap<>();
        Map<Integer, List<TeamMember>> membersByTeam = new HashMap<>();
        Map<Integer, List<?>> achievementsByTeam = new HashMap<>();

        // populate counts, members & (empty) achievements
        for (Team team : teams) {
            int teamID = team.getTeamID();
            List<TeamMember> membs = teamService.listMembers(teamID);
            membersCountMap.put(teamID, membs.size());
            membersByTeam.put(teamID, membs);
            achievementsByTeam.put(teamID, Collections.emptyList());
        }

        // 3) build a map of <teamID -> this user’s current role>
        Map<Integer, String> userRoleMap = new HashMap<>();
        for (Team team : teams) {
            int teamID = team.getTeamID();
            for (TeamMember m : membersByTeam.get(teamID)) {
                if (m.getUserID().equals(userID) && "Active".equals(m.getStatus())) {
                    userRoleMap.put(teamID, m.getTeamRole());
                    break;
                }
            }
        }

        // 4) stash everything into request
        req.setAttribute("teams", teams);
        req.setAttribute("membersCountMap", membersCountMap);
        req.setAttribute("membersByTeam", membersByTeam);
        req.setAttribute("achievementsByTeam", achievementsByTeam);
        req.setAttribute("userRoleMap", userRoleMap);

        // 5) forward to JSP
        req.getRequestDispatcher("/manageTeam.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");
        int teamID = Integer.parseInt(req.getParameter("teamID"));
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "disband" ->
                    teamService.disbandTeam(teamID, userID);
                case "leave" ->
                    teamService.leaveTeam(teamID, userID);
                case "changeRole" -> {
                    String targetUser = req.getParameter("targetUserID");
                    String newRole = req.getParameter("newRole");
                    teamService.changeRole(teamID, targetUser, newRole, userID);
                }
                case "setCapacity" -> {
                    int cap = Integer.parseInt(req.getParameter("capacity"));
                    teamService.setCapacity(teamID, cap, userID);
                }
                case "removeMember" -> {
                    String targetUser = req.getParameter("targetUserID");
                    teamService.removeMember(teamID, targetUser, userID);
                }
                case "respondToJoin" -> {
                    int requestID = Integer.parseInt(req.getParameter("requestID"));
                    boolean accept = "accept".equals(req.getParameter("decision"));
                    teamService.respondToJoin(teamID, requestID, accept, userID);
                }
                default ->
                    throw new ServiceException("Unknown action: " + action);
            }
        } catch (ServiceException e) {
            session.setAttribute("manageError", e.getMessage());
        }

        // redirect back here so that GET will show the updated view
        resp.sendRedirect(req.getContextPath() + "/team/manage");
    }
}
