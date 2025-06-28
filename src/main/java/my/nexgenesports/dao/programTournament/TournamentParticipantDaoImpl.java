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
              (prog_id, user_id, team_id, status, payment_ref, joined_at)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, tp.getProgId());
            ps.setString(2, tp.getUserId());
            if (tp.getTeamId() != null) ps.setInt(3, Integer.parseInt(tp.getTeamId()));
            else                         ps.setNull(3, Types.INTEGER);

            ps.setString(4, tp.getStatus());
            ps.setString(5, tp.getPaymentRef());
            ps.setTimestamp(6, Timestamp.valueOf(
                tp.getJoinedAt() != null ? tp.getJoinedAt() : LocalDateTime.now()
            ));

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    tp.setId(rs.getLong(1));
                }
            }
        }
    }

    @Override
    public List<TournamentParticipant> findByProgId(String progId) throws SQLException {
        String sql = """
            SELECT id, prog_id, user_id, team_id, status, payment_ref, joined_at
              FROM tournament_participant
             WHERE prog_id = ?
               AND status   = 'REGISTERED'
             ORDER BY joined_at
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                List<TournamentParticipant> list = new ArrayList<>();
                while (rs.next()) {
                    TournamentParticipant tp = new TournamentParticipant();
                    tp.setId(         rs.getLong("id"));
                    tp.setProgId(     rs.getString("prog_id"));
                    tp.setUserId(     rs.getString("user_id"));
                    tp.setTeamId(     rs.getString("team_id"));
                    tp.setStatus(     rs.getString("status"));
                    tp.setPaymentRef( rs.getString("payment_ref"));
                    tp.setJoinedAt(   rs.getTimestamp("joined_at").toLocalDateTime());
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
               SET status     = 'CANCELLED'
             WHERE id = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, participantId);
            ps.executeUpdate();
        }
    }
}
