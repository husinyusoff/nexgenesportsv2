package my.nexgenesports.dao.team;

import my.nexgenesports.model.ArchivedTeam;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class ArchivedTeamDaoImpl implements ArchivedTeamDao {

    @Override
    public void insert(ArchivedTeam at) throws SQLException {
        String sql = """
            INSERT INTO archivedteam
              (teamID, teamName, description, logoURL,
               createdBy, createdAt, disbandedAt, status, archivedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt    (1, at.getTeamID());
            ps.setString (2, at.getTeamName());
            ps.setString (3, at.getDescription());
            ps.setString (4, at.getLogoURL());
            ps.setString (5, at.getLeader());
            ps.setTimestamp(6, Timestamp.valueOf(at.getCreatedAt()));
            if (at.getDisbandedAt() != null) {
                ps.setTimestamp(7, Timestamp.valueOf(at.getDisbandedAt()));
            } else {
                ps.setNull(7, Types.TIMESTAMP);
            }
            ps.setString (8, at.getStatus());
            ps.setTimestamp(9, Timestamp.valueOf(at.getArchivedAt()));

            ps.executeUpdate();
        }
    }
}
