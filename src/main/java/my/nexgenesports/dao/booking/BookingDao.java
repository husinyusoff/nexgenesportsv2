package my.nexgenesports.dao.booking;

import my.nexgenesports.model.Booking;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


public class BookingDao {
    private Booking mapRow(ResultSet r) throws SQLException {
        Booking b = new Booking();
        b.setBookingID      (r.getInt("bookingID"));
        b.setUserID         (r.getString("userID"));
        b.setStationID      (r.getString("stationID"));
        b.setDate           (r.getDate("date").toLocalDate());
        b.setStartTime      (r.getTime("startTime").toLocalTime());
        b.setEndTime        (r.getTime("endTime").toLocalTime());
        b.setStatus         (r.getString("status"));
        b.setPriceType      (r.getString("priceType"));
        b.setPlayerCount    (r.getInt("playerCount"));
        b.setPrice          (r.getBigDecimal("price"));
        b.setPaymentStatus  (r.getString("paymentStatus"));
        int pref = r.getInt("paymentReference");
        if (!r.wasNull()) b.setPaymentReference(pref);
        b.setHourCount      (r.getInt("hourCount"));
        return b;
    }

    /**
     * Insert a new booking (status="Confirmed", paymentStatus="PENDING").
     * @param b
     * @throws java.sql.SQLException
     */
    public void insert(Booking b) throws SQLException {
        String sql = ""
          + "INSERT INTO gamingstationbooking "
          + "(userID, stationID, date, startTime, endTime, "
          +  "status, priceType, playerCount, price, paymentStatus, hourCount) "
          + "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(   1, b.getUserID());
            ps.setString(   2, b.getStationID());
            ps.setDate(     3, Date.valueOf(b.getDate()));
            ps.setTime(     4, Time.valueOf(b.getStartTime()));
            ps.setTime(     5, Time.valueOf(b.getEndTime()));
            ps.setString(   6, b.getStatus());
            ps.setString(   7, b.getPriceType());
            ps.setInt(      8, b.getPlayerCount());
            ps.setBigDecimal(9, b.getPrice());          // ← total price
            ps.setString(  10, b.getPaymentStatus());
            ps.setInt(     11, b.getHourCount());

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    b.setBookingID(keys.getInt(1));
                }
            }
        }
    }

    public Booking findById(int id) throws SQLException {
        String sql = "SELECT * FROM gamingstationbooking WHERE bookingID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet r = ps.executeQuery()) {
                return r.next() ? mapRow(r) : null;
            }
        }
    }

    public List<Booking> listAll() throws SQLException {
        String sql = "SELECT * FROM gamingstationbooking ORDER BY date, startTime";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet r = ps.executeQuery()) {
            List<Booking> L = new ArrayList<>();
            while (r.next()) L.add(mapRow(r));
            return L;
        }
    }

    public List<Booking> listByStation(String stationID) throws SQLException {
        String sql = "SELECT * FROM gamingstationbooking WHERE stationID=? ORDER BY date, startTime";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, stationID);
            try (ResultSet r = ps.executeQuery()) {
                List<Booking> L = new ArrayList<>();
                while (r.next()) L.add(mapRow(r));
                return L;
            }
        }
    }

    public List<Booking> listByUser(String userID) throws SQLException {
        String sql = "SELECT * FROM gamingstationbooking WHERE userID=? ORDER BY date, startTime";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet r = ps.executeQuery()) {
                List<Booking> L = new ArrayList<>();
                while (r.next()) L.add(mapRow(r));
                return L;
            }
        }
    }

    public Set<Integer> getBookedHours(String stationID, LocalDate date) throws SQLException {
        String sql = ""
          + "SELECT startTime, endTime FROM gamingstationbooking "
          + "WHERE stationID=? AND date=? AND status='Confirmed'";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, stationID);
            ps.setDate(  2, Date.valueOf(date));
            try (ResultSet r = ps.executeQuery()) {
                Set<Integer> hours = new HashSet<>();
                while (r.next()) {
                    LocalTime st = r.getTime("startTime").toLocalTime();
                    LocalTime et = r.getTime("endTime").toLocalTime();
                    for (int hr = st.getHour(); hr <= et.getHour(); hr++) {
                        hours.add(hr);
                    }
                }
                return hours;
            }
        }
    }

    public void updateStatus(int bookingID, String newStatus) throws SQLException {
        String sql = "UPDATE gamingstationbooking SET status=? WHERE bookingID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(   2, bookingID);
            ps.executeUpdate();
        }
    }

    public void updatePaymentStatus(int bookingID, String paymentStatus, Integer reference)
            throws SQLException {
        String sql = "UPDATE gamingstationbooking SET paymentStatus=?, paymentReference=? WHERE bookingID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            if (reference == null) ps.setNull(2, Types.INTEGER);
            else                   ps.setInt(2, reference);
            ps.setInt(3, bookingID);
            ps.executeUpdate();
        }
    }

    public void delete(int bookingID) throws SQLException {
        String sql = "DELETE FROM gamingstationbooking WHERE bookingID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.executeUpdate();
        }
    }
}
