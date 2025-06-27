// File: src/main/java/my/nexgenesports/dao/booking/BusinessConfigDaoImpl.java
package my.nexgenesports.dao.booking;

import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class BusinessConfigDaoImpl implements BusinessConfigDao {

    @Override
    public Map<String,Integer> findAll() throws SQLException {
        String sql = "SELECT config_key, config_value FROM business_config";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            Map<String,Integer> m = new HashMap<>();
            while (rs.next()) {
                m.put(rs.getString("config_key"),
                      rs.getInt   ("config_value"));
            }
            return m;
        }
    }

    @Override
    public void update(String key, int value) throws SQLException {
        String sql = "UPDATE business_config SET config_value = ? WHERE config_key = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt   (1, value);
            ps.setString(2, key);
            ps.executeUpdate();
        }
    }

    @Override
    public int getInt(String key, int defaultValue) throws SQLException {
        String sql = "SELECT config_value FROM business_config WHERE config_key = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("config_value");
                }
            }
        }
        return defaultValue;
    }
}
