/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.dao.memberships;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.util.DBConnection;

public class MembershipSessionDao {
    public MembershipSession findById(String sessionId) throws SQLException {
        String sql = "SELECT sessionId, sessionName, startMembershipDate, endMembershipDate, fee, is_active, capacity_limit FROM membershipsessions WHERE sessionId = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<MembershipSession> findUpcomingAfter(LocalDateTime dateTime) throws SQLException {
        String sql = "SELECT sessionId, sessionName, startMembershipDate, endMembershipDate, fee, is_active, capacity_limit FROM membershipsessions WHERE startMembershipDate > ? AND is_active = 1 ORDER BY startMembershipDate";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(dateTime));
            try (ResultSet rs = ps.executeQuery()) {
                List<MembershipSession> list = new java.util.ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    public MembershipSession findActiveOn(LocalDateTime dateTime) throws SQLException {
        String sql = "SELECT sessionId, sessionName, startMembershipDate, endMembershipDate, fee, is_active, capacity_limit FROM membershipsessions WHERE startMembershipDate <= ? AND endMembershipDate >= ? AND is_active = 1";
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

    public List<MembershipSession> findAll() throws SQLException {
        String sql = "SELECT sessionId, sessionName, startMembershipDate, endMembershipDate, fee, is_active, capacity_limit FROM membershipsessions";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                List<MembershipSession> list = new java.util.ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    public void insert(MembershipSession session) throws SQLException {
        String sql = "INSERT INTO membershipsessions\n  (sessionId, sessionName, startMembershipDate, endMembershipDate, fee, is_active, capacity_limit)\nVALUES (?, ?, ?, ?, ?, ?, ?)\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setString(1, session.getSessionId());
            ps.setString(2, session.getSessionName());
            ps.setTimestamp(3, Timestamp.valueOf(session.getStartMembershipDate()));
            ps.setTimestamp(4, Timestamp.valueOf(session.getEndMembershipDate()));
            ps.setBigDecimal(5, session.getFee());
            ps.setBoolean(6, session.isActive());
            if (session.getCapacityLimit() != null) {
                ps.setInt(7, session.getCapacityLimit());
            } else {
                ps.setNull(7, 4);
            }
            ps.executeUpdate();
        }
    }

    public void update(MembershipSession session) throws SQLException {
        String sql = "UPDATE membershipsessions\n   SET sessionName = ?, startMembershipDate = ?, endMembershipDate = ?,\n       fee = ?, is_active = ?, capacity_limit = ?\n WHERE sessionId = ?\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setString(1, session.getSessionName());
            ps.setTimestamp(2, Timestamp.valueOf(session.getStartMembershipDate()));
            ps.setTimestamp(3, Timestamp.valueOf(session.getEndMembershipDate()));
            ps.setBigDecimal(4, session.getFee());
            ps.setBoolean(5, session.isActive());
            if (session.getCapacityLimit() != null) {
                ps.setInt(6, session.getCapacityLimit());
            } else {
                ps.setNull(6, 4);
            }
            ps.setString(7, session.getSessionId());
            ps.executeUpdate();
        }
    }

    public void deleteById(String sessionId) throws SQLException {
        String sql = "DELETE FROM membershipsessions WHERE sessionId = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setString(1, sessionId);
            ps.executeUpdate();
        }
    }

    private MembershipSession mapRow(ResultSet rs) throws SQLException {
        MembershipSession s = new MembershipSession();
        s.setSessionId(rs.getString("sessionId"));
        s.setSessionName(rs.getString("sessionName"));
        s.setStartMembershipDate(rs.getTimestamp("startMembershipDate").toLocalDateTime());
        s.setEndMembershipDate(rs.getTimestamp("endMembershipDate").toLocalDateTime());
        s.setFee(rs.getBigDecimal("fee"));
        s.setActive(rs.getBoolean("is_active"));
        int cap = rs.getInt("capacity_limit");
        s.setCapacityLimit(rs.wasNull() ? null : Integer.valueOf(cap));
        return s;
    }
}