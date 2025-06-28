// File: src/main/java/my/nexgenesports/controller/tournament/BracketDeleteServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.BracketService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/brackets/delete")
public class BracketDeleteServlet extends HttpServlet {
    private final BracketService service = new BracketService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int bracketId = Integer.parseInt(req.getParameter("bracketId"));
        service.deleteBracket(bracketId);
        // redirect back to parent program
        String progId = req.getParameter("progId");
        resp.sendRedirect(req.getContextPath() + "/programs/detail?progId=" + progId);
    }
}
