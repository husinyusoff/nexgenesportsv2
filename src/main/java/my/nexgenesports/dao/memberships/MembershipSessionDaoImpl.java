package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MembershipSessionDaoImpl implements MembershipSessionDao {

    @Override
    public MembershipSession findById(String sessionId) throws SQLException {
        String sql = """
            SELECT sessionId, sessionName,
                   startMembershipDate, endMembershipDate,
                   fee, is_active, capacity_limit
              FROM membershipsessions
             WHERE sessionId = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public List<MembershipSession> findUpcomingAfter(LocalDateTime dateTime) throws SQLException {
        String sql = """
            SELECT sessionId, sessionName,
                   startMembershipDate, endMembershipDate,
                   fee, is_active, capacity_limit
              FROM membershipsessions
             WHERE startMembershipDate > ?
               AND is_active = 1
             ORDER BY startMembershipDate
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(dateTime));
            try (ResultSet rs = ps.executeQuery()) {
                List<MembershipSession> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    @Override
    public MembershipSession findActiveOn(LocalDateTime dateTime) throws SQLException {
        String sql = """
            SELECT sessionId, sessionName,
                   startMembershipDate, endMembershipDate,
                   fee, is_active, capacity_limit
              FROM membershipsessions
             WHERE startMembershipDate <= ?
               AND endMembershipDate   >= ?
               AND is_active = 1
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            Timestamp ts = Timestamp.valueOf(dateTime);
            ps.setTimestamp(1, ts);
            ps.setTimestamp(2, ts);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    private MembershipSession mapRow(ResultSet rs) throws SQLException {
        MembershipSession s = new MembershipSession();
        s.setSessionId(rs.getString("sessionId"));
        s.setSessionName(rs.getString("sessionName"));
        s.setStartMembershipDate(rs.getTimestamp("startMembershipDate").toLocalDateTime());
        s.setEndMembershipDate  (rs.getTimestamp("endMembershipDate").toLocalDateTime());
        s.setFee(rs.getBigDecimal("fee"));
        s.setActive(rs.getBoolean("is_active"));
        int cap = rs.getInt("capacity_limit");
        s.setCapacityLimit(rs.wasNull() ? null : cap);
        return s;
    }
}
