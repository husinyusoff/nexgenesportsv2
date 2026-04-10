package my.nexgenesports.controller.booking;

import my.nexgenesports.model.Station;
import my.nexgenesports.service.booking.StationService;
import my.nexgenesports.util.PermissionChecker;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/selectStation")
public class SelectStationServlet extends HttpServlet {
    private final StationService stationSvc = new StationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        // 1) Auth + RBAC
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        @SuppressWarnings("unchecked")
        List<String> roles    = (List<String>) session.getAttribute("effectiveRoles");
        String       role     = (String) session.getAttribute("role");
        String       position = (String) session.getAttribute("position");

        if (!PermissionChecker.hasAccess(roles, role, position, "/selectStation")) {
            resp.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        // 2) Fetch all stations
        List<Station> stations = stationSvc.listAll();
        req.setAttribute("stations", stations);

        // 3) Push Dynamic Business Config limits to JSP
        my.nexgenesports.service.booking.BusinessConfigService cfg = new my.nexgenesports.service.booking.BusinessConfigService();
        int wdOpen = cfg.openingHour(java.time.DayOfWeek.MONDAY);
        int weOpen = cfg.openingHour(java.time.DayOfWeek.FRIDAY);
        int wdHappy = cfg.happyStart(java.time.DayOfWeek.MONDAY);
        int weHappy = cfg.happyStart(java.time.DayOfWeek.FRIDAY);
        int happyEnd = cfg.happyEnd();
        int closeHr = cfg.closingHour();
        
        req.setAttribute("wdOpen", wdOpen > 12 ? (wdOpen-12) + ":00 PM" : wdOpen + ":00 AM");
        req.setAttribute("weOpen", weOpen > 12 ? (weOpen-12) + ":00 PM" : weOpen + ":00 AM");
        req.setAttribute("wdHappy", wdHappy > 12 ? (wdHappy-12) + ":00 PM" : wdHappy + ":00 PM");
        req.setAttribute("weHappy", weHappy > 12 ? (weHappy-12) + ":00 PM" : weHappy + ":00 PM");
        req.setAttribute("happyEnd", happyEnd >= 12 ? (happyEnd == 24 ? "12:00 AM" : (happyEnd == 12 ? "12:00 PM" : (happyEnd-12) + ":00 PM")) : happyEnd + ":00 AM");
        req.setAttribute("closeHr", closeHr >= 12 ? (closeHr == 24 ? "12:00 AM" : (closeHr == 12 ? "12:00 PM" : (closeHr-12) + ":00 PM")) : closeHr + ":00 AM");

        // 3) Forward to view
        req.getRequestDispatcher("selectStation.jsp")
           .forward(req, resp);
    }
}
