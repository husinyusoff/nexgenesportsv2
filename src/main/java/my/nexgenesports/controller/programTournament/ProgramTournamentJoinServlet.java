// File: ProgramTournamentJoinServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/join")
public class ProgramTournamentJoinServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String progId = req.getParameter("progId");
        String teamId = req.getParameter("teamId");   // may be null for SOLO
        HttpSession session = req.getSession(false);
        String user   = (String) session.getAttribute("username");

        service.registerParticipant(progId, user, teamId);
        resp.sendRedirect(req.getContextPath() + "/programs/detail?progId=" + progId);
    }
}
