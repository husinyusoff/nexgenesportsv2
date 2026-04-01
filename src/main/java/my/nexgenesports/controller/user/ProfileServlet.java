package my.nexgenesports.controller.user;

import my.nexgenesports.model.User;
import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.user.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Profile management controller.
 * Handles: /manageProfile (basic info) and /inGameProfile (esports identity).
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/manageProfile", "/inGameProfile"})
public class ProfileServlet extends HttpServlet {
    private final UserService userSvc = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = (String) req.getSession().getAttribute("username");
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = userSvc.getProfile(username);
        req.setAttribute("user", user);

        String path = req.getServletPath();
        if ("/inGameProfile".equals(path)) {
            req.getRequestDispatcher("/inGameProfile.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/manageProfile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = (String) req.getSession().getAttribute("username");
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();

        try {
            User user = userSvc.getProfile(username);

            if ("/inGameProfile".equals(path)) {
                user.setIgn(req.getParameter("ign"));
                user.setBio(req.getParameter("bio"));
                user.setDiscordID(req.getParameter("discordID"));
            } else {
                user.setUserID(req.getParameter("userID"));
                user.setName(req.getParameter("name"));
                user.setEmail(req.getParameter("email"));
                user.setPhoneNumber(req.getParameter("phoneNumber"));
                user.setMatricNumber(req.getParameter("matricNumber"));
            }

            userSvc.updateProfile(user, username);

            // Update session if username changed
            if (!user.getUserID().equals(username)) {
                req.getSession().setAttribute("username", user.getUserID());
            }

            req.setAttribute("user", user);
            req.setAttribute("successMsg", "Profile updated successfully!");

        } catch (ServiceException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.setAttribute("user", userSvc.getProfile(username));
        }

        if ("/inGameProfile".equals(path)) {
            req.getRequestDispatcher("/inGameProfile.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/manageProfile.jsp").forward(req, resp);
        }
    }
}
