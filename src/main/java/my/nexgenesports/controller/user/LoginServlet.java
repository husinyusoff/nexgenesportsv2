package my.nexgenesports.controller.user;

import my.nexgenesports.model.User;
import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.user.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final UserService userSvc = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String userID       = req.getParameter("userID");
        String password     = req.getParameter("password");
        String selectedRole = req.getParameter("selectedRole");

        try {
            User user = userSvc.authenticate(userID, password, selectedRole);

            HttpSession session = req.getSession(true);
            session.setAttribute("username",       userID);
            session.setAttribute("role",           selectedRole);
            session.setAttribute("position",       user.getPosition());   // ← now compiles
            session.setAttribute("effectiveRoles", userSvc.getEffectiveRoles(selectedRole, user.getPosition()));
            session.setAttribute("csrfToken",      UUID.randomUUID().toString());

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        } catch (ServiceException e) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=badcreds");
        }
    }
}
