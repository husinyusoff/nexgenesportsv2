// File: ProgramTournamentApproveServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/approve")
public class ProgramTournamentApproveServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String approver = (String) session.getAttribute("username");
        String progId   = req.getParameter("progId");
        service.approveProgramTournament(progId, approver);
        resp.sendRedirect(req.getContextPath() + "/programs");
    }
}
