// src/main/java/my/nexgenesports/controller/programTournament/ChallongeEditServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ChallongeTournament;
import my.nexgenesports.service.programTournament.ChallongeService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/challonge/edit")
public class ChallongeEditServlet extends HttpServlet {
  private final ChallongeService svc = new ChallongeService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int progId = Integer.parseInt(req.getParameter("progId"));
    ChallongeTournament ct = svc.find(progId);
    req.setAttribute("mapping", ct);
    req.getRequestDispatcher("/challongeEdit.jsp")
       .forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int progId    = Integer.parseInt(req.getParameter("progId"));
    String name        = req.getParameter("name");
    String description = req.getParameter("description");
    svc.update(progId, name, description);
    resp.sendRedirect(req.getContextPath()
      + "/programs/challonge?progId=" + progId);
  }
}
