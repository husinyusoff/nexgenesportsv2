package my.nexgenesports.util;

import java.sql.*;
import java.util.List;

public class PermissionChecker {

    public static boolean hasAccess(
            List<String> effectiveRoles,
            String chosenRole,
            String position,
            String url
    ) {
        // lookup page
        String PAGE_SQL = "SELECT page_id, inherit_permission FROM pages WHERE url = ?";
        int pageId;
        boolean inherit;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(PAGE_SQL)) {
            ps.setString(1, url);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                pageId = rs.getInt("page_id");
                inherit = rs.getBoolean("inherit_permission");
            }
        } catch (SQLException e) {
            return false;
        }

        // lookup perms
        String PERM_SQL =
            "SELECT rp.role AS permRole, rp.position AS permPos " +
            "FROM permissions p " +
            "JOIN role_positions rp ON p.rp_id = rp.id " +
            "WHERE p.page_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(PERM_SQL)) {
            ps.setInt(1, pageId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String permRole = rs.getString("permRole");
                    String permPos  = rs.getString("permPos");
                    if (permPos != null && !permPos.equals(position)) continue;
                    if (inherit) {
                        if (RoleUtils.isAllowedRole(effectiveRoles, permRole)) {
                            return true;
                        }
                    } else {
                        if (permRole.equals(chosenRole)) {
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            return false;
        }

        return false;
    }
}
