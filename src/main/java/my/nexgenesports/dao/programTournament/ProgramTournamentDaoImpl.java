// src/main/java/my/nexgenesports/dao/programTournament/ProgramTournamentDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.TournamentMode;
import my.nexgenesports.model.TournamentStatus;
import my.nexgenesports.model.ProgramType;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgramTournamentDaoImpl implements ProgramTournamentDao {

    @Override
    public void insert(ProgramTournament t) throws SQLException {
        String sql = """
            INSERT INTO program_tournament
              (progID, creator_id, gameID, programName, meritLevel, place,
               description, progFee, startDate, endDate, startTime, endTime,
               prizePool, capacity, tournamentMode, max_team_member,
               status, deleted_flag, version, tournamentType, openSignup,
               startAt, endAt, program_type)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1,  t.getProgID());
            ps.setString(2,  t.getCreatorId());
            ps.setString(3,  t.getGameID());
            ps.setString(4,  t.getProgramName());
            ps.setString(5,  t.getMeritLevel());
            ps.setString(6,  t.getPlace());
            ps.setString(7,  t.getDescription());
            ps.setBigDecimal(8,  t.getProgFee());
            ps.setDate(9,    Date.valueOf(t.getStartDate()));
            ps.setDate(10,   Date.valueOf(t.getEndDate()));
            ps.setTime(11,   t.getStartTime() != null ? Time.valueOf(t.getStartTime()) : null);
            ps.setTime(12,   t.getEndTime()   != null ? Time.valueOf(t.getEndTime())   : null);
            ps.setBigDecimal(13, t.getPrizePool());
            ps.setInt(14,    t.getCapacity());
            ps.setString(15, t.getTournamentMode().name());
            ps.setInt(16,    t.getMaxTeamMember());
            ps.setString(17, t.getStatus().name());
            ps.setBoolean(18, t.isDeletedFlag());
            ps.setInt(19,    t.getVersion());
            ps.setString(20, t.getTournamentType());
            ps.setBoolean(21, t.isOpenSignup());
            ps.setTimestamp(22, t.getStartAt() != null ? Timestamp.valueOf(t.getStartAt()) : null);
            ps.setTimestamp(23, t.getEndAt()   != null ? Timestamp.valueOf(t.getEndAt())   : null);
            ps.setString(24, t.getProgramType().name());

            ps.executeUpdate();
        }
    }

    @Override
    public ProgramTournament findById(String progID) throws SQLException {
        String sql = """
            SELECT * FROM program_tournament
             WHERE progID = ?
               AND deleted_flag = FALSE
            """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    @Override
    public List<ProgramTournament> listByCreator(String creatorId) throws SQLException {
        String sql = """
            SELECT * FROM program_tournament
             WHERE creator_id = ?
               AND deleted_flag = FALSE
             ORDER BY startDate
            """;

        List<ProgramTournament> out = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(mapRow(rs));
                }
            }
        }
        return out;
    }

    @Override
    public List<ProgramTournament> listByStatus(String status) throws SQLException {
        String sql = """
            SELECT * FROM program_tournament
             WHERE status = ?
               AND deleted_flag = FALSE
             ORDER BY startDate
            """;

        List<ProgramTournament> out = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(mapRow(rs));
                }
            }
        }
        return out;
    }

    @Override
    public void update(ProgramTournament t) throws SQLException {
        String sql = """
            UPDATE program_tournament SET
              creator_id       = ?,
              gameID           = ?,
              programName      = ?,
              meritLevel       = ?,
              place            = ?,
              description      = ?,
              progFee          = ?,
              startDate        = ?,
              endDate          = ?,
              startTime        = ?,
              endTime          = ?,
              prizePool        = ?,
              capacity         = ?,
              tournamentMode   = ?,
              max_team_member  = ?,
              status           = ?,
              deleted_flag     = ?,
              version          = ?,
              tournamentType   = ?,
              openSignup       = ?,
              startAt          = ?,
              endAt            = ?,
              program_type     = ?
            WHERE progID = ?
              AND version = ?
            """;

        int newVersion = t.getVersion() + 1;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1,  t.getCreatorId());
            ps.setString(2,  t.getGameID());
            ps.setString(3,  t.getProgramName());
            ps.setString(4,  t.getMeritLevel());
            ps.setString(5,  t.getPlace());
            ps.setString(6,  t.getDescription());
            ps.setBigDecimal(7,  t.getProgFee());
            ps.setDate(8,    Date.valueOf(t.getStartDate()));
            ps.setDate(9,    Date.valueOf(t.getEndDate()));
            ps.setTime(10,   t.getStartTime() != null ? Time.valueOf(t.getStartTime()) : null);
            ps.setTime(11,   t.getEndTime()   != null ? Time.valueOf(t.getEndTime())   : null);
            ps.setBigDecimal(12, t.getPrizePool());
            ps.setInt(13,    t.getCapacity());
            ps.setString(14, t.getTournamentMode().name());
            ps.setInt(15,    t.getMaxTeamMember());
            ps.setString(16, t.getStatus().name());
            ps.setBoolean(17, t.isDeletedFlag());
            ps.setInt(18,    newVersion);
            ps.setString(19, t.getTournamentType());
            ps.setBoolean(20, t.isOpenSignup());
            ps.setTimestamp(21, t.getStartAt() != null ? Timestamp.valueOf(t.getStartAt()) : null);
            ps.setTimestamp(22, t.getEndAt()   != null ? Timestamp.valueOf(t.getEndAt())   : null);
            ps.setString(23, t.getProgramType().name());
            ps.setString(24, t.getProgID());
            ps.setInt(25,   t.getVersion());

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException(
                  "Update failed for progID=" + t.getProgID()
                  + " (possible version mismatch)");
            }
        }
    }

    @Override
    public void softDelete(String progID) throws SQLException {
        String sql = """
            UPDATE program_tournament
               SET deleted_flag = TRUE
             WHERE progID = ?
            """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, progID);
            ps.executeUpdate();
        }
    }

    /** Helper to map one ResultSet row into a ProgramTournament */
    private ProgramTournament mapRow(ResultSet rs) throws SQLException {
        ProgramTournament t = new ProgramTournament();
        t.setProgID(        rs.getString("progID"));
        t.setCreatorId(     rs.getString("creator_id"));
        t.setGameID(        rs.getString("gameID"));
        t.setProgramName(   rs.getString("programName"));
        t.setMeritLevel(    rs.getString("meritLevel"));
        t.setPlace(         rs.getString("place"));
        t.setDescription(   rs.getString("description"));
        t.setProgFee(       rs.getBigDecimal("progFee"));
        t.setStartDate(     rs.getDate("startDate").toLocalDate());
        t.setEndDate(       rs.getDate("endDate").toLocalDate());
        Time st = rs.getTime("startTime");
        t.setStartTime(     st != null ? st.toLocalTime() : null);
        Time et = rs.getTime("endTime");
        t.setEndTime(       et != null ? et.toLocalTime() : null);
        t.setPrizePool(     rs.getBigDecimal("prizePool"));
        t.setCapacity(      rs.getInt("capacity"));
        t.setTournamentMode(TournamentMode.valueOf(rs.getString("tournamentMode")));
        t.setMaxTeamMember( rs.getInt("max_team_member"));
        t.setStatus(        TournamentStatus.valueOf(rs.getString("status")));
        t.setDeletedFlag(   rs.getBoolean("deleted_flag"));
        t.setVersion(       rs.getInt("version"));
        t.setTournamentType(rs.getString("tournamentType"));
        t.setOpenSignup(    rs.getBoolean("openSignup"));
        Timestamp sa = rs.getTimestamp("startAt");
        t.setStartAt(       sa != null ? sa.toLocalDateTime() : null);
        Timestamp ea = rs.getTimestamp("endAt");
        t.setEndAt(         ea != null ? ea.toLocalDateTime() : null);
        t.setProgramType(   ProgramType.valueOf(rs.getString("program_type")));
        return t;
    }
}
