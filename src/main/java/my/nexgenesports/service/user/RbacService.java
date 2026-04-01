// src/main/java/my/nexgenesports/service/rbac/RbacService.java
package my.nexgenesports.service.user;

import my.nexgenesports.model.Page;
import my.nexgenesports.model.RolePosition;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.*;

public class RbacService {

    /**
     * List all pages from `pages` table
     */
    public List<Page> listPages() throws SQLException {
        String sql = "SELECT page_id, url, name, inherit_permission FROM pages ORDER BY name";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<Page> out = new ArrayList<>();
            while (rs.next()) {
                Page p = new Page();
                p.setPageId(rs.getInt("page_id"));
                p.setUrl(rs.getString("url"));
                p.setName(rs.getString("name"));
                p.setInheritPermission(rs.getBoolean("inherit_permission"));
                out.add(p);
            }
            return out;
        }
    }

    /**
     * List all role+position combos from `role_positions`
     */
    public List<RolePosition> listRolePositions() throws SQLException {
        String sql = "SELECT id, role, position FROM role_positions ORDER BY role, position";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<RolePosition> out = new ArrayList<>();
            while (rs.next()) {
                RolePosition rp = new RolePosition();
                rp.setId(rs.getInt("id"));
                rp.setRole(rs.getString("role"));
                rp.setPosition(rs.getString("position"));
                out.add(rp);
            }
            return out;
        }
    }

    /**
     * Get a map pageId→set of rp_id that currently have permission
     */
    public Map<Integer, Set<Integer>> mapAllPermissions() throws SQLException {
        String sql = "SELECT page_id, rp_id FROM permissions";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            Map<Integer, Set<Integer>> out = new HashMap<>();
            while (rs.next()) {
                int pg = rs.getInt("page_id");
                int rp = rs.getInt("rp_id");
                out.computeIfAbsent(pg, k -> new HashSet<>()).add(rp);
            }
            return out;
        }
    }

    /**
     * Overwrite permissions for one page: delete all, then re‐insert the ones
     * checked
     */
    public void updatePermissionsForPage(int pageId, Collection<Integer> keepRpIds)
            throws SQLException {
        String del = "DELETE FROM permissions WHERE page_id=?";
        String ins = "INSERT INTO permissions(page_id,rp_id) VALUES(?,?)";
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement pd = c.prepareStatement(del)) {
                pd.setInt(1, pageId);
                pd.executeUpdate();
            }
            if (!keepRpIds.isEmpty()) {
                try (PreparedStatement pi = c.prepareStatement(ins)) {
                    for (int rpId : keepRpIds) {
                        pi.setInt(1, pageId);
                        pi.setInt(2, rpId);
                        pi.addBatch();
                    }
                    pi.executeBatch();
                }
            }
            c.commit();
        }
    }

    /**
     * Toggle inheritPermission on a page
     */
    public void setInherit(int pageId, boolean inherit) throws SQLException {
        String sql = "UPDATE pages SET inherit_permission=? WHERE page_id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, inherit);
            ps.setInt(2, pageId);
            ps.executeUpdate();
        }
    }

    /**
     * Sync *all* pages at once: first update each page's inherit flag, then
     * update its permissions set.
     *
     * @param inheritMap
     * @param permMap
     * @throws java.sql.SQLException
     */
    public void syncAll(
            Map<Integer, Boolean> inheritMap,
            Map<Integer, Set<Integer>> permMap
    ) throws SQLException {
        // 1) update all inherit flags
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            String up = "UPDATE pages SET inherit_permission=? WHERE page_id=?";
            try (PreparedStatement ps = c.prepareStatement(up)) {
                for (var e : inheritMap.entrySet()) {
                    ps.setBoolean(1, e.getValue());
                    ps.setInt(2, e.getKey());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            // 2) update each page's permissions
            for (Map.Entry<Integer, Set<Integer>> e : permMap.entrySet()) {
                updatePermissionsForPage(e.getKey(), e.getValue());
            }
            c.commit();
        }
    }

}
