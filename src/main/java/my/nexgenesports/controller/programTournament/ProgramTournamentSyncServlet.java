// File: src/main/java/my/nexgenesports/controller/tournament/ProgramTournamentSyncServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/sync")
public class ProgramTournamentSyncServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String progId = req.getParameter("progId");
        try {
            service.syncWithChallonge(progId);
        } catch (Exception e) {
            req.getSession().setAttribute("error", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/programs/detail?progId=" + progId);
    }
}
