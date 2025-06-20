// src/main/java/my/nexgenesports/dao/MembershipSessionDaoImpl.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MembershipSessionDaoImpl implements MembershipSessionDao {
    @Override
    public MembershipSession findById(String sessionId) throws SQLException {
        String sql = """
            SELECT sessionId, sessionName, startMembershipDate,
                   endMembershipDate, fee, description, is_active, capacity_limit
              FROM membershipsessions
             WHERE sessionId = ?
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
                return null;
            }
        }
    }

    @Override
    public List<MembershipSession> findUpcomingAfter(LocalDate date) throws SQLException {
        String sql = """
            SELECT sessionId, sessionName, startMembershipDate,
                   endMembershipDate, fee, description, is_active, capacity_limit
              FROM membershipsessions
             WHERE startMembershipDate > ?
               AND is_active = 1
             ORDER BY startMembershipDate
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                List<MembershipSession> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    private MembershipSession mapRow(ResultSet rs) throws SQLException {
        MembershipSession s = new MembershipSession();
        s.setSessionId(rs.getString("sessionId"));
        s.setSessionName(rs.getString("sessionName"));
        s.setStartMembershipDate(rs.getDate("startMembershipDate").toLocalDate());
        s.setEndMembershipDate(rs.getDate("endMembershipDate").toLocalDate());
        s.setFee(rs.getBigDecimal("fee"));
        s.setDescription(rs.getString("description"));
        s.setActive(rs.getBoolean("is_active"));
        int cap = rs.getInt("capacity_limit");
        s.setCapacityLimit(rs.wasNull() ? null : cap);
        return s;
    }
}
