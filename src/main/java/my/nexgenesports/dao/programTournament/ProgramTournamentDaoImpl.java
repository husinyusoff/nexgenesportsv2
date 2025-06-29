package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import static java.util.stream.Collectors.joining;
import my.nexgenesports.model.TournamentParticipant;

public class ProgramTournamentDaoImpl implements ProgramTournamentDao {

    @Override
    public void insert(ProgramTournament pt) {
        String sql = """
            INSERT INTO program_tournament
              (creator_id,
               game_id,
               program_name,
               program_type,
               merit_id,
               place,
               description,
               prog_fee,
               start_date,
               end_date,
               start_time,
               end_time,
               prize_pool,
               max_capacity,
               max_team_member,
               status,
               bracket_format
              )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int i = 1;
            // 1) creator_id
            ps.setString(i++, pt.getCreatorId());
            // 2) game_id
            if (pt.getGameId() != null) {
                ps.setInt(i++, pt.getGameId());
            } else {
                ps.setNull(i++, Types.INTEGER);
            }
            // 3) program_name
            ps.setString(i++, pt.getProgramName());
            // 4) program_type
            ps.setString(i++, pt.getProgramType());
            // 5) merit_id
            if (pt.getMeritId() != null) {
                ps.setInt(i++, pt.getMeritId());
            } else {
                ps.setNull(i++, Types.INTEGER);
            }
            // 6) place
            ps.setString(i++, pt.getPlace());
            // 7) description
            ps.setString(i++, pt.getDescription());
            // 8) prog_fee
            if (pt.getProgFee() != null) {
                ps.setBigDecimal(i++, pt.getProgFee());
            } else {
                ps.setNull(i++, Types.DECIMAL);
            }
            // 9) start_date
            ps.setDate(i++, Date.valueOf(pt.getStartDate()));
            // 10) end_date
            ps.setDate(i++, Date.valueOf(pt.getEndDate()));
            // 11) start_time
            if (pt.getStartTime() != null) {
                ps.setTime(i++, Time.valueOf(pt.getStartTime()));
            } else {
                ps.setNull(i++, Types.TIME);
            }
            // 12) end_time
            if (pt.getEndTime() != null) {
                ps.setTime(i++, Time.valueOf(pt.getEndTime()));
            } else {
                ps.setNull(i++, Types.TIME);
            }
            // 13) prize_pool
            if (pt.getPrizePool() != null) {
                ps.setBigDecimal(i++, pt.getPrizePool());
            } else {
                ps.setNull(i++, Types.DECIMAL);
            }
            // 14) max_capacity
            ps.setInt(i++, pt.getMaxCapacity());
            // 15) max_team_member
            if (pt.getMaxTeamMember() != null) {
                ps.setInt(i++, pt.getMaxTeamMember());
            } else {
                ps.setNull(i++, Types.INTEGER);
            }
            // 16) status
            ps.setString(i++, pt.getStatus());
            // 17) bracket_format
            if (pt.getBracketFormat() != null) {
                ps.setString(i++, pt.getBracketFormat());
            } else {
                ps.setNull(i++, Types.VARCHAR);
            }

            ps.executeUpdate();

            // grab generated prog_id
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    pt.setProgId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error inserting ProgramTournament", e);
        }
    }

    @Override
    public ProgramTournament findById(String progId) {
        String sql = """
            SELECT *
              FROM program_tournament
             WHERE prog_id = ?
               AND deleted_flag = 0
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error loading ProgramTournament by ID", e);
        }
    }

    @Override
    public List<ProgramTournament> findByStatusIn(List<String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return List.of();
        }
        String inClause = statuses.stream().map(s -> "?").collect(joining(","));
        String sql
                = "SELECT * "
                + "FROM program_tournament "
                + "WHERE status IN (" + inClause + ") "
                + "AND deleted_flag = 0";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            for (int i = 0; i < statuses.size(); i++) {
                ps.setString(i + 1, statuses.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<ProgramTournament> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(mapRow(rs));
                }
                return out;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding ProgramTournaments by status", e);
        }
    }

    @Override
    public void update(ProgramTournament pt) {
        String sql = """
            UPDATE program_tournament
               SET game_id         = ?,
                   program_name    = ?,
                   program_type    = ?,
                   merit_id        = ?,
                   place           = ?,
                   description     = ?,
                   prog_fee        = ?,
                   start_date      = ?,
                   end_date        = ?,
                   start_time      = ?,
                   end_time        = ?,
                   prize_pool      = ?,
                   max_capacity    = ?,
                   max_team_member = ?,
                   status          = ?
             WHERE prog_id        = ?
               AND deleted_flag   = 0
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            int idx = 1;
            if (pt.getGameId() != null) {
                ps.setInt(idx++, pt.getGameId());
            } else {
                ps.setNull(idx++, Types.INTEGER);
            }

            ps.setString(idx++, pt.getProgramName());
            ps.setString(idx++, pt.getProgramType());

            if (pt.getMeritId() != null) {
                ps.setInt(idx++, pt.getMeritId());
            } else {
                ps.setNull(idx++, Types.INTEGER);
            }

            ps.setString(idx++, pt.getPlace());
            ps.setString(idx++, pt.getDescription());

            if (pt.getProgFee() != null) {
                ps.setBigDecimal(idx++, pt.getProgFee());
            } else {
                ps.setNull(idx++, Types.DECIMAL);
            }

            ps.setDate(idx++, Date.valueOf(pt.getStartDate()));
            ps.setDate(idx++, Date.valueOf(pt.getEndDate()));

            if (pt.getStartTime() != null) {
                ps.setTime(idx++, Time.valueOf(pt.getStartTime()));
            } else {
                ps.setNull(idx++, Types.TIME);
            }

            if (pt.getEndTime() != null) {
                ps.setTime(idx++, Time.valueOf(pt.getEndTime()));
            } else {
                ps.setNull(idx++, Types.TIME);
            }

            if (pt.getPrizePool() != null) {
                ps.setBigDecimal(idx++, pt.getPrizePool());
            } else {
                ps.setNull(idx++, Types.DECIMAL);
            }

            ps.setInt(idx++, pt.getMaxCapacity());

            if (pt.getMaxTeamMember() != null) {
                ps.setInt(idx++, pt.getMaxTeamMember());
            } else {
                ps.setNull(idx++, Types.INTEGER);
            }

            ps.setString(idx++, pt.getStatus());

            // final parameter: which row to update
            ps.setInt(idx, pt.getProgId());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating ProgramTournament", e);
        }
    }

    @Override
    public void softDelete(String progId) {
        String sql = """
            UPDATE program_tournament
               SET deleted_flag = 1
             WHERE prog_id = ?
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, progId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error soft‐deleting ProgramTournament", e);
        }
    }

    @Override
    public void updateStatus(String progId, String status) {
        String sql = """
            UPDATE program_tournament
               SET status = ?
             WHERE prog_id = ?
               AND deleted_flag = 0
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, progId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating status of ProgramTournament", e);
        }
    }

    /**
     * Helper to map a single row to your model
     */
    private ProgramTournament mapRow(ResultSet rs) throws SQLException {
        ProgramTournament pt = new ProgramTournament();

        pt.setProgId(rs.getInt("prog_id"));
        pt.setCreatorId(rs.getString("creator_id"));

        int gid = rs.getInt("game_id");
        if (!rs.wasNull()) {
            pt.setGameId(gid);
        }

        pt.setProgramName(rs.getString("program_name"));
        pt.setProgramType(rs.getString("program_type"));

        int mid = rs.getInt("merit_id");
        if (!rs.wasNull()) {
            pt.setMeritId(mid);
        }

        pt.setPlace(rs.getString("place"));
        pt.setDescription(rs.getString("description"));
        pt.setProgFee(rs.getBigDecimal("prog_fee"));
        pt.setStartDate(rs.getDate("start_date").toLocalDate());
        pt.setEndDate(rs.getDate("end_date").toLocalDate());

        Time st = rs.getTime("start_time");
        if (st != null) {
            pt.setStartTime(st.toLocalTime());
        }
        Time et = rs.getTime("end_time");
        if (et != null) {
            pt.setEndTime(et.toLocalTime());
        }

        pt.setPrizePool(rs.getBigDecimal("prize_pool"));
        pt.setMaxCapacity(rs.getInt("max_capacity"));

        int mx = rs.getInt("max_team_member");
        if (!rs.wasNull()) {
            pt.setMaxTeamMember(mx);
        }

        pt.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            pt.setCreatedAt(ca.toLocalDateTime());
        }
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            pt.setUpdatedAt(ua.toLocalDateTime());
        }

        pt.setDeletedFlag(rs.getBoolean("deleted_flag"));
        return pt;
    }

    @Override
    public List<TournamentParticipant> listParticipants(String progId) throws SQLException {
        String sql = """
        SELECT id,
               prog_id,
               user_id,
               team_id,
               status,
               payment_ref,
               joined_at
          FROM tournament_participant
         WHERE prog_id     = ?
           AND status      = 'REGISTERED'  -- or whatever filter you need
        """;

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progId);

            try (ResultSet rs = ps.executeQuery()) {
                List<TournamentParticipant> out = new ArrayList<>();
                while (rs.next()) {
                    TournamentParticipant tp = new TournamentParticipant();
                    tp.setId(rs.getLong("id"));
                    tp.setProgId(rs.getString("prog_id"));
                    tp.setUserId(rs.getString("user_id"));
                    tp.setTeamId(rs.getString("team_id"));
                    tp.setStatus(rs.getString("status"));
                    tp.setPaymentReference(rs.getString("paymentReference"));
                    tp.setJoinedAt(rs.getTimestamp("joined_at").toLocalDateTime());
                    out.add(tp);
                }
                return out;
            }
        }
    }

    @Override
    public List<ProgramTournament> findAll() {
        String sql = "SELECT * FROM program_tournament WHERE deleted_flag = 0 ORDER BY start_date";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<ProgramTournament> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapRow(rs));
            }
            return out;
        } catch (SQLException e) {
            throw new RuntimeException("Error listing ProgramTournaments", e);
        }
    }

    // in your DAO
    @Override
    public List<String> findAllScopes() throws SQLException {
        String sql = "SELECT DISTINCT scope FROM merit_level";
        try (var c = DBConnection.getConnection(); var ps = c.prepareStatement(sql); var rs = ps.executeQuery()) {
            List<String> scopes = new ArrayList<>();
            while (rs.next()) {
                scopes.add(rs.getString("scope"));
            }
            return scopes;
        }
    }

}
