package my.nexgenesports.controller.team;

import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.team.TeamService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/team/remove")
public class TeamRemoveServlet extends HttpServlet {
    private final TeamService teamService = new TeamService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");
        int teamID = Integer.parseInt(req.getParameter("teamID"));
        String target = req.getParameter("userID");

        try {
            teamService.removeMember(teamID, target, userID);
        } catch (ServiceException e) {
            session.setAttribute("manageError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/team/detail?teamID=" + teamID);
    }
}
