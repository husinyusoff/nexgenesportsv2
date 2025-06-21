// src/main/java/my/nexgenesports/controller/ListStationsServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.model.Station;
import my.nexgenesports.service.booking.StationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageStations")
public class ListStationsServlet extends HttpServlet {
  private final StationService svc = new StationService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
      List<Station> all = svc.listAll();
      req.setAttribute("stations", all);
      req.getRequestDispatcher("/manageStations.jsp")
              .forward(req, resp);
  }
}
