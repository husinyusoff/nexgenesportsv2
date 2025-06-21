// src/main/java/my/nexgenesports/controller/PaymentCallbackServlet.java
package my.nexgenesports.controller.user;

import my.nexgenesports.service.general.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/paymentCallback")
public class PaymentCallbackServlet extends HttpServlet {
    private final PaymentService paySvc = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String module    = req.getParameter("module");
        int    id        = Integer.parseInt(req.getParameter("id"));
        boolean paid     = Boolean.parseBoolean(req.getParameter("paid"));
        String reference = req.getParameter("reference");

        try {
            paySvc.handleCallback(module, id, paid, reference);
        } catch (SQLException e) {
            throw new ServletException("Payment callback failed", e);
        }

        // redirect wherever makes sense
        resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
    }
}
