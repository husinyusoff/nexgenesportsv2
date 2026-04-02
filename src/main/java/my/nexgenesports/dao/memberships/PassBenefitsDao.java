/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.dao.memberships;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import my.nexgenesports.model.PassBenefit;
import my.nexgenesports.util.DBConnection;

public class PassBenefitsDao {
    /*
     * Exception decompiling
     */
    public List<PassBenefit> findByTierId(int tierId) throws SQLException {
        String sql = "SELECT id, tierId, benefitOrder, benefitName, benefitText FROM pass_benefits WHERE tierId = ? ORDER BY benefitOrder";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tierId);
            try (ResultSet rs = ps.executeQuery()) {
                List<PassBenefit> list = new java.util.ArrayList<>();
                while (rs.next()) {
                    PassBenefit b = new PassBenefit();
                    b.setId(rs.getInt("id"));
                    b.setTierId(rs.getInt("tierId"));
                    b.setBenefitOrder(rs.getInt("benefitOrder"));
                    b.setBenefitName(rs.getString("benefitName"));
                    b.setBenefitText(rs.getString("benefitText"));
                    list.add(b);
                }
                return list;
            }
        }
    }

    public void insert(PassBenefit b) throws SQLException {
        String sql = "INSERT INTO pass_benefits (tierId, benefitOrder, benefitName, benefitText)\nVALUES (?, ?, ?, ?)\n";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, 1);){
            ps.setInt(1, b.getTierId());
            ps.setInt(2, b.getBenefitOrder());
            ps.setString(3, b.getBenefitName());
            ps.setString(4, b.getBenefitText());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys();){
                if (keys.next()) {
                    b.setId(keys.getInt(1));
                }
            }
        }
    }

    public void update(PassBenefit b) throws SQLException {
        String sql = "UPDATE pass_benefits SET benefitOrder = ?, benefitName = ?, benefitText = ?\n WHERE id = ?\n";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setInt(1, b.getBenefitOrder());
            ps.setString(2, b.getBenefitName());
            ps.setString(3, b.getBenefitText());
            ps.setInt(4, b.getId());
            ps.executeUpdate();
        }
    }

    public void deleteById(int id) throws SQLException {
        String sql = "DELETE FROM pass_benefits WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void updateText(int id, String newText) throws SQLException {
        String sql = "UPDATE pass_benefits SET benefitText = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setString(1, newText);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    /*
     * Exception decompiling
     */
    public int countByTierId(int tierId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pass_benefits WHERE tierId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tierId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}