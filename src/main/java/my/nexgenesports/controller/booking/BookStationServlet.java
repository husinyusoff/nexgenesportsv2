package my.nexgenesports.controller.booking;

import my.nexgenesports.model.Booking;
import my.nexgenesports.model.Station;
import my.nexgenesports.service.booking.BookingService;
import my.nexgenesports.service.booking.BusinessConfigService;
import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.booking.StationService;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.util.PricingEngine;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.*;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/bookStation")
public class BookStationServlet extends HttpServlet {

    private final BookingService bookingSvc = new BookingService();
    private final StationService stationSvc = new StationService();
    private final BusinessConfigService cfg = new BusinessConfigService();
    private final MembershipService memSvc = new MembershipService();
    private final PassService passSvc = new PassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // — STEP 0: prevent past‐date pick
        LocalDate today = LocalDate.now();
        req.setAttribute("minDate", today.toString());
        
        bookingSvc.expirePendingBookings();

        String stationID   = req.getParameter("stationID");
        String pcParam     = req.getParameter("playerCount");
        if (stationID == null || pcParam == null) {
            resp.setContentType("text/html;charset=UTF-8");
            resp.getWriter().write("<div class='error'>Error: Missing stationID or playerCount parameters.</div>");
            return;
        }
        int playerCount = Integer.parseInt(pcParam);

        Station st = stationSvc.find(stationID);
        req.setAttribute("stationID", stationID);
        req.setAttribute("stationName", st.getStationName());
        req.setAttribute("playerCount", playerCount);

        // defaults for JSP
        req.setAttribute("showSlots",  false);
        req.setAttribute("isToday",    false);
        req.setAttribute("currentHour", 0);

        String dateParam = req.getParameter("date");
        if (dateParam != null && !dateParam.isEmpty()) {
            LocalDate d = LocalDate.parse(dateParam);
            req.setAttribute("selectedDate", d.toString());

            boolean showSlots = !d.isBefore(today);
            req.setAttribute("showSlots", showSlots);

            if (showSlots) {
                // opening & booked hours
                int openHour = bookingSvc.getOpeningHour(d);
                req.setAttribute("openingHour", openHour);

                Set<Integer> booked = bookingSvc.getBookedHours(stationID, d);
                req.setAttribute("bookedHours", booked);

                // if it's today, tell JSP which hours have already passed
                boolean isToday = d.equals(today);
                req.setAttribute("isToday", isToday);
                if (isToday) {
                    int currentHour = LocalTime.now().getHour();
                    req.setAttribute("currentHour", currentHour);
                }
            }
        }

        req.getRequestDispatcher("slotFragment.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            String userID       = (String) session.getAttribute("username");
            String stationID    = req.getParameter("stationID");
            LocalDate date      = LocalDate.parse(req.getParameter("date"));
            int playerCount     = Integer.parseInt(req.getParameter("playerCount"));

            // parse & sort selected slots
            List<Integer> slots = List.of(req.getParameterValues("timeSlots")).stream()
                    .map(Integer::valueOf)
                    .sorted()
                    .collect(Collectors.toList());

            // decide priceType based on business_config
            DayOfWeek dow    = date.getDayOfWeek();
            int happyStart   = cfg.happyStart(dow);
            int happyEnd     = cfg.happyEnd();
            int firstHr      = slots.get(0);

            String priceType = (firstHr >= happyStart && firstHr <= happyEnd)
                    ? "HappyHour"
                    : "Normal";
            // create summary booking record (unpersisted)
            Booking b = bookingSvc.buildDraftBooking(
                userID, stationID, date, slots, playerCount, priceType
            );

            // Calculate Discounts
            UserClubMembership mem = memSvc.getCurrentMembership(userID);
            UserGamingPass pass = passSvc.getCurrentPass(userID);
            
            int memDiscount = (mem != null) ? mem.getSession().getDiscountRate() : 0;
            int passDiscount = (pass != null) ? pass.getTier().getDiscountRate() : 0;
            
            PricingEngine.PricingResult pricing = PricingEngine.calculate(b.getPrice(), memDiscount, passDiscount);

            req.setAttribute("booking", b);
            req.setAttribute("slots", slots);
            req.setAttribute("activeMem", mem);
            req.setAttribute("activePass", pass);
            req.setAttribute("pricing", pricing);
            
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);

        } catch (ServiceException e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
