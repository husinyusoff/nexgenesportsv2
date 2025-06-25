package my.nexgenesports.controller.team;

import my.nexgenesports.model.Team;
import my.nexgenesports.service.team.TeamService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/team/capacity")
public class TeamCapacityServlet extends HttpServlet {
    private final TeamService teamService = new TeamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int teamID = Integer.parseInt(req.getParameter("teamID"));
        Team t = teamService.getTeamById(teamID);
        req.setAttribute("team", t);
        req.getRequestDispatcher("/teamCapacity.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // simply delegate to TeamManageServlet
        new TeamManageServlet().doPost(req, resp);
    }
}
