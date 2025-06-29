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
import java.util.logging.Level;
import java.util.logging.Logger;
import my.nexgenesports.dao.programTournament.ProgramTournamentDaoImpl;
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

        List<String> scopes;
        try {
            scopes = new ProgramTournamentDaoImpl().findAllScopes();
            if (scopes == null || scopes.isEmpty()) {
                scopes = List.of("Club", "University", "State", "National", "International");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProgramTournamentCreateServlet.class.getName()).log(Level.SEVERE, null, ex);
            scopes = List.of("Club", "University", "State", "National", "International");
        }
        req.setAttribute("scopes", scopes);
        req.setAttribute("scopesJson", new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(scopes));

        req.getRequestDispatcher("/programCreate.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ProgramTournament pt = new ProgramTournament();
            HttpSession session = req.getSession(false);
            String creator = (session != null)
                    ? (String) session.getAttribute("username")
                    : null;
            pt.setCreatorId(creator);

            String gameId = req.getParameter("gameId");
            pt.setGameId(gameId != null && !gameId.isBlank()
                    ? Integer.valueOf(gameId) : null);

            pt.setProgramName(req.getParameter("programName"));

            String programType = req.getParameter("programType");
            pt.setProgramType(programType);

            String scope = req.getParameter("meritScope");
            pt.setMeritId(svc.resolveMeritId(programType, scope));

            pt.setPlace(req.getParameter("place"));
            pt.setDescription(req.getParameter("description"));

            String fee = req.getParameter("progFee");
            pt.setProgFee(fee != null && !fee.isBlank()
                    ? new BigDecimal(fee) : null);

            pt.setStartDate(LocalDate.parse(req.getParameter("startDate")));
            pt.setEndDate(LocalDate.parse(req.getParameter("endDate")));

            String st = req.getParameter("startTime");
            pt.setStartTime(st != null && !st.isBlank()
                    ? LocalTime.parse(st) : null);

            String et = req.getParameter("endTime");
            pt.setEndTime(et != null && !et.isBlank()
                    ? LocalTime.parse(et) : null);

            String pool = req.getParameter("prizePool");
            pt.setPrizePool(pool != null && !pool.isBlank()
                    ? new BigDecimal(pool) : null);

            pt.setMaxCapacity(Integer.parseInt(req.getParameter("maxCapacity")));

            String mtm = req.getParameter("maxTeamMember");
            pt.setMaxTeamMember(mtm != null && !mtm.isBlank()
                    ? Integer.valueOf(mtm) : null);

            pt.setStatus("PENDING");  // default status

            svc.createProgramTournament(pt);
            resp.sendRedirect(req.getContextPath() + "/programs/" + pt.getProgId());

        } catch (RuntimeException e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}
