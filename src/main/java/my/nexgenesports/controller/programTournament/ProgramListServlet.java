// src/main/java/my/nexgenesports/controller/ProgramListServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/programs")
public class ProgramListServlet extends HttpServlet {
  private final ProgramTournamentService svc = new ProgramTournamentService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String status = req.getParameter("status");
    String mode   = req.getParameter("mode");

    List<ProgramTournament> list;
    try {
      if (status != null && !status.isEmpty()) {
        list = svc.listByStatus(status);
      } else {
        // default to ACTIVE
        list = svc.listActive();
      }
      if (mode != null && !mode.isEmpty()) {
        list = list.stream()
                   .filter(t -> t.getTournamentMode().name().equals(mode))
                   .collect(Collectors.toList());
      }
      req.setAttribute("tournaments", list);
      req.getRequestDispatcher("/WEB-INF/views/tournamentList.jsp")
         .forward(req, resp);

    } catch (SQLException e) {
      throw new ServletException(e);
    }
  }
}
