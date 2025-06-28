// File: ProgramTournamentDeleteServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/delete")
public class ProgramTournamentDeleteServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String progId = req.getParameter("progId");
        service.deleteProgramTournament(progId);
        resp.sendRedirect(req.getContextPath() + "/programs");
    }
}
