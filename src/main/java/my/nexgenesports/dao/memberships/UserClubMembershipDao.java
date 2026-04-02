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
import java.util.ArrayList;
import java.util.List;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.util.DBConnection;

public class UserClubMembershipDao {
    private final MembershipSessionDao sessionDao = new MembershipSessionDao();

    public void insert(UserClubMembership m) throws SQLException {
        String sql = "    INSERT INTO userclubmemberships\n      (userId, sessionId, purchaseDate, expiryDate, status, payment_reference)\n    VALUES (?, ?, ?, ?, ?, ?)\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, 1);){
            ps.setString(1, m.getUserId());
            ps.setString(2, m.getSession().getSessionId());
            ps.setTimestamp(3, Timestamp.valueOf(m.getPurchaseDate()));
            ps.setTimestamp(4, Timestamp.valueOf(m.getExpiryDate()));
            ps.setString(5, m.getStatus());
            ps.setString(6, m.getPaymentReference());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys();){
                if (keys.next()) {
                    m.setId(keys.getInt(1));
                }
            }
        }
    }

    /*
     * Exception decompiling
     */
    public UserClubMembership findLatestByUser(String userId) throws SQLException {
        String sql = "SELECT id, userId, sessionId, purchaseDate, expiryDate, status, payment_reference FROM userclubmemberships WHERE userId = ? ORDER BY purchaseDate DESC LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    /*
     * Exception decompiling
     */
    public UserClubMembership findById(int id) throws SQLException {
        String sql = "SELECT id, userId, sessionId, purchaseDate, expiryDate, status, payment_reference FROM userclubmemberships WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<UserClubMembership> findAll() throws SQLException {
        String sql = "    SELECT id, userId, sessionId, purchaseDate, expiryDate, status, payment_reference\n      FROM userclubmemberships\n     ORDER BY purchaseDate DESC\n";
        ArrayList<UserClubMembership> list = new ArrayList<UserClubMembership>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();){
            while (rs.next()) {
                list.add(this.mapRow(rs));
            }
        }
        return list;
    }

    public void deleteById(int id) throws SQLException {
        String sql = "DELETE FROM userclubmemberships WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void update(UserClubMembership m) throws SQLException {
        String sql = "    UPDATE userclubmemberships\n       SET status = ?, purchaseDate = ?, expiryDate = ?, payment_reference = ?\n     WHERE id = ?\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setString(1, m.getStatus());
            ps.setTimestamp(2, Timestamp.valueOf(m.getPurchaseDate()));
            ps.setTimestamp(3, Timestamp.valueOf(m.getExpiryDate()));
            ps.setString(4, m.getPaymentReference());
            ps.setInt(5, m.getId());
            ps.executeUpdate();
        }
    }

    public void updateExpiryDatesBySessionId(String sessionId, LocalDateTime newExpiryDate) throws SQLException {
        String sql = "UPDATE userclubmemberships SET expiryDate = ? WHERE sessionId = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setTimestamp(1, Timestamp.valueOf(newExpiryDate));
            ps.setString(2, sessionId);
            ps.executeUpdate();
        }
    }

    private UserClubMembership mapRow(ResultSet rs) throws SQLException {
        UserClubMembership m = new UserClubMembership();
        m.setId(rs.getInt("id"));
        m.setUserId(rs.getString("userId"));
        MembershipSession sess = this.sessionDao.findById(rs.getString("sessionId"));
        m.setSession(sess);
        m.setPurchaseDate(rs.getTimestamp("purchaseDate").toLocalDateTime());
        m.setExpiryDate(rs.getTimestamp("expiryDate").toLocalDateTime());
        m.setStatus(rs.getString("status"));
        m.setPaymentReference(rs.getString("payment_reference"));
        return m;
    }
}