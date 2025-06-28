// File: src/main/java/my/nexgenesports/controller/tournament/BracketScoreServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.BracketService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/brackets/score")
public class BracketScoreServlet extends HttpServlet {
    private final BracketService service = new BracketService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int matchId = Integer.parseInt(req.getParameter("matchId"));
        int score1  = Integer.parseInt(req.getParameter("score1"));
        int score2  = Integer.parseInt(req.getParameter("score2"));

        service.recordMatchScore(matchId, score1, score2);
        // stay on same bracket view
        int bracketId = Integer.parseInt(req.getParameter("bracketId"));
        resp.sendRedirect(req.getContextPath() + "/brackets/view?bracketId=" + bracketId);
    }
}
