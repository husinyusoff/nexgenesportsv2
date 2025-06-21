// src/main/java/my/nexgenesports/controller/ListBookingsServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.model.Booking;
import my.nexgenesports.service.booking.BookingService;
import my.nexgenesports.service.booking.StationService;
import my.nexgenesports.model.Station;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/manageBookings")
public class ListBookingsServlet extends HttpServlet {
  private final BookingService bsvc = new BookingService();
  private final StationService   ssvc = new StationService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String filterStation = req.getParameter("stationID");
    List<Booking> list = (filterStation == null || filterStation.isEmpty())
            ? bsvc.listAllBookings()
            : bsvc.listByStation(filterStation);
    List<Station> stations = ssvc.listAll();
    req.setAttribute("bookings", list);
    req.setAttribute("stations", stations);
    req.getRequestDispatcher("/manageBookings.jsp").forward(req, resp);
  }
}
