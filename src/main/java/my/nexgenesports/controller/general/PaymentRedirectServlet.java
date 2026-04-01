package my.nexgenesports.controller.general;

import my.nexgenesports.model.Booking;
import my.nexgenesports.service.booking.BookingService;
import my.nexgenesports.service.general.PaymentService;
import my.nexgenesports.service.programTournament.ParticipantService;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Enumeration;

@WebServlet("/redirectToPayment")
public class PaymentRedirectServlet extends HttpServlet {
    private final BookingService bookingSvc            = new BookingService();
    private final ProgramTournamentService programSvc = new ProgramTournamentService();
    private final ParticipantService partSvc          = new ParticipantService();
    private final PaymentService paymentSvc           = new PaymentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException 
    {
        log("=== redirectToPayment.doPost() start ===");
        logInputs(req);

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String module = req.getParameter("module");
        if (module == null || module.isBlank()) {
            throw new ServletException("Missing module");
        }
        log("Authenticated user = " + session.getAttribute("username"));
        log("Payment module = " + module);

        String redirectUrl;
        try {
            switch (module) {
                case "program", "tournament" -> {
                    int progId = Integer.parseInt(req.getParameter("progId"));
                    BigDecimal amount = programSvc.getProgramById(progId).getProgFee();
                    String teamParam = req.getParameter("teamId");
                    Integer teamId = (teamParam == null || teamParam.isBlank())
                                   ? null
                                   : Integer.valueOf(teamParam);
                    String[] users = req.getParameterValues("user");
                    String[] roles = req.getParameterValues("role");
                    int leaderId = -1;
                    for (int i = 0; i < users.length; i++) {
                        int pid = partSvc.createPending(
                            progId, 
                            users[i], 
                            teamId, 
                            roles[i]
                        );
                        if (leaderId < 0) {
                            leaderId = pid;
                        }
                    }
                    redirectUrl = paymentSvc.createCharge(module, leaderId, amount);
                }

                case "booking" -> {
                    int bookingId = Integer.parseInt(req.getParameter("bookingID"));
                    Booking b = bookingSvc.find(bookingId);
                    redirectUrl = paymentSvc.createCharge("booking", bookingId, b.getPrice());
                }

                case "membership" -> {
                    int ucmId = Integer.parseInt(req.getParameter("ucmId"));
                    BigDecimal fee = new BigDecimal(req.getParameter("fee"));
                    redirectUrl = paymentSvc.createCharge("membership", ucmId, fee);
                }

                case "pass" -> {
                    int ugpId = Integer.parseInt(req.getParameter("ugpId"));
                    BigDecimal p    = new BigDecimal(req.getParameter("price"));
                    redirectUrl = paymentSvc.createCharge("pass", ugpId, p);
                }

                default -> throw new IllegalArgumentException("Unknown module: " + module);
            }
        } catch (Exception e) {
            log("Payment initiation failed", e);
            throw new ServletException("Payment initiation failed", e);
        }

        log("Redirecting to: " + redirectUrl);
        resp.sendRedirect(req.getContextPath() + redirectUrl);
    }

    private void logInputs(HttpServletRequest req) {
        log("Session ID: " + req.getSession().getId());
        for (Enumeration<String> en = req.getParameterNames(); en.hasMoreElements();) {
            String name = en.nextElement();
            log("  param `" + name + "` = `" + req.getParameter(name) + "`");
        }
    }
}
