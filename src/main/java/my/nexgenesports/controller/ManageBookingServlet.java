package my.nexgenesports.controller;

import my.nexgenesports.model.Booking;
import my.nexgenesports.service.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageBooking")
public class ManageBookingServlet extends HttpServlet {
    private final BookingService bookingSvc = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userID = (String) session.getAttribute("username");

        List<Booking> mine = bookingSvc.listBookingsForUser(userID);
        req.setAttribute("bookings", mine);
        req.getRequestDispatcher("manageBooking.jsp")
           .forward(req, resp);
    }
}
