// src/main/java/my/nexgenesports/controller/DeleteBookingServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.service.booking.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/booking/delete")
public class DeleteBookingServlet extends HttpServlet {
  private final BookingService svc = new BookingService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    int id = Integer.parseInt(req.getParameter("bookingID"));
    try {
      svc.delete(id);
      resp.sendRedirect(req.getContextPath() + "/manageBookings");
    } catch (IOException e) {
      throw new ServletException(e);
    }
  }
}
