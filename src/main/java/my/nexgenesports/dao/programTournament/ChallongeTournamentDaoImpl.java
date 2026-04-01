package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ChallongeTournament;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class ChallongeTournamentDaoImpl implements ChallongeTournamentDao {

    @Override
    public void insertOrUpdate(ChallongeTournament ct) throws SQLException {
        String sql = """
      INSERT INTO challonge_tournament
        (prog_id, challonge_id, challonge_url, state, metadata, created_at)
      VALUES (?,?,?,?,?,?)
      ON DUPLICATE KEY UPDATE
        challonge_id  = VALUES(challonge_id),
        challonge_url = VALUES(challonge_url),
        state         = VALUES(state),
        metadata      = VALUES(metadata),
        last_sync_at  = CURRENT_TIMESTAMP
      """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, ct.getProgId());
            ps.setString(2, ct.getChallongeId());
            ps.setString(3, ct.getChallongeUrl());
            ps.setString(4, ct.getState());
            ps.setString(5, ct.getMetadata());           // ← set metadata here
            ps.setTimestamp(6, Timestamp.valueOf(ct.getCreatedAt()));
            ps.executeUpdate();
        }
    }

    @Override
    public ChallongeTournament findByProgId(int progId) throws SQLException {
        String sql = "SELECT * FROM challonge_tournament WHERE prog_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                ChallongeTournament ct = new ChallongeTournament();
                ct.setProgId(progId);
                ct.setChallongeId(rs.getString("challonge_id"));
                ct.setChallongeUrl(rs.getString("challonge_url"));
                ct.setState(rs.getString("state"));
                ct.setMetadata(rs.getString("metadata"));      // ← read it here
                ct.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                Timestamp t = rs.getTimestamp("last_sync_at");
                ct.setLastSyncAt(t == null ? null : t.toLocalDateTime());
                return ct;
            }
        }
    }

    @Override
    public void deleteByProgId(int progId) throws SQLException {
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(
                "DELETE FROM challonge_tournament WHERE prog_id=?"
        )) {
            ps.setInt(1, progId);
            ps.executeUpdate();
        }
    }
}
