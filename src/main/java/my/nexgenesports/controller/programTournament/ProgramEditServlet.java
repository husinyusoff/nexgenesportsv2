// src/main/java/my/nexgenesports/controller/ProgramEditServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.general.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/programs/*/edit")
public class ProgramEditServlet extends HttpServlet {
  private final ProgramTournamentService svc = new ProgramTournamentService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    // extract progID from path: /programs/{progID}/edit
    String path = req.getRequestURI();
    String progID = path.split("/")[2];

    try {
      ProgramTournament t = null;
        try {
            t = svc.findById(progID);
        } catch (SQLException ex) {
            Logger.getLogger(ProgramEditServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
      if (t == null) {
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
      }
      req.setAttribute("program", t);
      req.getRequestDispatcher("/WEB-INF/views/tournamentForm.jsp")
         .forward(req, resp);

    } catch (ServiceException e) {
      throw new ServletException(e);
    }
  }
}
