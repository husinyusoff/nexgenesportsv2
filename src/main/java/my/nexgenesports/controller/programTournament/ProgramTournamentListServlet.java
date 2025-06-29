package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Lists all programs and tournaments.
 */
@WebServlet("/programs")
public class ProgramTournamentListServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ProgramTournament> programs = service.listAllProgramsAndTournaments();
        req.setAttribute("programs", programs);
        req.setAttribute("ctx", req.getContextPath());
        req.getRequestDispatcher("/programList.jsp").forward(req, resp);
    }
}