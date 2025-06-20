// src/main/java/my/nexgenesports/dao/PassTierDaoImpl.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.PassTier;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PassTierDaoImpl implements PassTierDao {
    @Override
    public List<PassTier> findAll() throws SQLException {
        String sql = """
            SELECT tierId, tierName, price, discountRate
              FROM monthlygamingpasstiers
             ORDER BY tierId
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<PassTier> list = new ArrayList<>();
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

    @Override
    public PassTier findById(int tierId) throws SQLException {
        String sql = """
            SELECT tierId, tierName, price, discountRate
              FROM monthlygamingpasstiers
             WHERE tierId = ?
        """;
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
}
