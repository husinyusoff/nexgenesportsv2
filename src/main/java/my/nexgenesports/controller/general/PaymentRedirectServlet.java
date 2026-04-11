package my.nexgenesports.controller.general;

import my.nexgenesports.model.Booking;
import my.nexgenesports.service.booking.BookingService;
import my.nexgenesports.service.general.PaymentService;
import my.nexgenesports.service.programTournament.ParticipantService;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.ArrayList;

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
    private final MembershipService memSvc            = new MembershipService();
    private final PassService passSvc                 = new PassService();

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
                    String userID = (String) session.getAttribute("username");
                    String stationID = req.getParameter("stationID");
                    LocalDate date = LocalDate.parse(req.getParameter("date"));
                    int playerCount = Integer.parseInt(req.getParameter("playerCount"));
                    String priceType = req.getParameter("priceType");
                    String[] slotsArray = req.getParameterValues("slots");
                    List<Integer> slots = new ArrayList<>();
                    if (slotsArray != null) {
                        for (String s : slotsArray) {
                            slots.add(Integer.valueOf(s));
                        }
                    }
                    Booking b = bookingSvc.createBooking(userID, stationID, date, slots, playerCount, priceType);
                    redirectUrl = paymentSvc.createCharge("booking", b.getBookingID(), b.getPrice());
                    if (b.getPaymentDeadline() != null) {
                        long dMs = b.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
                        redirectUrl += "&deadlineMillis=" + dMs;
                    }
                }

                case "membership" -> {
                    String userID = (String) session.getAttribute("username");
                    String sessionIdParam = req.getParameter("sessionId");
                    UserClubMembership ucm = memSvc.createPending(userID, sessionIdParam);
                    BigDecimal fee = new BigDecimal(req.getParameter("fee"));
                    redirectUrl = paymentSvc.createCharge("membership", ucm.getId(), fee);
                    if (ucm.getPaymentDeadline() != null) {
                        long dMs = ucm.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
                        redirectUrl += "&deadlineMillis=" + dMs;
                    }
                }

                case "pass" -> {
                    String userID = (String) session.getAttribute("username");
                    int tierId = Integer.parseInt(req.getParameter("tierId"));
                    UserGamingPass ugp = passSvc.createPending(userID, tierId);
                    BigDecimal p    = new BigDecimal(req.getParameter("price"));
                    redirectUrl = paymentSvc.createCharge("pass", ugp.getId(), p);
                    if (ugp.getPaymentDeadline() != null) {
                        long dMs = ugp.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
                        redirectUrl += "&deadlineMillis=" + dMs;
                    }
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
