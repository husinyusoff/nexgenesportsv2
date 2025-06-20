package my.nexgenesports.controller;

import my.nexgenesports.model.Station;
import my.nexgenesports.service.StationService;
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

        // 3) Forward to view
        req.getRequestDispatcher("selectStation.jsp")
           .forward(req, resp);
    }
}
