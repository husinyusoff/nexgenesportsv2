// src/main/java/my/nexgenesports/dao/programTournament/ProgramTournamentSyncDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramTournamentSync;
import my.nexgenesports.model.ChallongeState;
import my.nexgenesports.util.DBConnection;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.Optional;

public class ProgramTournamentSyncDaoImpl implements ProgramTournamentSyncDao {
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Override
    public void insert(ProgramTournamentSync s) throws SQLException {
        String sql = """
            INSERT INTO program_tournament_sync
              (progID,
               challonge_tournament_id,
               challonge_url,
               challonge_state,
               challonge_created_at,
               challonge_last_sync_at,
               challonge_metadata)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, s.getProgID());
            ps.setString(2, s.getChallongeTournamentId());
            ps.setString(3, s.getChallongeUrl());
            ps.setString(4, s.getChallongeState().name());
            ps.setTimestamp(5, toTs(s.getChallongeCreatedAt()));
            ps.setTimestamp(6, toTs(s.getChallongeLastSyncAt()));
            ps.setString(7, toJson(s.getChallongeMetadata()));
            ps.executeUpdate();
        }
    }

    @Override
    public void update(ProgramTournamentSync s) throws SQLException {
        String sql = """
            UPDATE program_tournament_sync SET
              challonge_tournament_id = ?,
              challonge_url           = ?,
              challonge_state         = ?,
              challonge_created_at    = ?,
              challonge_last_sync_at  = ?,
              challonge_metadata      = ?
            WHERE progID = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, s.getChallongeTournamentId());
            ps.setString(2, s.getChallongeUrl());
            ps.setString(3, s.getChallongeState().name());
            ps.setTimestamp(4, toTs(s.getChallongeCreatedAt()));
            ps.setTimestamp(5, toTs(s.getChallongeLastSyncAt()));
            ps.setString(6, toJson(s.getChallongeMetadata()));
            ps.setString(7, s.getProgID());
            ps.executeUpdate();
        }
    }

    @Override
    public void upsert(ProgramTournamentSync s) throws SQLException {
        String sql = """
            INSERT INTO program_tournament_sync
              (progID,
               challonge_tournament_id,
               challonge_url,
               challonge_state,
               challonge_created_at,
               challonge_last_sync_at,
               challonge_metadata)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
              challonge_tournament_id = VALUES(challonge_tournament_id),
              challonge_url           = VALUES(challonge_url),
              challonge_state         = VALUES(challonge_state),
              challonge_created_at    = VALUES(challonge_created_at),
              challonge_last_sync_at  = VALUES(challonge_last_sync_at),
              challonge_metadata      = VALUES(challonge_metadata)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, s.getProgID());
            ps.setString(2, s.getChallongeTournamentId());
            ps.setString(3, s.getChallongeUrl());
            ps.setString(4, s.getChallongeState().name());
            ps.setTimestamp(5, toTs(s.getChallongeCreatedAt()));
            ps.setTimestamp(6, toTs(s.getChallongeLastSyncAt()));
            ps.setString(7, toJson(s.getChallongeMetadata()));
            ps.executeUpdate();
        }
    }

    @Override
    public Optional<ProgramTournamentSync> findByProgId(String progID) throws SQLException {
        String sql = "SELECT * FROM program_tournament_sync WHERE progID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return Optional.empty();
                }

                ProgramTournamentSync s = new ProgramTournamentSync();
                s.setProgID(rs.getString("progID"));
                s.setChallongeTournamentId(rs.getString("challonge_tournament_id"));
                s.setChallongeUrl(rs.getString("challonge_url"));
                s.setChallongeState(ChallongeState.valueOf(rs.getString("challonge_state")));

                Timestamp ca = rs.getTimestamp("challonge_created_at");
                if (ca != null) {
                    s.setChallongeCreatedAt(ca.toLocalDateTime());
                }
                Timestamp ls = rs.getTimestamp("challonge_last_sync_at");
                if (ls != null) {
                    s.setChallongeLastSyncAt(ls.toLocalDateTime());
                }

                String raw = rs.getString("challonge_metadata");
                JsonNode node = (raw != null && !raw.isBlank())
                    ? MAPPER.readTree(raw)
                    : null;
                s.setChallongeMetadata(node);

                return Optional.of(s);
            } catch (JsonProcessingException e) {
                throw new SQLException("Invalid JSON in metadata", e);
            }
        }
    }

    @Override
    public void deleteByProgId(String progID) throws SQLException {
        String sql = "DELETE FROM program_tournament_sync WHERE progID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, progID);
            ps.executeUpdate();
        }
    }

    // ──── helpers ────────────────────────────────────────────────────────────────

    private static Timestamp toTs(LocalDateTime dt) {
        return dt != null ? Timestamp.valueOf(dt) : null;
    }

    private static String toJson(JsonNode node) throws SQLException {
        if (node == null) return null;
        try {
            return MAPPER.writeValueAsString(node);
        } catch (JsonProcessingException e) {
            throw new SQLException("Failed to serialize JSON metadata", e);
        }
    }
}
