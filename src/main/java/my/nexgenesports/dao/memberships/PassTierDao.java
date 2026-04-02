/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.dao.memberships;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.util.DBConnection;

public class PassTierDao {
    public List<PassTier> findAll() throws SQLException {
        String sql = "SELECT tierId, tierName, price, discountRate FROM monthlygamingpasstiers";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                List<PassTier> list = new java.util.ArrayList<>();
                while (rs.next()) {
                    PassTier t = new PassTier();
                    t.setTierId(rs.getInt("tierId"));
                    t.setTierName(rs.getString("tierName"));
                    t.setPrice(rs.getBigDecimal("price"));
                    t.setDiscountRate(rs.getInt("discountRate"));
                    list.add(t);
                }
                return list;
            }
        }
    }

    public PassTier findById(int tierId) throws SQLException {
        String sql = "SELECT tierId, tierName, price, discountRate FROM monthlygamingpasstiers WHERE tierId = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, tierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PassTier t = new PassTier();
                    t.setTierId(rs.getInt("tierId"));
                    t.setTierName(rs.getString("tierName"));
                    t.setPrice(rs.getBigDecimal("price"));
                    t.setDiscountRate(rs.getInt("discountRate"));
                    return t;
                }
                return null;
            }
        }
    }

    public void insert(PassTier tier) throws SQLException {
        String sql = "INSERT INTO monthlygamingpasstiers\n  (tierName, price, discountRate)\nVALUES (?, ?, ?)\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, 1);){
            ps.setString(1, tier.getTierName());
            ps.setBigDecimal(2, tier.getPrice());
            ps.setInt(3, tier.getDiscountRate());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys();){
                if (keys.next()) {
                    tier.setTierId(keys.getInt(1));
                }
            }
        }
    }

    public void update(PassTier tier) throws SQLException {
        String sql = "UPDATE monthlygamingpasstiers\n   SET tierName = ?, price = ?, discountRate = ?\n WHERE tierId = ?\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setString(1, tier.getTierName());
            ps.setBigDecimal(2, tier.getPrice());
            ps.setInt(3, tier.getDiscountRate());
            ps.setInt(4, tier.getTierId());
            ps.executeUpdate();
        }
    }

    public void deleteById(int tierId) throws SQLException {
        String sql = "DELETE FROM monthlygamingpasstiers WHERE tierId = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setInt(1, tierId);
            ps.executeUpdate();
        }
    }
}