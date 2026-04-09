package my.nexgenesports.controller.general;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/keepalive")
public class KeepAliveServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        // Accessing the session passively keeps it alive in Tomcat
        HttpSession session = request.getSession(false);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (session != null && session.getAttribute("username") != null) {
            response.getWriter().write("{\"status\": \"active\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"expired\"}");
        }
    }
}
