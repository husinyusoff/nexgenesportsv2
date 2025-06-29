package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import my.nexgenesports.dao.programTournament.MeritLevelDao;
import my.nexgenesports.dao.programTournament.MeritLevelDaoImpl;
import my.nexgenesports.model.MeritLevel;

@WebServlet("/programs")
public class ProgramTournamentListServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();
    private final MeritLevelDao       mlDao   = new MeritLevelDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1a) load all programs
        List<ProgramTournament> programs = service.listAllProgramsAndTournaments();
        req.setAttribute("programs", programs);

        // 1b) load all merits
        List<MeritLevel> merits;
        try {
            merits = mlDao.findAll();
        } catch (SQLException e) {
            throw new ServletException("Failed to load merit levels", e);
        }
        req.setAttribute("merits", merits);

        req.setAttribute("ctx", req.getContextPath());
        req.getRequestDispatcher("/programList.jsp")
           .forward(req, resp);
    }
}
