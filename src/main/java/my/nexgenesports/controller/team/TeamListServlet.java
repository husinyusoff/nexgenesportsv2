package my.nexgenesports.controller.team;

import my.nexgenesports.model.Team;
import my.nexgenesports.service.team.TeamService;
import my.nexgenesports.dao.team.JoinRequestDao;
import my.nexgenesports.dao.team.JoinRequestDaoImpl;
import my.nexgenesports.dao.booking.BusinessConfigDao;
import my.nexgenesports.dao.booking.BusinessConfigDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/team/list")
public class TeamListServlet extends HttpServlet {
    private final TeamService       teamService    = new TeamService();
    private final JoinRequestDao    joinRequestDao = new JoinRequestDaoImpl();
    private final BusinessConfigDao configDao      = new BusinessConfigDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = session != null ? (String) session.getAttribute("username") : null;
        if (userID == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String q      = Optional.ofNullable(req.getParameter("q")).orElse("").trim();
        String sortBy = Optional.ofNullable(req.getParameter("sortBy")).orElse("createdAt");
        String dir    = Optional.ofNullable(req.getParameter("dir")).orElse("desc");

        List<Team> teams = teamService.searchAndSort(q, sortBy, dir);

        List<Team> myTeams = teamService.listTeamsForUser(userID);
        Set<Integer> myTeamIds = myTeams.stream()
                                        .map(Team::getTeamID)
                                        .collect(Collectors.toSet());
        int joinedCount = myTeams.size();

        int joinLimit = 4;
        try {
            joinLimit = configDao.getInt("team.join.limit", 4);
        } catch (SQLException ex) {
            Logger.getLogger(TeamListServlet.class.getName())
                  .log(Level.SEVERE, "Failed to read join limit", ex);
        }

        Set<Integer> pendingTeamIds = Collections.emptySet();
        try {
            pendingTeamIds = joinRequestDao.listPendingByUser(userID).stream()
                                 .map(r -> r.getTeamID())
                                 .collect(Collectors.toSet());
        } catch (SQLException ex) {
            Logger.getLogger(TeamListServlet.class.getName())
                  .log(Level.SEVERE, "Failed to load pending requests", ex);
        }

        int pendingCount     = pendingTeamIds.size();
        int totalMemberships = joinedCount + pendingCount;

        req.setAttribute("teams",            teams);
        req.setAttribute("myTeamIds",        myTeamIds);
        req.setAttribute("joinedCount",      joinedCount);
        req.setAttribute("pendingCount",     pendingCount);
        req.setAttribute("totalMemberships", totalMemberships);
        req.setAttribute("joinLimit",        joinLimit);
        req.setAttribute("pendingTeamIds",   pendingTeamIds);

        req.getRequestDispatcher("/teamList.jsp")
           .forward(req, resp);
    }
}
