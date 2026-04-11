package my.nexgenesports.controller.general;

import my.nexgenesports.dao.booking.BookingDao;
import my.nexgenesports.dao.memberships.UserClubMembershipDao;
import my.nexgenesports.dao.memberships.UserGamingPassDao;
import my.nexgenesports.dao.programTournament.ProgramTournamentDaoImpl;
import my.nexgenesports.model.Booking;
import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(DashboardServlet.class.getName());

    private final BookingDao            bookingDao    = new BookingDao();
    private final UserClubMembershipDao membershipDao = new UserClubMembershipDao();
    private final UserGamingPassDao     passDao       = new UserGamingPassDao();
    private final ProgramTournamentDaoImpl tourneyDao = new ProgramTournamentDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("username");
        LocalDate today = LocalDate.now();

        /* ── 1. Bookings ─────────────────────────────────────── */
        List<Booking> allBookings      = new ArrayList<>();
        List<Booking> paidBookings     = new ArrayList<>();
        List<Booking> upcomingBookings = new ArrayList<>();
        List<Booking> recentBookings   = new ArrayList<>();
        int totalHours = 0;

        try {
            allBookings = bookingDao.listByUser(userId);

            for (Booking b : allBookings) {
                if ("PAID".equalsIgnoreCase(b.getPaymentStatus())) {
                    paidBookings.add(b);
                    totalHours += b.getHourCount();
                }
                if (b.getDate() != null && !b.getDate().isBefore(today)
                        && "PAID".equalsIgnoreCase(b.getPaymentStatus())) {
                    upcomingBookings.add(b);
                }
            }

            // Sort upcoming: nearest first
            upcomingBookings.sort(Comparator.comparing(Booking::getDate)
                    .thenComparing(Booking::getStartTime));

            // Last 5 bookings regardless of status, newest first
            recentBookings = allBookings.stream()
                    .sorted(Comparator.comparing(Booking::getDate).reversed()
                            .thenComparing(Comparator.comparing(Booking::getStartTime).reversed()))
                    .limit(5)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            LOG.log(Level.WARNING, "Dashboard: error loading bookings for " + userId, e);
        }

        Booking nextBooking = upcomingBookings.isEmpty() ? null : upcomingBookings.get(0);

        /* ── 2. Club Membership ──────────────────────────────── */
        UserClubMembership membership = null;
        long membershipDaysLeft = 0;
        long membershipTotalDays = 0;

        try {
            membership = membershipDao.findLatestByUser(userId);
            if (membership != null && membership.getExpiryDate() != null
                    && membership.getPurchaseDate() != null) {
                java.time.LocalDate exp = membership.getExpiryDate().toLocalDate();
                java.time.LocalDate pur = membership.getPurchaseDate().toLocalDate();
                membershipDaysLeft  = Math.max(0, today.until(exp, java.time.temporal.ChronoUnit.DAYS));
                membershipTotalDays = Math.max(1, pur.until(exp, java.time.temporal.ChronoUnit.DAYS));
            }
        } catch (Exception e) {
            LOG.log(Level.WARNING, "Dashboard: error loading membership for " + userId, e);
        }

        /* ── 3. Gaming Pass ──────────────────────────────────── */
        UserGamingPass gamingPass = null;
        long passDaysLeft  = 0;
        long passTotalDays = 0;

        try {
            gamingPass = passDao.findLatestByUser(userId);
            if (gamingPass != null && gamingPass.getExpiryDate() != null
                    && gamingPass.getPurchaseDate() != null) {
                java.time.LocalDate exp = gamingPass.getExpiryDate().toLocalDate();
                java.time.LocalDate pur = gamingPass.getPurchaseDate().toLocalDate();
                passDaysLeft  = Math.max(0, today.until(exp, java.time.temporal.ChronoUnit.DAYS));
                passTotalDays = Math.max(1, pur.until(exp, java.time.temporal.ChronoUnit.DAYS));
            }
        } catch (Exception e) {
            LOG.log(Level.WARNING, "Dashboard: error loading gaming pass for " + userId, e);
        }

        /* ── 4. Open Tournaments ─────────────────────────────── */
        List<ProgramTournament> openTourneys = new ArrayList<>();
        try {
            List<ProgramTournament> allOpen =
                    tourneyDao.findByStatusIn(List.of(ProgramTournament.STATUS_OPEN));
            openTourneys = allOpen.stream()
                    .limit(3)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            LOG.log(Level.WARNING, "Dashboard: error loading open tournaments", e);
        }

        /* ── Set attributes ──────────────────────────────────── */
        req.setAttribute("dashTotalBookings",   paidBookings.size());
        req.setAttribute("dashTotalHours",      totalHours);
        req.setAttribute("dashUpcomingCount",   upcomingBookings.size());
        req.setAttribute("dashNextBooking",     nextBooking);
        req.setAttribute("dashRecentBookings",  recentBookings);
        req.setAttribute("dashMembership",      membership);
        req.setAttribute("dashMemDaysLeft",     membershipDaysLeft);
        req.setAttribute("dashMemTotalDays",    membershipTotalDays);
        req.setAttribute("dashGamingPass",      gamingPass);
        req.setAttribute("dashPassDaysLeft",    passDaysLeft);
        req.setAttribute("dashPassTotalDays",   passTotalDays);
        req.setAttribute("dashOpenTourneys",    openTourneys);

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
