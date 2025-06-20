// src/main/java/my/nexgenesports/controller/EditStationServlet.java
package my.nexgenesports.controller;

import my.nexgenesports.model.Station;
import my.nexgenesports.service.StationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/stations/edit")
public class EditStationServlet extends HttpServlet {
  private final StationService svc = new StationService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String id = req.getParameter("stationID");
    Station s = svc.find(id);
    req.setAttribute("station", s);
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
      svc.update(s);
      resp.sendRedirect(req.getContextPath() + "/manageStations");
    } catch (IOException e) {
      throw new ServletException(e);
    }
  }
}
