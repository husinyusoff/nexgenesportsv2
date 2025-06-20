package my.nexgenesports.controller;

import my.nexgenesports.service.UserService;
import my.nexgenesports.service.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="RegisterServlet", urlPatterns="/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String userID        = req.getParameter("userID");
        String name          = req.getParameter("name");
        String password      = req.getParameter("password");
        String confirm       = req.getParameter("confirmPassword");
        String phone         = req.getParameter("phoneNumber");
        String role          = req.getParameter("role");
        if (role == null || role.isEmpty()) role = "athlete";
        String position      = req.getParameter("position");
        String clubSessionID = req.getParameter("clubSessionID");
        String gpParam       = req.getParameter("gamingPassID");
        Integer gamingPassID = (gpParam == null || gpParam.isEmpty()) 
                                ? null 
                                : Integer.valueOf(gpParam);

        try {
            userService.register(
                userID, name, password, confirm,
                phone, role, position,
                clubSessionID, gamingPassID
            );

            req.setAttribute("message", "✅ Registration successful! Please log in.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (ServiceException e) {
            req.setAttribute("message", e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
