// src/main/java/my/nexgenesports/dao/programTournament/TournamentParticipantDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.TournamentParticipant;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TournamentParticipantDaoImpl implements TournamentParticipantDao {

    @Override
    public void insert(TournamentParticipant tp) throws SQLException {
        String sql = """
            INSERT INTO tournament_participant
              (prog_id, user_id, team_id, role, status, paymentReference, joined_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // 1) prog_id
            ps.setInt(1, tp.getProgId());

            // 2) user_id
            ps.setString(2, tp.getUserId());

            // 3) team_id (nullable)
            if (tp.getTeamId() != null) {
                ps.setInt(3, tp.getTeamId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            // 4) role
            ps.setString(4, tp.getRole());

            // 5) status
            ps.setString(5, tp.getStatus());

            // 6) paymentReference
            ps.setString(6, tp.getPaymentReference());

            // 7) joined_at (use current time if model didn’t set it)
            LocalDateTime when = tp.getJoinedAt() != null
                    ? tp.getJoinedAt()
                    : LocalDateTime.now();
            ps.setTimestamp(7, Timestamp.valueOf(when));

            // Execute
            ps.executeUpdate();

            // Retrieve generated ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    tp.setId(rs.getLong(1));
                }
            }
        }
    }

    @Override
    public int insertPending(TournamentParticipant tp) throws SQLException {
        String sql = """
            INSERT INTO tournament_participant
              (prog_id, user_id, team_id, role)
            VALUES (?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, tp.getProgId());
            ps.setString(2, tp.getUserId());
            if (tp.getTeamId() != null) {
                ps.setInt(3, tp.getTeamId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, tp.getRole());  // pending registrations should carry the user’s role

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    @Override
    public void updatePaymentStatus(int id, String status, String reference) throws SQLException {
        String sql = """
            UPDATE tournament_participant
               SET status = ?, paymentReference = ?
             WHERE id = ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, reference);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    @Override
    public boolean exists(int progId, String userId, Integer teamId) throws SQLException {
        String sql = """
            SELECT 1
              FROM tournament_participant
             WHERE prog_id=? 
               AND user_id <=> ? 
               AND team_id <=> ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, progId);
            ps.setString(2, userId);
            if (teamId != null) {
                ps.setInt(3, teamId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public long countByProgId(int progId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tournament_participant WHERE prog_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getLong(1);
            }
        }
    }

    @Override
    public List<TournamentParticipant> findByProgId(int progId) throws SQLException {
        String sql = """
            SELECT id, prog_id, user_id, team_id,
                   role, status, paymentReference, joined_at
              FROM tournament_participant
             WHERE prog_id = ?
               AND status = 'PAID'
             ORDER BY joined_at
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                List<TournamentParticipant> list = new ArrayList<>();
                while (rs.next()) {
                    TournamentParticipant tp = new TournamentParticipant();
                    tp.setId(rs.getLong("id"));
                    tp.setProgId(rs.getInt("prog_id"));
                    tp.setUserId(rs.getString("user_id"));
                    tp.setTeamId(rs.getObject("team_id") != null
                            ? rs.getInt("team_id")
                            : null);
                    tp.setRole(rs.getString("role"));
                    tp.setStatus(rs.getString("status"));
                    tp.setPaymentReference(rs.getString("paymentReference"));
                    tp.setJoinedAt(rs.getTimestamp("joined_at").toLocalDateTime());
                    list.add(tp);
                }
                return list;
            }
        }
    }

    @Override
    public void softDelete(long participantId) throws SQLException {
        String sql = """
            UPDATE tournament_participant
               SET status = 'CANCELLED'
             WHERE id = ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, participantId);
            ps.executeUpdate();
        }
    }
    // in TournamentParticipantDaoImpl.java

    @Override
    public TournamentParticipant findById(long id) throws SQLException {
        String sql = """
      SELECT id, prog_id, user_id, team_id, role, status, paymentReference, joined_at
        FROM tournament_participant
       WHERE id = ?
    """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                TournamentParticipant tp = new TournamentParticipant();
                tp.setId(rs.getLong("id"));
                tp.setProgId(rs.getInt("prog_id"));
                tp.setUserId(rs.getString("user_id"));
                tp.setTeamId(rs.getObject("team_id") != null
                        ? rs.getInt("team_id")
                        : null);
                tp.setRole(rs.getString("role"));
                tp.setStatus(rs.getString("status"));
                tp.setPaymentReference(rs.getString("paymentReference"));
                tp.setJoinedAt(rs.getTimestamp("joined_at")
                        .toLocalDateTime());
                return tp;
            }
        }
    }

    @Override
    public void updatePaymentStatusForTeam(int progId,
            Integer teamId,
            String status,
            String reference)
            throws SQLException {
        // use `<=>` for null-safe comparison
        String sql = """
      UPDATE tournament_participant
         SET status = ?, paymentReference = ?
       WHERE prog_id = ?
         AND team_id <=> ?
    """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, reference);
            ps.setInt(3, progId);
            if (teamId != null) {
                ps.setInt(4, teamId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.executeUpdate();
        }
    }
}
