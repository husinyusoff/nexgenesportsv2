package my.nexgenesports.controller.user;

import my.nexgenesports.model.User;
import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.user.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

/**
 * Consolidated authentication controller.
 * Handles: login, register, logout, forgotPassword, resetPassword.
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/auth", "/LoginServlet", "/RegisterServlet", "/logout"})
public class AuthServlet extends HttpServlet {
    private final UserService userSvc = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = resolveAction(req);

        switch (action) {
            case "logout":
                doLogout(req, resp);
                break;
            case "resetPassword":
                req.setAttribute("token", req.getParameter("token"));
                req.getRequestDispatcher("/resetPassword.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = resolveAction(req);

        switch (action) {
            case "login":
                doLogin(req, resp);
                break;
            case "register":
                doRegister(req, resp);
                break;
            case "forgotPassword":
                doForgotPassword(req, resp);
                break;
            case "resetPassword":
                doResetPassword(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    /* ---- ACTIONS ---- */

    private void doLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userID       = req.getParameter("userID");
        String password     = req.getParameter("password");
        String selectedRole = req.getParameter("selectedRole");

        try {
            User user = userSvc.authenticate(userID, password, selectedRole);

            HttpSession session = req.getSession(true);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
            session.setAttribute("username",       userID);
            session.setAttribute("role",           selectedRole);
            session.setAttribute("position",       user.getPosition());
            session.setAttribute("effectiveRoles", userSvc.getEffectiveRoles(selectedRole, user.getPosition()));
            session.setAttribute("csrfToken",      UUID.randomUUID().toString());

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        } catch (ServiceException e) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=badcreds");
        }
    }

    private void doRegister(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String userID   = req.getParameter("userID");
        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");
        String phone    = req.getParameter("phoneNumber");
        String matric   = req.getParameter("matricNumber");
        try {
            userSvc.register(userID, name, email, password, confirm, phone, matric, null, null);
            resp.sendRedirect(req.getContextPath() + "/register.jsp?status=success");
        } catch (ServiceException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }

    private void doLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private void doForgotPassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String email = req.getParameter("email");
        try {
            userSvc.requestPasswordReset(email);
            req.setAttribute("successMsg", "A password reset link has been generated. Check the server console.");
        } catch (ServiceException e) {
            req.setAttribute("errorMsg", e.getMessage());
        }
        req.getRequestDispatcher("/forgotPassword.jsp").forward(req, resp);
    }

    private void doResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String token   = req.getParameter("token");
        String newPwd  = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        try {
            userSvc.resetPassword(token, newPwd, confirm);
            resp.sendRedirect(req.getContextPath() + "/login.jsp?status=passwordReset");
        } catch (ServiceException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.setAttribute("token", token);
            req.getRequestDispatcher("/resetPassword.jsp").forward(req, resp);
        }
    }

    /* ---- HELPERS ---- */

    private String resolveAction(HttpServletRequest req) {
        String action = req.getParameter("action");
        if (action != null && !action.isEmpty()) return action;

        String path = req.getServletPath();
        if ("/LoginServlet".equals(path))    return "login";
        if ("/RegisterServlet".equals(path))  return "register";
        if ("/logout".equals(path))           return "logout";

        return "login";
    }
}
