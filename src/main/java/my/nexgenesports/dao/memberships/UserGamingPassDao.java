/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.dao.memberships;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.util.DBConnection;

public class UserGamingPassDao {
    private final PassTierDao tierDao = new PassTierDao();

    public void insert(UserGamingPass p) throws SQLException {
        String sql = "    INSERT INTO usergamingpasses\n      (userId, tierId, purchaseDate, expiryDate, status, paymentReference)\n    VALUES (?, ?, ?, ?, ?, ?)\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, 1);){
            ps.setString(1, p.getUserId());
            ps.setInt(2, p.getTier().getTierId());
            ps.setTimestamp(3, Timestamp.valueOf(p.getPurchaseDate()));
            ps.setTimestamp(4, Timestamp.valueOf(p.getExpiryDate()));
            ps.setString(5, p.getStatus());
            ps.setString(6, p.getPaymentReference());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys();){
                if (keys.next()) {
                    p.setId(keys.getInt(1));
                }
            }
        }
    }

    /*
     * Exception decompiling
     */
    public UserGamingPass findLatestByUser(String userId) throws SQLException {
        String sql = "SELECT id, userId, tierId, purchaseDate, expiryDate, status, paymentReference FROM usergamingpasses WHERE userId = ? ORDER BY purchaseDate DESC LIMIT 1";
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
    public UserGamingPass findById(int id) throws SQLException {
        String sql = "SELECT id, userId, tierId, purchaseDate, expiryDate, status, paymentReference FROM usergamingpasses WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<UserGamingPass> findAll() throws SQLException {
        String sql = "    SELECT id, userId, tierId, purchaseDate, expiryDate, status, paymentReference\n      FROM usergamingpasses\n     ORDER BY purchaseDate DESC\n";
        ArrayList<UserGamingPass> list = new ArrayList<UserGamingPass>();
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
        String sql = "DELETE FROM usergamingpasses WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void update(UserGamingPass p) throws SQLException {
        String sql = "    UPDATE usergamingpasses\n       SET tierId           = ?,\n           purchaseDate     = ?,\n           expiryDate       = ?,\n           status           = ?,\n           paymentReference = ?\n     WHERE id = ?\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setInt(1, p.getTier().getTierId());
            ps.setTimestamp(2, Timestamp.valueOf(p.getPurchaseDate()));
            ps.setTimestamp(3, Timestamp.valueOf(p.getExpiryDate()));
            ps.setString(4, p.getStatus());
            ps.setString(5, p.getPaymentReference());
            ps.setInt(6, p.getId());
            ps.executeUpdate();
        }
    }

    private UserGamingPass mapRow(ResultSet rs) throws SQLException {
        UserGamingPass p = new UserGamingPass();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getString("userId"));
        PassTier tier = this.tierDao.findById(rs.getInt("tierId"));
        p.setTier(tier);
        p.setPurchaseDate(rs.getTimestamp("purchaseDate").toLocalDateTime());
        p.setExpiryDate(rs.getTimestamp("expiryDate").toLocalDateTime());
        p.setStatus(rs.getString("status"));
        p.setPaymentReference(rs.getString("paymentReference"));
        return p;
    }
}