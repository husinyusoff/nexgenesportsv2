package my.nexgenesports.controller.team;

import my.nexgenesports.model.Team;
import my.nexgenesports.service.team.TeamService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/team")
public class TeamListServlet extends HttpServlet {
    private final TeamService teamService = new TeamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String sortBy    = req.getParameter("sortBy");
        String direction = req.getParameter("direction");
        if (sortBy == null)    sortBy = "teamName";
        if (direction == null) direction = "asc";
        List<Team> teams = teamService.listAllTeamsSorted(sortBy, direction);
        req.setAttribute("teams", teams);
        req.getRequestDispatcher("/teamList.jsp").forward(req, resp);
    }
}
