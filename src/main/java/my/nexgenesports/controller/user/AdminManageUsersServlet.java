package my.nexgenesports.controller.user;

import my.nexgenesports.dao.user.RolePositionDao;
import my.nexgenesports.dao.user.UserDao;
import my.nexgenesports.model.RolePosition;
import my.nexgenesports.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminManageUsersServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();
    private final RolePositionDao roleDao = new RolePositionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<User> users = userDao.listAllUsers();
            List<RolePosition> roles = roleDao.listAllRoles();

            req.setAttribute("usersList", users);
            req.setAttribute("rolesList", roles);

            req.getRequestDispatcher("/adminManageUsers.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load users for administration.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // CSRF verification
        HttpSession session = req.getSession(false);
        String sessionToken = (session != null) ? (String) session.getAttribute("csrfToken") : null;
        String submittedToken = req.getParameter("csrfToken");

        if (sessionToken == null || submittedToken == null || !sessionToken.equals(submittedToken)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        String action = req.getParameter("action");
        if ("updateRole".equals(action)) {
            String targetUserID = req.getParameter("targetUserID");
            String rpIdStr = req.getParameter("rpId");

            if (targetUserID != null && rpIdStr != null) {
                try {
                    int rpId = Integer.parseInt(rpIdStr);
                    userDao.updateUserRole(targetUserID, rpId);
                    
                    req.getSession().setAttribute("adminSuccessMsg", "Successfully updated role for user: " + targetUserID);
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("adminErrorMsg", "Invalid role ID.");
                } catch (SQLException e) {
                    req.getSession().setAttribute("adminErrorMsg", "Database error updating user role: " + e.getMessage());
                }
            }
        } else if ("deactivate".equals(action)) {
            String targetUserID = req.getParameter("targetUserID");
            if (targetUserID != null) {
                try {
                    // ensure disabled role exists
                    try (java.sql.Connection c = my.nexgenesports.util.DBConnection.getConnection();
                         java.sql.Statement s = c.createStatement()) {
                        s.executeUpdate("INSERT IGNORE INTO roles (role) VALUES ('disabled')");
                        s.executeUpdate("INSERT IGNORE INTO role_positions (id, role, position) VALUES (6, 'disabled', NULL)");
                    } catch(Exception ignored) {} // ignore if already exists or other error
                    
                    // disabled role rpId is 6
                    userDao.updateUserRole(targetUserID, 6);
                    req.getSession().setAttribute("adminSuccessMsg", "Successfully deactivated user: " + targetUserID);
                } catch (SQLException e) {
                    req.getSession().setAttribute("adminErrorMsg", "Database error deactivating user: " + e.getMessage());
                }
            }
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
