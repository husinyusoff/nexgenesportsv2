// File: src/main/java/my/nexgenesports/controller/tournament/BracketCreateServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.Bracket;
import my.nexgenesports.service.programTournament.BracketService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/brackets/create")
public class BracketCreateServlet extends HttpServlet {
    private final BracketService service = new BracketService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("progId", req.getParameter("progId"));
        req.setAttribute("ctx", req.getContextPath());
        req.getRequestDispatcher("/WEB-INF/jsp/tournament/bracketCreate.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String progId    = req.getParameter("progId");
        String name      = req.getParameter("name");
        String format    = req.getParameter("format");
        HttpSession sess = req.getSession(false);
        String createdBy = (String) sess.getAttribute("username");

        Bracket b = new Bracket();
        b.setProgId(progId);
        b.setName(name);
        b.setFormat(format);
        b.setCreatedBy(createdBy);

        service.createBracket(b);
        resp.sendRedirect(req.getContextPath() + "/programs/detail?progId=" + progId);
    }
}
