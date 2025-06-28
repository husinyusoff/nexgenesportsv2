// File: src/main/java/my/nexgenesports/controller/tournament/BracketEditServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.Bracket;
import my.nexgenesports.service.programTournament.BracketService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/brackets/edit")
public class BracketEditServlet extends HttpServlet {
    private final BracketService service = new BracketService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int bracketId = Integer.parseInt(req.getParameter("bracketId"));
        Bracket b = service.findById(bracketId);

        req.setAttribute("bracket", b);
        req.setAttribute("ctx", req.getContextPath());
        req.getRequestDispatcher("/WEB-INF/jsp/tournament/bracketEdit.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int bracketId = Integer.parseInt(req.getParameter("bracketId"));
        String name   = req.getParameter("name");
        String format = req.getParameter("format");

        Bracket b = new Bracket();
        b.setBracketId(bracketId);
        b.setName(name);
        b.setFormat(format);

        service.updateBracket(b);
        resp.sendRedirect(req.getContextPath() + "/brackets/view?bracketId=" + bracketId);
    }
}
