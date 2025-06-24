// src/main/java/my/nexgenesports/controller/BusinessConfigServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.service.booking.BusinessConfigService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/business-hours")
public class BusinessConfigServlet extends HttpServlet {
    private final BusinessConfigService cfg = new BusinessConfigService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("cfg", cfg);
        req.getRequestDispatcher("businessHours.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        cfg.set("weekday_open",       Integer.parseInt(req.getParameter("weekday_open")));
        cfg.set("weekend_open",       Integer.parseInt(req.getParameter("weekend_open")));
        cfg.set("closing_hour",       Integer.parseInt(req.getParameter("closing_hour")));
        cfg.set("happy_start_offset", Integer.parseInt(req.getParameter("happy_start_offset")));
        cfg.set("happy_end_hour",     Integer.parseInt(req.getParameter("happy_end_hour")));
        resp.sendRedirect(req.getContextPath() + "/admin/business-hours");
    }
}
