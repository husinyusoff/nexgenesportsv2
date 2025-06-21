package my.nexgenesports.controller.user;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    HttpSession s = req.getSession(false);
    if (s != null) {
      s.invalidate();
    }
    // back to your public index page
    resp.sendRedirect(req.getContextPath() + "/index.jsp");
  }
}
