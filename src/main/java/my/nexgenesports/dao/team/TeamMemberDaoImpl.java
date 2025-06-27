// File: src/main/java/my/nexgenesports/dao/team/TeamMemberDaoImpl.java
package my.nexgenesports.dao.team;

import my.nexgenesports.model.TeamMember;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TeamMemberDaoImpl implements TeamMemberDao {

    @Override
    public void insert(TeamMember m) throws SQLException {
        String sql = """
            INSERT INTO teammember
              (teamID, userID, status, teamRole, joinedAt, roleAssignedAt)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, m.getTeamID());
            ps.setString(2, m.getUserID());
            ps.setString(3, m.getStatus());
            ps.setString(4, m.getTeamRole());
            ps.setTimestamp(5, Timestamp.valueOf(m.getJoinedAt()));
            ps.setTimestamp(6, Timestamp.valueOf(m.getRoleAssignedAt()));
            ps.executeUpdate();
        }
    }

    @Override
    public void updateStatus(int teamID, String userID, String status) throws SQLException {
        String sql = """
            UPDATE teammember
               SET status = ?
             WHERE teamID = ? AND userID = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, teamID);
            ps.setString(3, userID);
            ps.executeUpdate();
        }
    }

    @Override
    public void updateRole(int teamID, String userID, String newRole) throws SQLException {
        String sql = """
            UPDATE teammember
               SET teamRole = ?, roleAssignedAt = ?
             WHERE teamID = ? AND userID = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, teamID);
            ps.setString(4, userID);
            ps.executeUpdate();
        }
    }

    @Override
    public int countActiveMembers(int teamID) throws SQLException {
        String sql = """
            SELECT COUNT(*) AS cnt
              FROM teammember
             WHERE teamID = ?
               AND status = 'Active'
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("cnt") : 0;
            }
        }
    }

    @Override
    public int countActiveRole(int teamID, String role) throws SQLException {
        String sql = """
            SELECT COUNT(*) AS cnt
              FROM teammember
             WHERE teamID   = ?
               AND status   = 'Active'
               AND teamRole = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            ps.setString(2, role);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("cnt") : 0;
            }
        }
    }

    @Override
    public List<TeamMember> listByTeam(int teamID) throws SQLException {
        String sql = "SELECT * FROM teammember WHERE teamID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            try (ResultSet rs = ps.executeQuery()) {
                List<TeamMember> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    @Override
    public List<TeamMember> listByUser(String userID) throws SQLException {
        String sql = "SELECT * FROM teammember WHERE userID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                List<TeamMember> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    @Override
    public void removeMember(int teamID, String userID) throws SQLException {
        String sql = "DELETE FROM teammember WHERE teamID = ? AND userID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            ps.setString(2, userID);
            ps.executeUpdate();
        }
    }

    /**
     * Remove all members of the given team.
     */
    @Override
    public void removeAll(int teamID) throws SQLException {
        String sql = "DELETE FROM teammember WHERE teamID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            ps.executeUpdate();
        }
    }

    @Override
    public void updateLeader(int teamID, String newLeader) throws SQLException {
        String sql = "UPDATE team SET leader = ? WHERE teamID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newLeader);
            ps.setInt(2, teamID);
            ps.executeUpdate();
        }
    }

    @Override
    public void archive(int teamID, String userID) throws SQLException {
        String sql = """
            INSERT INTO archived_teammember
              (teamID, userID, status, teamRole, joinedAt, roleAssignedAt, leftAt)
            SELECT teamID, userID, status, teamRole, joinedAt, roleAssignedAt, NOW()
              FROM teammember
             WHERE teamID = ? AND userID = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            ps.setString(2, userID);
            ps.executeUpdate();
        }
    }

    private TeamMember mapRow(ResultSet rs) throws SQLException {
        TeamMember m = new TeamMember();
        m.setTeamID(rs.getInt("teamID"));
        m.setUserID(rs.getString("userID"));
        m.setStatus(rs.getString("status"));
        m.setTeamRole(rs.getString("teamRole"));
        m.setJoinedAt(rs.getTimestamp("joinedAt").toLocalDateTime());
        m.setRoleAssignedAt(rs.getTimestamp("roleAssignedAt").toLocalDateTime());
        return m;
    }
    
    
}
