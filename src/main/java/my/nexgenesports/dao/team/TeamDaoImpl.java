package my.nexgenesports.dao.team;

import my.nexgenesports.model.Team;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeamDaoImpl implements TeamDao {

    @Override
    public Team insert(Team team) throws SQLException {
        String sql = """
            INSERT INTO team
              (teamName, description, logoURL, createdBy, createdAt, disbandedAt, status, capacity)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, team.getTeamName());
            ps.setString(2, team.getDescription());
            ps.setString(3, team.getLogoURL());
            ps.setString(4, team.getCreatedBy());
            ps.setTimestamp(5, Timestamp.valueOf(team.getCreatedAt()));
            if (team.getDisbandedAt() != null) {
                ps.setTimestamp(6, Timestamp.valueOf(team.getDisbandedAt()));
            } else {
                ps.setNull(6, Types.TIMESTAMP);
            }
            ps.setString(7, team.getStatus());
            ps.setInt   (8, team.getCapacity());

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    team.setTeamID(keys.getInt(1));
                }
            }
            return team;
        }
    }

    @Override
    public Team findById(int teamID) throws SQLException {
        String sql = "SELECT * FROM team WHERE teamID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, teamID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    @Override
    public List<Team> findByMember(String userID) throws SQLException {
        String sql = """
            SELECT t.*
              FROM team t
              JOIN teammember m ON t.teamID = m.teamID
             WHERE m.userID = ?
               AND t.status = 'Active'
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                List<Team> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    @Override
    public List<Team> findAllActive() throws SQLException {
        String sql = "SELECT * FROM team WHERE status = 'Active'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Team> list = new ArrayList<>();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        }
    }

    @Override
    public void delete(int teamID) throws SQLException {
        String sql = "DELETE FROM team WHERE teamID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, teamID);
            ps.executeUpdate();
        }
    }

    /** ← NEW: update a team’s capacity */
    @Override
    public void updateCapacity(int teamID, int capacity) throws SQLException {
        String sql = "UPDATE team SET capacity = ? WHERE teamID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, capacity);
            ps.setInt(2, teamID);
            ps.executeUpdate();
        }
    }

    /** ← NEW: list all active teams, sorted by an arbitrary column + direction */
    @Override
    public List<Team> findAllActiveSorted(String sortBy, String direction) throws SQLException {
        // sanitize direction
        if (!"asc".equalsIgnoreCase(direction) && !"desc".equalsIgnoreCase(direction)) {
            direction = "asc";
        }
        // for safety only allow certain columns
        switch (sortBy) {
            case "teamName": case "createdAt": case "capacity": break;
            default: sortBy = "teamName";
        }
        String sql = "SELECT * FROM team WHERE status='Active' ORDER BY " 
                   + sortBy + " " + direction;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Team> list = new ArrayList<>();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        }
    }

    private Team mapRow(ResultSet rs) throws SQLException {
        Team t = new Team();
        t.setTeamID(rs.getInt("teamID"));
        t.setTeamName(rs.getString("teamName"));
        t.setDescription(rs.getString("description"));
        t.setLogoURL(rs.getString("logoURL"));
        t.setCreatedBy(rs.getString("createdBy"));
        t.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        Timestamp dts = rs.getTimestamp("disbandedAt");
        if (dts != null) t.setDisbandedAt(dts.toLocalDateTime());
        t.setStatus(rs.getString("status"));
        t.setCapacity(rs.getInt("capacity"));
        return t;
    }
}
