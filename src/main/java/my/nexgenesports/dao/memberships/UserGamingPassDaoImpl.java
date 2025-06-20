// src/main/java/my/nexgenesports/dao/memberships/UserGamingPassDaoImpl.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class UserGamingPassDaoImpl implements UserGamingPassDao {
    private final PassTierDao tierDao = new PassTierDaoImpl();

    @Override
    public void insert(UserGamingPass p) throws SQLException {
        String sql = """
            INSERT INTO usergamingpasses
              (userId, tierId, purchaseDate, expiryDate, paymentReference)
            VALUES (?, ?, ?, ?, ?)
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getUserId());
            ps.setInt   (2, p.getTier().getTierId());
            ps.setDate  (3, Date.valueOf(p.getPurchaseDate()));
            ps.setDate  (4, Date.valueOf(p.getExpiryDate()));
            ps.setString(5, p.getPaymentReference()); // assuming your model holds it as String
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
            SELECT id, userId, tierId, purchaseDate, expiryDate, paymentReference
              FROM usergamingpasses
             WHERE userId = ?
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
    public UserGamingPass findById(int id) throws SQLException {
        String sql = """
            SELECT id, userId, tierId, purchaseDate, expiryDate, paymentReference
              FROM usergamingpasses
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
    public void update(UserGamingPass p) throws SQLException {
        String sql = """
            UPDATE usergamingpasses
               SET expiryDate       = ?,
                   paymentReference = ?
             WHERE id = ?
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate  (1, Date.valueOf(p.getExpiryDate()));
            ps.setString(2, p.getPaymentReference());
            ps.setInt   (3, p.getId());
            ps.executeUpdate();
        }
    }

    private UserGamingPass mapRow(ResultSet rs) throws SQLException {
        UserGamingPass p = new UserGamingPass();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getString("userId"));

        PassTier tier = tierDao.findById(rs.getInt("tierId"));
        p.setTier(tier);

        p.setPurchaseDate(rs.getDate("purchaseDate").toLocalDate());
        p.setExpiryDate  (rs.getDate("expiryDate").toLocalDate());
        p.setPaymentReference(rs.getString("paymentReference"));

        return p;
    }
}
