// File: src/main/java/my/nexgenesports/dao/tournament/BracketMatchDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.BracketMatch;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BracketMatchDaoImpl implements BracketMatchDao {

    @Override
    public BracketMatch insert(BracketMatch bm) throws SQLException {
        String sql = """
            INSERT INTO bracket_match
              (bracket_id, participant1_id, participant2_id,
               score1, score2, winner_id, updated_by, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, bm.getBracketId());
            ps.setLong(2, bm.getParticipant1());
            ps.setLong(3, bm.getParticipant2());
            if (bm.getScore1() != null) {
                ps.setInt(4, bm.getScore1());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (bm.getScore2() != null) {
                ps.setInt(5, bm.getScore2());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            if (bm.getWinner() != null) {
                ps.setLong(6, bm.getWinner());
            } else {
                ps.setNull(6, Types.BIGINT);
            }
            ps.setString(7, bm.getUpdatedBy());
            ps.setTimestamp(8, Timestamp.valueOf(bm.getUpdatedAt()));
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    bm.setMatchId(rs.getInt(1));
                }
            }
            return bm;
        }
    }

    @Override
    public List<BracketMatch> findByBracket(int bracketId) throws SQLException {
        String sql = "SELECT * FROM bracket_match WHERE bracket_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, bracketId);
            try (ResultSet rs = ps.executeQuery()) {
                List<BracketMatch> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(mapRow(rs));
                }
                return out;
            }
        }
    }

    @Override
    public void updateScore(int matchId, int score1, int score2, Long winnerId) throws SQLException {
        String sql = """
            UPDATE bracket_match
               SET score1 = ?, score2 = ?, winner_id = ?, updated_at = CURRENT_TIMESTAMP
             WHERE match_id = ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, score1);
            ps.setInt(2, score2);
            if (winnerId != null) {
                ps.setLong(3, winnerId);
            } else {
                ps.setNull(3, Types.BIGINT);
            }
            ps.setInt(4, matchId);
            ps.executeUpdate();
        }
    }

    @Override
    public void delete(int matchId) throws SQLException {
        String sql = "DELETE FROM bracket_match WHERE match_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, matchId);
            ps.executeUpdate();
        }
    }

    private BracketMatch mapRow(ResultSet rs) throws SQLException {
        BracketMatch bm = new BracketMatch();
        bm.setMatchId(rs.getInt("match_id"));
        bm.setBracketId(rs.getInt("bracket_id"));
        bm.setParticipant1(rs.getLong("participant1_id"));
        bm.setParticipant2(rs.getLong("participant2_id"));
        int s1 = rs.getInt("score1");
        bm.setScore1(!rs.wasNull() ? s1 : null);
        int s2 = rs.getInt("score2");
        bm.setScore2(!rs.wasNull() ? s2 : null);
        long w = rs.getLong("winner_id");
        bm.setWinner(!rs.wasNull() ? w : null);
        bm.setUpdatedBy(rs.getString("updated_by"));
        bm.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return bm;
    }

    @Override
    public BracketMatch findById(int matchId) throws SQLException {
        String sql = "SELECT * FROM bracket_match WHERE match_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, matchId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public void updateScore(BracketMatch m) throws SQLException {
        // null‐safety as before
        int s1 = m.getScore1() == null ? 0 : m.getScore1();
        int s2 = m.getScore2() == null ? 0 : m.getScore2();
        updateScore(m.getMatchId(), s1, s2, m.getWinner());
    }

    @Override
    public BracketMatch findByBracketAndRoundAndMatch(
            int bracketId,
            int round,
            int matchNumber
    ) throws SQLException {
        String sql = """
            SELECT *
              FROM bracket_match
             WHERE bracket_id   = ?
               AND match_number = ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, bracketId);
            ps.setInt(2, matchNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public void updateParticipants(BracketMatch m) throws SQLException {
        String sql = """
            UPDATE bracket_match
               SET participant1_id = ?,
                   participant2_id = ?
             WHERE match_id        = ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            // slot #1 or #2 may be null
            if (m.getParticipant1() != null) {
                ps.setLong(1, m.getParticipant1());
            } else {
                ps.setNull(1, Types.BIGINT);
            }
            if (m.getParticipant2() != null) {
                ps.setLong(2, m.getParticipant2());
            } else {
                ps.setNull(2, Types.BIGINT);
            }

            ps.setInt(3, m.getMatchId());
            ps.executeUpdate();
        }
    }

}
