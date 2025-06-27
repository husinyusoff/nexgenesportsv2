package my.nexgenesports.controller.team;

import my.nexgenesports.service.team.TeamService;
import my.nexgenesports.dao.team.JoinRequestDao;
import my.nexgenesports.dao.team.JoinRequestDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet("/team/joinRequest")
public class JoinRequestServlet extends HttpServlet {
    private final TeamService    teamService    = new TeamService();
    private final JoinRequestDao joinRequestDao = new JoinRequestDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");
        String action = req.getParameter("action");
        try {
            if ("cancel".equals(action)) {
                int requestID = Integer.parseInt(req.getParameter("requestID"));
                joinRequestDao.updateStatus(requestID, "Cancelled", LocalDateTime.now());
            } else {
                int teamID = Integer.parseInt(req.getParameter("teamID"));
                teamService.submitJoinRequest(teamID, userID);
            }
        } catch (NumberFormatException | SQLException e) {
            session.setAttribute("manageError", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/team/manage");
    }
}
