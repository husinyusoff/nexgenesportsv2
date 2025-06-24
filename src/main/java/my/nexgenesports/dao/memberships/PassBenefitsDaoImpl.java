// src/main/java/my/nexgenesports/dao/memberships/PassBenefitsDaoImpl.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.PassBenefit;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of PassBenefitsDao using JDBC.
 */
public class PassBenefitsDaoImpl implements PassBenefitsDao {
    @Override
    public List<PassBenefit> findByTierId(int tierId) throws SQLException {
        String sql = """
            SELECT id,
                   tierId,
                   benefitOrder,
                   benefitText
              FROM pass_benefits
             WHERE tierId = ?
             ORDER BY benefitOrder
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tierId);
            try (ResultSet rs = ps.executeQuery()) {
                List<PassBenefit> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(new PassBenefit(
                        rs.getInt("id"),
                        rs.getInt("tierId"),
                        rs.getInt("benefitOrder"),
                        rs.getString("benefitText")
                    ));
                }
                return list;
            }
        }
    }
}
