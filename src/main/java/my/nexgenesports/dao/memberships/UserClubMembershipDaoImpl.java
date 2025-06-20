// src/main/java/my/nexgenesports/dao/UserClubMembershipDaoImpl.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class UserClubMembershipDaoImpl implements UserClubMembershipDao {
    private final MembershipSessionDao sessionDao = new MembershipSessionDaoImpl();

    @Override
    public void insert(UserClubMembership m) throws SQLException {
        String sql = """
            INSERT INTO userclubmemberships
              (userId, sessionId, purchaseDate, expiryDate, status, payment_reference)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, m.getUserId());
            ps.setString(2, m.getSession().getSessionId());
            ps.setDate(3, Date.valueOf(m.getPurchaseDate()));
            ps.setDate(4, Date.valueOf(m.getExpiryDate()));
            ps.setString(5, m.getStatus());
            ps.setString(6, m.getPaymentReference());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    m.setId(keys.getInt(1));
                }
            }
        }
    }

    @Override
    public UserClubMembership findLatestByUser(String userId) throws SQLException {
        String sql = """
            SELECT id, sessionId, purchaseDate, expiryDate, status, payment_reference
              FROM userclubmemberships
             WHERE userId = ?
               AND status = 'ACTIVE'
             ORDER BY expiryDate DESC
             LIMIT 1
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    @Override
    public UserClubMembership findById(int id) throws SQLException {
        String sql = """
            SELECT id, userId, sessionId, purchaseDate, expiryDate, status, payment_reference
              FROM userclubmemberships
             WHERE id = ?
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    @Override
    public void update(UserClubMembership m) throws SQLException {
        String sql = """
            UPDATE userclubmemberships
               SET status = ?, expiryDate = ?, payment_reference = ?
             WHERE id = ?
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, m.getStatus());
            ps.setDate(2, Date.valueOf(m.getExpiryDate()));
            ps.setString(3, m.getPaymentReference());
            ps.setInt(4, m.getId());
            ps.executeUpdate();
        }
    }

    private UserClubMembership mapRow(ResultSet rs) throws SQLException {
        UserClubMembership m = new UserClubMembership();
        m.setId(rs.getInt("id"));
        m.setUserId(rs.getString("userId"));
        MembershipSession sess = sessionDao.findById(rs.getString("sessionId"));
        m.setSession(sess);
        m.setPurchaseDate(rs.getDate("purchaseDate").toLocalDate());
        m.setExpiryDate(rs.getDate("expiryDate").toLocalDate());
        m.setStatus(rs.getString("status"));
        m.setPaymentReference(rs.getString("payment_reference"));
        return m;
    }
}
