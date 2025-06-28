// File: ProgramTournamentDetailServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.*;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/programs/detail")
public class ProgramTournamentDetailServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String progId = req.getParameter("progId");
        ProgramTournament pt = service.findById(progId);
        if (pt == null) {
            resp.sendError(404, "Program/Tournament not found");
            return;
        }

        // participants & (if tournament) brackets
        List<TournamentParticipant> parts = service.listParticipants(progId);
        List<Bracket>            bracks = List.of();
        ChallongeTournament      ct     = null;
        if ("TOURNAMENT".equals(pt.getProgramType())) {
            bracks = service.listBrackets(progId);
            ct     = service.getChallonge(progId);
        }

        req.setAttribute("program",      pt);
        req.setAttribute("participants", parts);
        req.setAttribute("brackets",     bracks);
        req.setAttribute("challonge",    ct);
        req.setAttribute("ctx",          req.getContextPath());
        req.getRequestDispatcher("/programDetail.jsp")
           .forward(req, resp);
    }
}
