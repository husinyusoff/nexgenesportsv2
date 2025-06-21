package my.nexgenesports.service.booking;

import my.nexgenesports.dao.booking.BookingDao;
import my.nexgenesports.model.Booking;
import my.nexgenesports.model.Station;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import my.nexgenesports.service.general.ServiceException;

/**
 * Encapsulates all booking‐related business logic.
 */
public class BookingService {

    private final BookingDao dao = new BookingDao();
    private final StationService stationSvc = new StationService();
    private final BusinessConfigService cfg = new BusinessConfigService();

    /**
     * Create (and persist) a new gaming-station booking.Validates: - date not
     * in the past - slots are within opening hours - slots are consecutive - no
     * overlap with existing Confirmed bookings
     *
     * Then: - computes total price - inserts with status="Confirmed",
     * paymentStatus="PENDING"
     *
     * @param userID
     * @param stationID
     * @param date
     * @param selectedSlots
     * @param playerCount
     * @param priceType
     * @return the newly created Booking (with bookingID set)
     * @throws java.sql.SQLException
     */
public Booking createBooking(
            String userID,
            String stationID,
            LocalDate date,
            List<Integer> selectedSlots,
            int playerCount,
            String priceType
    ) throws SQLException {
        DayOfWeek dow   = date.getDayOfWeek();
        int       open  = cfg.openingHour(dow);
        int       close = cfg.closingHour();

        if (date.isBefore(LocalDate.now())) {
            throw new ServiceException("Cannot book a past date.");
        }

        Collections.sort(selectedSlots);
        for (int i = 0; i < selectedSlots.size(); i++) {
            int hr = selectedSlots.get(i);
            if (hr < open || hr > close) {
                throw new ServiceException("Time slot " + hr + ":00 is outside operating hours.");
            }
            if (i > 0 && selectedSlots.get(i) != selectedSlots.get(i - 1) + 1) {
                throw new ServiceException("Please select consecutive time slots.");
            }
        }

        // check overlap
        Set<Integer> booked = dao.getBookedHours(stationID, date);
        for (int hr : selectedSlots) {
            if (booked.contains(hr)) {
                throw new ServiceException("Time slot " + hr + ":00 is already booked.");
            }
        }

        // assemble Booking
        Booking b = new Booking();
        b.setUserID(userID);
        b.setStationID(stationID);
        b.setDate(date);
        b.setStartTime(LocalTime.of(selectedSlots.get(0), 0));
        int last = selectedSlots.get(selectedSlots.size() - 1);
        b.setEndTime(LocalTime.of(last, 59));
        b.setStatus("Confirmed");
        b.setPriceType(priceType);
        b.setPlayerCount(playerCount);
        b.setHourCount(selectedSlots.size());
        b.setPaymentStatus("PENDING");

        // price calculation
        Station s = stationSvc.find(stationID);
        BigDecimal rate;
        if ("Normal".equals(priceType)) {
            rate = playerCount == 1
                 ? s.getNormalPrice1Player()
                 : s.getNormalPrice2Player();
        } else {
            rate = playerCount == 1
                 ? s.getHappyHourPrice1Player()
                 : s.getHappyHourPrice2Player();
        }
        b.setPrice(rate.multiply(BigDecimal.valueOf(b.getHourCount())));

        try {
            dao.insert(b);
            return b;
        } catch (SQLException e) {
            throw new ServiceException("Failed to create booking", e);
        }
    }

    /**
     * Admin: list everyone’s bookings
     *
     * @return
     */
    public List<Booking> listAllBookings() {
        try {
            return dao.listAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed to list all bookings", e);
        }
    }

    /**
     * Admin: filter by station
     *
     * @param stationID
     * @return
     */
    public List<Booking> listByStation(String stationID) {
        try {
            return dao.listByStation(stationID);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list bookings for station " + stationID, e);
        }
    }

    /**
     * Athlete: list only their own bookings
     *
     * @param userID
     * @return
     */
    public List<Booking> listBookingsForUser(String userID) {
        try {
            return dao.listByUser(userID);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list bookings for user " + userID, e);
        }
    }

    /**
     * BookingDetailsServlet → load one booking
     *
     * @param bookingID
     * @return
     */
    public Booking find(int bookingID) {
        try {
            Booking b = dao.findById(bookingID);
            if (b == null) {
                throw new ServiceException("No booking with ID " + bookingID);
            }
            return b;
        } catch (SQLException e) {
            throw new ServiceException("Failed to load booking " + bookingID, e);
        }
    }

    /**
     * Athlete: delete one of their bookings
     *
     * @param bookingID
     */
    public void delete(int bookingID) {
        try {
            dao.delete(bookingID);
        } catch (SQLException e) {
            throw new ServiceException("Failed to delete booking " + bookingID, e);
        }
    }

    /**
     * UpdateBookingServlet → change status
     *
     * @param bookingID
     * @param newStatus
     */
    public void updateStatus(int bookingID, String newStatus) {
        try {
            dao.updateStatus(bookingID, newStatus);
        } catch (SQLException e) {
            throw new ServiceException("Failed to update status for booking " + bookingID, e);
        }
    }

    /**
     * After payment callback/webhook
     *
     * @param bookingID
     * @param paymentStatus
     * @param reference
     */
    public void updatePaymentStatus(int bookingID, String paymentStatus, Integer reference) {
        try {
            dao.updatePaymentStatus(bookingID, paymentStatus, reference);
        } catch (SQLException e) {
            throw new ServiceException("Failed to update payment status for booking " + bookingID, e);
        }
    }

    /**
     * Validation helper: which hours are already booked?
     *
     * @param stationID
     * @param date
     * @return
     */
    public Set<Integer> getBookedHours(String stationID, LocalDate date) {
        try {
            return dao.getBookedHours(stationID, date);
        } catch (SQLException e) {
            throw new ServiceException("Failed to fetch booked hours", e);
        }
    }

    /**
     * Validation helper: opening hour (Fri/Sat=15, else 14)
     *
     * @param date
     * @return
     */
    public int getOpeningHour(LocalDate date) {
        DayOfWeek dow = date.getDayOfWeek();
        return (dow == DayOfWeek.FRIDAY || dow == DayOfWeek.SATURDAY) ? 15 : 14;
    }
}
