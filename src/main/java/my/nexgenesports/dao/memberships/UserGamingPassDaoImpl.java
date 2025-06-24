package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;

public class UserGamingPassDaoImpl implements UserGamingPassDao {
    private final PassTierDao tierDao = new PassTierDaoImpl();

    @Override
    public void insert(UserGamingPass p) throws SQLException {
        String sql = """
            INSERT INTO usergamingpasses
              (userId, tierId, purchaseDate, expiryDate, status, paymentReference)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getUserId());
            ps.setInt(2, p.getTier().getTierId());
            ps.setTimestamp(3, Timestamp.valueOf(p.getPurchaseDate()));
            ps.setTimestamp(4, Timestamp.valueOf(p.getExpiryDate()));
            ps.setString(5, p.getStatus());
            ps.setString(6, p.getPaymentReference());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    p.setId(keys.getInt(1));
                }
            }
        }
    }

    @Override
    public UserGamingPass findLatestByUser(String userId) throws SQLException {
        String sql = """
            SELECT id, userId, tierId, purchaseDate, expiryDate, status, paymentReference
              FROM usergamingpasses
             WHERE userId = ?
             ORDER BY expiryDate DESC
             LIMIT 1
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public UserGamingPass findById(int id) throws SQLException {
        String sql = """
            SELECT id, userId, tierId, purchaseDate, expiryDate, status, paymentReference
              FROM usergamingpasses
             WHERE id = ?
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public void update(UserGamingPass p) throws SQLException {
        String sql = """
            UPDATE usergamingpasses
               SET expiryDate       = ?,
                   status           = ?,
                   paymentReference = ?
             WHERE id = ?
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(p.getExpiryDate()));
            ps.setString(2, p.getStatus());
            ps.setString(3, p.getPaymentReference());
            ps.setInt(4, p.getId());
            ps.executeUpdate();
        }
    }

    private UserGamingPass mapRow(ResultSet rs) throws SQLException {
        UserGamingPass p = new UserGamingPass();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getString("userId"));
        PassTier tier = tierDao.findById(rs.getInt("tierId"));
        p.setTier(tier);
        p.setPurchaseDate(rs.getTimestamp("purchaseDate").toLocalDateTime());
        p.setExpiryDate(rs.getTimestamp("expiryDate").toLocalDateTime());
        p.setStatus(rs.getString("status"));
        p.setPaymentReference(rs.getString("paymentReference"));
        return p;
    }
}
