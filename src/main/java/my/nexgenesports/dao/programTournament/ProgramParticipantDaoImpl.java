// src/main/java/my/nexgenesports/dao/programTournament/ProgramParticipantDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramParticipant;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgramParticipantDaoImpl implements ProgramParticipantDao {

    @Override
    public void insert(ProgramParticipant p) throws SQLException {
        String sql = """
            INSERT INTO program_participant
              (progID, userId, teamId, joined_at)
            VALUES (?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getProgID());
            ps.setString(2, p.getUserId());
            if (p.getTeamId() != null) ps.setString(3, p.getTeamId());
            else                     ps.setNull(3, Types.VARCHAR);
            ps.setTimestamp(4, Timestamp.valueOf(p.getJoinedAt()));
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) p.setId(keys.getLong(1));
            }
        }
    }

    @Override
    public boolean exists(String progID, String userId) throws SQLException {
        String sql = "SELECT 1 FROM program_participant WHERE progID=? AND userId=? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, progID);
            ps.setString(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public int countByProgId(String progID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM program_participant WHERE progID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, progID);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    @Override
    public List<ProgramParticipant> listByProgId(String progID) throws SQLException {
        String sql = "SELECT * FROM program_participant WHERE progID=? ORDER BY joined_at";
        List<ProgramParticipant> out = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, progID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProgramParticipant p = new ProgramParticipant();
                    p.setId(rs.getLong("id"));
                    p.setProgID(rs.getString("progID"));
                    p.setUserId(rs.getString("userId"));
                    p.setTeamId(rs.getString("teamId"));
                    Timestamp ts = rs.getTimestamp("joined_at");
                    p.setJoinedAt(ts.toLocalDateTime());
                    out.add(p);
                }
            }
        }
        return out;
    }
}
