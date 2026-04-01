package my.nexgenesports.controller.general;

import my.nexgenesports.service.general.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/paymentCallback")
public class PaymentCallbackServlet extends HttpServlet {
    private final PaymentService paymentSvc = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException
    {
        String module    = req.getParameter("module");
        int id           = Integer.parseInt(req.getParameter("id"));
        boolean paid     = Boolean.parseBoolean(req.getParameter("paid"));
        String reference = req.getParameter("reference");

        try {
            paymentSvc.handleCallback(module, id, paid, reference);
        } catch (SQLException | IllegalArgumentException e) {
            throw new ServletException("Payment callback failed", e);
        }

        // after success, send them to the right page:
        switch (module) {
            case "booking"    -> resp.sendRedirect(req.getContextPath() + "/manageBooking");
            case "membership" -> resp.sendRedirect(req.getContextPath() + "/manageMembership");
            case "pass"       -> resp.sendRedirect(req.getContextPath() + "/manageMembership");
            case "program"    ->
                // show the tournament/program details now that they're registered:
                resp.sendRedirect(req.getContextPath() + "/programs");
            default ->
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        }
    }
}
