// src/main/java/my/nexgenesports/controller/ProgramDetailServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.ProgramTournamentSync;
import my.nexgenesports.model.ProgramType; 
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.programTournament.ProgramTournamentSyncService;
import my.nexgenesports.service.general.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/programs/*")
public class ProgramDetailServlet extends HttpServlet {
  private final ProgramTournamentService      svc    = new ProgramTournamentService();
  private final ProgramTournamentSyncService syncSvc = new ProgramTournamentSyncService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String progID = req.getRequestURI().split("/")[2];
    try {
      ProgramTournament t = svc.findById(progID);
      if (t==null) {
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
      }
      req.setAttribute("tournament", t);

if (t.getProgramType() == ProgramType.TOURNAMENT) {
    // unwrap Optional safely
    req.setAttribute("sync",
       syncSvc.findByProgId(progID).orElse(null));
}

      // TODO: load participants/brackets into request

      req.getRequestDispatcher("/WEB-INF/views/tournamentDetail.jsp")
         .forward(req, resp);

    } catch (SQLException | ServiceException e) {
      throw new ServletException(e);
    }
  }
}
