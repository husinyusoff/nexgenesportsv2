// src/main/java/my/nexgenesports/dao/BusinessConfigDao.java
package my.nexgenesports.dao.booking;

import my.nexgenesports.util.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class BusinessConfigDao {
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

  public void update(String key, int value) throws SQLException {
    String sql = "UPDATE business_config SET config_value = ? WHERE config_key = ?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
      ps.setInt   (1, value);
      ps.setString(2, key);
      ps.executeUpdate();
    }
  }
}
