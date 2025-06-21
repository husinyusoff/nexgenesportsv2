// src/main/java/my/nexgenesports/controller/BookingDetailsServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.model.Booking;
import my.nexgenesports.service.booking.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/bookingDetails")
public class BookingDetailsServlet extends HttpServlet {
  private final BookingService svc = new BookingService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int id = Integer.parseInt(req.getParameter("bookingID"));
    Booking b = svc.find(id);
    req.setAttribute("bk", b);
    req.getRequestDispatcher("/bookingDetails.jsp").forward(req, resp);
  }
}
