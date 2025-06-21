// src/main/java/my/nexgenesports/controller/AddStationServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.model.Station;
import my.nexgenesports.service.booking.StationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/stations/add")
public class AddStationServlet extends HttpServlet {
  private final StationService svc = new StationService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.getRequestDispatcher("/stationForm.jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    Station s = new Station();
    s.setStationID(req.getParameter("stationID"));
    s.setStationName(req.getParameter("stationName"));
    s.setNormalPrice1Player(new BigDecimal(req.getParameter("normalPrice1Player")));
    s.setNormalPrice2Player(
        req.getParameter("normalPrice2Player").isEmpty() ? null
      : new BigDecimal(req.getParameter("normalPrice2Player")));
    s.setHappyHourPrice1Player(new BigDecimal(req.getParameter("happyHourPrice1Player")));
    s.setHappyHourPrice2Player(
        req.getParameter("happyHourPrice2Player").isEmpty() ? null
      : new BigDecimal(req.getParameter("happyHourPrice2Player")));

    try {
      svc.create(s);
      resp.sendRedirect(req.getContextPath() + "/manageStations");
    } catch (IOException e) {
      throw new ServletException(e);
    }
  }
}
