package my.nexgenesports.controller.team;

import my.nexgenesports.model.JoinRequest;
import my.nexgenesports.model.Team;
import my.nexgenesports.model.TeamMember;
import my.nexgenesports.service.team.TeamService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/team/detail")
public class TeamDetailServlet extends HttpServlet {
    private final TeamService teamService = new TeamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int teamID = Integer.parseInt(req.getParameter("teamID"));

        Team team           = teamService.getTeamById(teamID);
        List<TeamMember> members    = teamService.listMembers(teamID);
        List<JoinRequest> joinRequests = teamService.listJoinRequests(teamID);

        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");
        Optional<TeamMember> myMember = members.stream()
            .filter(m -> m.getUserID().equals(userID))
            .findFirst();

        req.setAttribute("team",         team);
        req.setAttribute("members",      members);
        req.setAttribute("joinRequests", joinRequests);
        req.setAttribute("myMember",     myMember.orElse(null));

        req.getRequestDispatcher("/teamDetail.jsp").forward(req, resp);
    }
}
