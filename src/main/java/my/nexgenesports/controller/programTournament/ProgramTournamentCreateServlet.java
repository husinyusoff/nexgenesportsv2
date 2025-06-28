package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import my.nexgenesports.dao.programTournament.MeritLevelDaoImpl;
import my.nexgenesports.model.MeritLevel;
import my.nexgenesports.service.programTournament.GameService;

@WebServlet("/programs/new")
public class ProgramTournamentCreateServlet extends HttpServlet {
    private final ProgramTournamentService svc = new ProgramTournamentService();

@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    // load the game list
    var games = new GameService().listGames();
    req.setAttribute("games", games);

    // load the merit levels directly via the DAO
    var meritDao = new MeritLevelDaoImpl();
    List<MeritLevel> merits;
    try {
        merits = meritDao.findAll();
    } catch (SQLException e) {
        throw new ServletException("Failed to load merit levels", e);
    }
    req.setAttribute("merits", merits);

    req.getRequestDispatcher("/programCreate.jsp")
       .forward(req, resp);
}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ProgramTournament pt = new ProgramTournament();
            pt.setProgId(           /* generate or pull from form */ req.getParameter("progId"));
            pt.setCreatorId(        req.getParameter("creatorId"));
            pt.setGameId(           Integer.valueOf(req.getParameter("gameId")));
            pt.setProgramName(      req.getParameter("programName"));
            pt.setProgramType(      req.getParameter("programType"));
            pt.setMeritId(          Integer.valueOf(req.getParameter("meritId")));
            pt.setPlace(            req.getParameter("place"));
            pt.setDescription(      req.getParameter("description"));
            pt.setProgFee(          new BigDecimal(req.getParameter("progFee")));
            pt.setStartDate(        LocalDate.parse(req.getParameter("startDate")));
            pt.setEndDate(          LocalDate.parse(req.getParameter("endDate")));
            pt.setStartTime(        LocalTime.parse(req.getParameter("startTime")));
            pt.setEndTime(          LocalTime.parse(req.getParameter("endTime")));
            pt.setPrizePool(        new BigDecimal(req.getParameter("prizePool")));
            pt.setMaxCapacity(      Integer.parseInt(req.getParameter("maxCapacity")));
            pt.setMaxTeamMember(    Integer.valueOf(req.getParameter("maxTeamMember")));
            pt.setStatus(           "PENDING");  // default status

            svc.createProgramTournament(pt);
            resp.sendRedirect(req.getContextPath() + "/programs?success=created");
        } catch (RuntimeException e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}
