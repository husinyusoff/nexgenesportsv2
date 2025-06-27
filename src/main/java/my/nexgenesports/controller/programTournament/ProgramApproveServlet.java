// src/main/java/my/nexgenesports/controller/ProgramApproveServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.general.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/programs/approve")
public class ProgramApproveServlet extends HttpServlet {
  private final ProgramTournamentService svc = new ProgramTournamentService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String progID = req.getParameter("progID");
    try {
      svc.approve(progID);
      resp.sendRedirect(req.getContextPath() + "/programs/" + progID);
    } catch (SQLException | ServiceException e) {
      throw new ServletException(e);
    }
  }
}
