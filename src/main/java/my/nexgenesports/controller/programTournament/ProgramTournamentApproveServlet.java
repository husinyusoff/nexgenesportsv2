package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/approve")
public class ProgramTournamentApproveServlet extends HttpServlet {
    private final ProgramTournamentService svc = new ProgramTournamentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("progId");
        if (idParam == null) {
            // nothing to do → back to list
            resp.sendRedirect(req.getContextPath() + "/programs");
            return;
        }

        int progId = Integer.parseInt(idParam);
        svc.approveTournament(progId);
        // back to the list
        resp.sendRedirect(req.getContextPath() + "/programs");
    }
}
