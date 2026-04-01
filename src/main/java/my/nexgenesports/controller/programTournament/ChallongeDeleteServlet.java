// src/main/java/my/nexgenesports/controller/programTournament/ChallongeDeleteServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ChallongeService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/challonge/delete")
public class ChallongeDeleteServlet extends HttpServlet {
  private final ChallongeService svc = new ChallongeService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int progId = Integer.parseInt(req.getParameter("progId"));
    svc.delete(progId);
    resp.sendRedirect(req.getContextPath()
      + "/programs/challonge?progId=" + progId);
  }
}
