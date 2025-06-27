// src/main/java/my/nexgenesports/controller/ProgramJoinServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.general.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/programs/join")
public class ProgramJoinServlet extends HttpServlet {
  private final ProgramTournamentService svc = new ProgramTournamentService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String progID = req.getParameter("progID");
    String userId = (String)req.getSession().getAttribute("userId");

    try {
        try {
            svc.joinTournament(progID, userId);
        } catch (SQLException ex) {
            Logger.getLogger(ProgramJoinServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
      resp.sendRedirect(req.getContextPath() + "/programs/" + progID);
    } catch (ServiceException e) {
      throw new ServletException(e);
    }
  }
}
