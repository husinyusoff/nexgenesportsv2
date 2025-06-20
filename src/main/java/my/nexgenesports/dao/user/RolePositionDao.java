package my.nexgenesports.dao.user;

import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class RolePositionDao {

    /**
     * Find the PK id by role+position (used in registration).
     * @param role
     * @param position
     * @return 
     * @throws java.sql.SQLException
     */
    public int findIdByRoleAndPosition(String role, String position) throws SQLException {
        String sql = "SELECT id FROM role_positions WHERE role = ?"
                   + (position == null ? " AND position IS NULL" : " AND position = ?");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, role);
            if (position != null) ps.setString(2, position);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                } else {
                    throw new SQLException("No role_position for " + role + "/" + position);
                }
            }
        }
    }

    /**
     * Lookup the base role string for a given rp_id (used in login).
     * @param rpId
     * @return 
     * @throws java.sql.SQLException
     */
    public String findRoleByRpId(int rpId) throws SQLException {
        String sql = "SELECT role FROM role_positions WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rpId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role");
                }
                throw new SQLException("No role for rp_id=" + rpId);
            }
        }
    }
}
