package my.nexgenesports.controller.programTournament;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

@WebServlet("/programs/changeStatus")
public class ProgramTournamentChangeStatusServlet extends HttpServlet {
  private final ProgramTournamentService svc = new ProgramTournamentService();

    @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String progId   = req.getParameter("progId");
    String newStatus= req.getParameter("newStatus");
    svc.changeStatus(progId, newStatus);
    resp.sendRedirect(req.getContextPath() + "/programs");
  }
}
