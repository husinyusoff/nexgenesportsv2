// File: src/main/java/my/nexgenesports/controller/tournament/BracketViewServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.Bracket;
import my.nexgenesports.model.BracketMatch;
import my.nexgenesports.service.programTournament.BracketService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/brackets/view")
public class BracketViewServlet extends HttpServlet {
    private final BracketService service = new BracketService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int bracketId = Integer.parseInt(req.getParameter("bracketId"));
        Bracket b = service.findById(bracketId);
        List<BracketMatch> matches = service.listMatches(bracketId);

        req.setAttribute("bracket", b);
        req.setAttribute("matches", matches);
        req.setAttribute("ctx", req.getContextPath());
        req.getRequestDispatcher("/WEB-INF/jsp/tournament/bracketView.jsp")
           .forward(req, resp);
    }
}
