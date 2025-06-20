// src/main/java/my/nexgenesports/controller/CheckoutServlet.java
package my.nexgenesports.controller;

import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.service.MembershipService;
import my.nexgenesports.service.PassService;
import my.nexgenesports.service.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final MembershipService ms     = new MembershipService();
    private final PassService       ps     = new PassService();
    private final PaymentService    paySvc = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Ensure user is logged in
        HttpSession session = req.getSession(false);
        String userId = (session != null) 
                      ? (String)session.getAttribute("username") 
                      : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2) Dispatch by type
        String type = req.getParameter("type");
        if (type == null) {
            resp.sendRedirect(req.getContextPath() + "/manageMembership");
            return;
        }

        String redirectUrl;
        try {
            switch (type) {
                case "membership" -> {
                    UserClubMembership m = ms.createPending(
                        userId,
                        req.getParameter("sessionId")
                    );
                    // use the session’s fee
                    redirectUrl = paySvc.createCharge(
                        "membership",
                        m.getId(),
                        m.getSession().getFee()
                    );
                }
                case "pass" -> {
                    int tierId = Integer.parseInt(req.getParameter("tierId"));
                    UserGamingPass p = ps.createPending(userId, tierId);
                    // use the tier’s price
                    redirectUrl = paySvc.createCharge(
                        "pass",
                        p.getId(),
                        p.getTier().getPrice()
                    );
                }
                default -> {
                    resp.sendRedirect(req.getContextPath() + "/manageMembership");
                    return;
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to prepare checkout", e);
        }

        // 3) Send to (simulated) payment gateway
        resp.sendRedirect(req.getContextPath() + redirectUrl);
    }
}
