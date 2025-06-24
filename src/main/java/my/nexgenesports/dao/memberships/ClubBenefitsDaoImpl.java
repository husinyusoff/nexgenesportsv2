// src/main/java/my/nexgenesports/dao/memberships/ClubBenefitsDaoImpl.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.ClubBenefit;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClubBenefitsDaoImpl implements ClubBenefitsDao {
    @Override
    public List<ClubBenefit> findBySessionId(String sessionId) throws SQLException {
        String sql = """
            SELECT id, sessionId, benefitOrder, benefitText
              FROM club_benefits
             WHERE sessionId = ?
             ORDER BY benefitOrder
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                List<ClubBenefit> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(new ClubBenefit(
                        rs.getInt("id"),
                        rs.getString("sessionId"),
                        rs.getInt("benefitOrder"),
                        rs.getString("benefitText")
                    ));
                }
                return out;
            }
        }
    }
}
