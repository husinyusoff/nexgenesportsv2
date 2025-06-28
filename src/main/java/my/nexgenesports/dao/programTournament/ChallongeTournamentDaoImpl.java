package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ChallongeTournament;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class ChallongeTournamentDaoImpl implements ChallongeTournamentDao {

    @Override
    public ChallongeTournament findByProg(String progId) throws SQLException {
        String sql = "SELECT * FROM challonge_tournament WHERE prog_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                ChallongeTournament ct = new ChallongeTournament();
                ct.setProgId(             rs.getString("prog_id"));
                ct.setChallongeTournamentId(rs.getString("challonge_id"));
                ct.setChallongeUrl(       rs.getString("challonge_url"));
                ct.setChallongeState(     rs.getString("state"));
                ct.setChallongeMetadata(  rs.getString("metadata"));
                Timestamp ca = rs.getTimestamp("created_at");
                ct.setChallongeCreatedAt(ca != null
                    ? ca.toLocalDateTime()
                    : null);
                Timestamp ls = rs.getTimestamp("last_sync_at");
                ct.setChallongeLastSyncAt(ls != null
                    ? ls.toLocalDateTime()
                    : null);
                return ct;
            }
        }
    }

    @Override
    public void insert(ChallongeTournament ct) throws SQLException {
        String sql = """
            INSERT INTO challonge_tournament
              (prog_id, challonge_id, challonge_url, state, metadata, created_at, last_sync_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, ct.getProgId());
            ps.setString(2, ct.getChallongeTournamentId());
            ps.setString(3, ct.getChallongeUrl());
            ps.setString(4, ct.getChallongeState());
            ps.setString(5, ct.getChallongeMetadata());
            ps.setTimestamp(6, ct.getChallongeCreatedAt() != null
                ? Timestamp.valueOf(ct.getChallongeCreatedAt())
                : null);
            ps.setTimestamp(7, ct.getChallongeLastSyncAt() != null
                ? Timestamp.valueOf(ct.getChallongeLastSyncAt())
                : null);
            ps.executeUpdate();
        }
    }

    @Override
    public void update(ChallongeTournament ct) throws SQLException {
        String sql = """
            UPDATE challonge_tournament
               SET challonge_id   = ?,
                   challonge_url  = ?,
                   state          = ?,
                   metadata       = ?,
                   last_sync_at   = ?
             WHERE prog_id = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, ct.getChallongeTournamentId());
            ps.setString(2, ct.getChallongeUrl());
            ps.setString(3, ct.getChallongeState());
            ps.setString(4, ct.getChallongeMetadata());
            ps.setTimestamp(5, ct.getChallongeLastSyncAt() != null
                ? Timestamp.valueOf(ct.getChallongeLastSyncAt())
                : null);
            ps.setString(6, ct.getProgId());
            ps.executeUpdate();
        }
    }

    @Override
    public void delete(String progId) throws SQLException {
        String sql = "DELETE FROM challonge_tournament WHERE prog_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progId);
            ps.executeUpdate();
        }
    }
}
