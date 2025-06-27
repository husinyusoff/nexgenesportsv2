// src/main/java/my/nexgenesports/controller/ProgramSyncServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentSyncService;
import my.nexgenesports.service.general.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/sync")
public class ProgramSyncServlet extends HttpServlet {
  private final ProgramTournamentSyncService syncSvc = new ProgramTournamentSyncService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String progID = req.getParameter("progID");
    try {
      syncSvc.syncState(progID);
      resp.sendRedirect(req.getContextPath() + "/programs/" + progID);
    } catch (ServiceException e) {
      throw new ServletException(e);
    }
  }
}
