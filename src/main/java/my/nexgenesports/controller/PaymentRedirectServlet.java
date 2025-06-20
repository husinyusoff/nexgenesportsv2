// src/main/java/my/nexgenesports/controller/PaymentGatewayServlet.java
package my.nexgenesports.controller;

import my.nexgenesports.model.Booking;
import my.nexgenesports.service.BookingService;
import my.nexgenesports.service.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/redirectToPayment")
public class PaymentRedirectServlet extends HttpServlet {
    private final BookingService    bookingSvc    = new BookingService();
    private final PaymentService    paymentSvc    = new PaymentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) Auth check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2) Determine what we’re paying for
        boolean isBooking = req.getParameter("bookingID") != null;
        boolean isClub    = "club".equals(req.getParameter("type"));
        boolean isPass    = "pass".equals(req.getParameter("type"));

        String redirectUrl;
        try {
            if (isBooking) {
                // -- Station booking --
                int bookingId = Integer.parseInt(req.getParameter("bookingID"));
                Booking booking = bookingSvc.find(bookingId);
                if (booking == null) {
                    resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                    return;
                }
                BigDecimal amount = booking.getPrice();
                redirectUrl = paymentSvc.createCharge("booking", bookingId, amount);

            } else if (isClub) {
                // -- Club membership --
                // You should have inserted a UserClubMembership record BEFORE this step
                int ucmId      = Integer.parseInt(req.getParameter("ucmId"));
                BigDecimal fee = new BigDecimal(req.getParameter("fee"));
                redirectUrl = paymentSvc.createCharge("membership", ucmId, fee);

            } else if (isPass) {
                // -- Monthly gaming pass --
                // Similarly, you should have created a UserGamingPass record already
                int ugpId       = Integer.parseInt(req.getParameter("ugpId"));
                BigDecimal price = new BigDecimal(req.getParameter("price"));
                redirectUrl = paymentSvc.createCharge("pass", ugpId, price);

            } else {
                throw new IllegalArgumentException("Unknown payment type");
            }

        } catch (IOException | IllegalArgumentException e) {
            throw new ServletException("Payment initiation failed", e);
        }

        // 3) Redirect into the (simulated) gateway
        resp.sendRedirect(req.getContextPath() + redirectUrl);
    }
}
