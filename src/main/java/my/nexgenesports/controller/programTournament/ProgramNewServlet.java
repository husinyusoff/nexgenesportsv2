// src/main/java/my/nexgenesports/controller/ProgramNewServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/programs/new")
public class ProgramNewServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    // empty bean for form‐binding
    req.setAttribute("program", new ProgramTournament());
    req.getRequestDispatcher("/WEB-INF/views/tournamentForm.jsp")
       .forward(req, resp);
  }
}
