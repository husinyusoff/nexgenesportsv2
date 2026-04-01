// src/main/java/my/nexgenesports/controller/programTournament/ChallongeManageServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ChallongeTournament;
import my.nexgenesports.service.programTournament.ChallongeService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/challonge")
public class ChallongeManageServlet extends HttpServlet {
  private final ChallongeService svc = new ChallongeService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int progId = Integer.parseInt(req.getParameter("progId"));
    ChallongeTournament ct = svc.find(progId);
    req.setAttribute("mapping", ct);
    req.setAttribute("progId",   progId);
    req.getRequestDispatcher("//challongeManage.jsp")
       .forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int progId = Integer.parseInt(req.getParameter("progId"));
    svc.provision(progId);
    resp.sendRedirect(req.getContextPath()
      + "/programs/challonge?progId=" + progId);
  }
}
