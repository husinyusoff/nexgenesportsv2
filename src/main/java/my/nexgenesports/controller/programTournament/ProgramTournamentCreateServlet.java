package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.Game;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.programTournament.GameService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/programs/new")
public class ProgramTournamentCreateServlet extends HttpServlet {

    private final ProgramTournamentService svc = new ProgramTournamentService();
    private final GameService gameSvc = new GameService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) load games
        List<Game> games = gameSvc.listGames();
        req.setAttribute("games", games);

        // 2) load scopes
        List<String> scopes = List.of("Club", "University", "State", "National", "International");
        req.setAttribute("scopes", scopes);

        // 3) load bracket formats
        List<String> formats = List.of(
                "SINGLE_ELIM",
                "DOUBLE_ELIM",
                "ROUND_ROBIN",
                "LEADERBOARD"
        );
        req.setAttribute("formats", formats);

        // 4) render JSP
        req.getRequestDispatcher("/programCreate.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ProgramTournament pt = new ProgramTournament();

            // creator
            HttpSession session = req.getSession(false);
            pt.setCreatorId(
                    session == null
                            ? null
                            : (String) session.getAttribute("username")
            );

            // type & name
            String type = req.getParameter("programType");
            pt.setProgramType(type);
            pt.setProgramName(req.getParameter("programName"));

            // only for tournaments
            if ("TOURNAMENT".equals(type)) {
                String gameId = req.getParameter("gameId");
                pt.setGameId(
                        (gameId == null || gameId.isBlank())
                        ? null
                        : Integer.valueOf(gameId)
                );
                pt.setBracketFormat(req.getParameter("bracketFormat"));
            }

            // common fields
            pt.setPlace(req.getParameter("place"));
            pt.setDescription(req.getParameter("description"));

            String fee = req.getParameter("progFee");
            if (fee != null && !fee.isBlank()) {
                pt.setProgFee(new BigDecimal(fee));
            }

            pt.setStartDate(LocalDate.parse(req.getParameter("startDate")));
            pt.setEndDate(LocalDate.parse(req.getParameter("endDate")));

            String st = req.getParameter("startTime");
            if (st != null && !st.isBlank()) {
                pt.setStartTime(LocalTime.parse(st));
            }
            String et = req.getParameter("endTime");
            if (et != null && !et.isBlank()) {
                pt.setEndTime(LocalTime.parse(et));
            }

            String pool = req.getParameter("prizePool");
            pt.setPrizePool((pool == null || pool.isBlank())
                    ? null
                    : new BigDecimal(pool));

            pt.setMaxCapacity(
                    Integer.parseInt(req.getParameter("maxCapacity"))
            );
            String mtm = req.getParameter("maxTeamMember");
            pt.setMaxTeamMember(
                    (mtm == null || mtm.isBlank())
                    ? null
                    : Integer.valueOf(mtm)
            );

            // merit lookup
            String scope = req.getParameter("meritScope");
            pt.setMeritId(svc.resolveMeritId(type, scope));

            // initial status
            pt.setStatus("PENDING_APPROVAL");

            // persist
            svc.createProgramTournament(pt);

            // redirect to detail page
            resp.sendRedirect(
                    req.getContextPath() + "/programs/" + pt.getProgId()
            );
        } catch (Exception e) {
            log("Failed to create ProgramTournament", e);
            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Sorry, something went wrong. See server log."
            );
        }
    }
}
