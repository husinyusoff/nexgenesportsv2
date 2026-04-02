/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.dao.memberships;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import my.nexgenesports.model.ClubBenefit;
import my.nexgenesports.util.DBConnection;

public class ClubBenefitsDao {
    /*
     * Exception decompiling
     */
    public List<ClubBenefit> findBySessionId(String sessionId) throws SQLException {
        String sql = "SELECT id, sessionId, benefitOrder, benefitText FROM club_benefits WHERE sessionId = ? ORDER BY benefitOrder";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                List<ClubBenefit> list = new java.util.ArrayList<>();
                while (rs.next()) {
                    ClubBenefit b = new ClubBenefit();
                    b.setId(rs.getInt("id"));
                    b.setSessionId(rs.getString("sessionId"));
                    b.setBenefitOrder(rs.getInt("benefitOrder"));
                    b.setBenefitText(rs.getString("benefitText"));
                    list.add(b);
                }
                return list;
            }
        }
    }

    public void insert(ClubBenefit b) throws SQLException {
        String sql = "INSERT INTO club_benefits (sessionId, benefitOrder, benefitText)\nVALUES (?, ?, ?)\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, 1);){
            ps.setString(1, b.getSessionId());
            ps.setInt(2, b.getBenefitOrder());
            ps.setString(3, b.getBenefitText());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys();){
                if (keys.next()) {
                    b.setId(keys.getInt(1));
                }
            }
        }
    }

    public void update(ClubBenefit b) throws SQLException {
        String sql = "UPDATE club_benefits SET benefitOrder = ?, benefitText = ?\n WHERE id = ?\n";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setInt(1, b.getBenefitOrder());
            ps.setString(2, b.getBenefitText());
            ps.setInt(3, b.getId());
            ps.executeUpdate();
        }
    }

    public void deleteById(int id) throws SQLException {
        String sql = "DELETE FROM club_benefits WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);){
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /*
     * Exception decompiling
     */
    public int countBySessionId(String sessionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM club_benefits WHERE sessionId = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}