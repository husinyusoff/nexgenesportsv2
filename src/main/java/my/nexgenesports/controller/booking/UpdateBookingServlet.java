// src/main/java/my/nexgenesports/controller/UpdateBookingServlet.java
package my.nexgenesports.controller.booking;

import my.nexgenesports.service.booking.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/booking/update")
public class UpdateBookingServlet extends HttpServlet {

    private final BookingService svc = new BookingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("bookingID"));
        String newStatus = req.getParameter("status");
        try {
            svc.updateStatus(id, newStatus);
            resp.sendRedirect(req.getContextPath() + "/manageBookings");
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }
}
