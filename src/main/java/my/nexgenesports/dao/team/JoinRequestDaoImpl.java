package my.nexgenesports.dao.team;

import my.nexgenesports.model.JoinRequest;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JoinRequestDaoImpl implements JoinRequestDao {

    @Override
    public JoinRequest insert(JoinRequest jr) throws SQLException {
        String sql = """
            INSERT INTO join_request
              (teamID, userID, requestedAt, status, respondedAt)
            VALUES (?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt   (1, jr.getTeamID());
            ps.setString(2, jr.getUserID());
            ps.setTimestamp(3, Timestamp.valueOf(jr.getRequestedAt()));
            ps.setString   (4, jr.getStatus());
            if (jr.getRespondedAt() != null) {
                ps.setTimestamp(5, Timestamp.valueOf(jr.getRespondedAt()));
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    jr.setRequestID(keys.getInt(1));
                }
            }
            return jr;
        }
    }

    @Override
    public void updateStatus(int requestID, String status, LocalDateTime respondedAt) 
            throws SQLException {
        String sql = """
            UPDATE join_request
               SET status = ?, respondedAt = ?
             WHERE requestID = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString   (1, status);
            ps.setTimestamp(2, respondedAt != null 
                            ? Timestamp.valueOf(respondedAt) 
                            : null);
            ps.setInt      (3, requestID);
            ps.executeUpdate();
        }
    }

    @Override
    public JoinRequest findById(int requestID) throws SQLException {
        String sql = "SELECT * FROM join_request WHERE requestID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public JoinRequest findPendingByTeamAndUser(int teamID, String userID) 
            throws SQLException {
        String sql = """
            SELECT * FROM join_request
             WHERE teamID = ? AND userID = ? AND status = 'Pending'
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            ps.setString(2, userID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public List<JoinRequest> listPendingByTeam(int teamID) throws SQLException {
        String sql = "SELECT * FROM join_request WHERE teamID = ? AND status = 'Pending'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, teamID);
            try (ResultSet rs = ps.executeQuery()) {
                List<JoinRequest> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    private JoinRequest mapRow(ResultSet rs) throws SQLException {
        JoinRequest jr = new JoinRequest();
        jr.setRequestID  (rs.getInt("requestID"));
        jr.setTeamID     (rs.getInt("teamID"));
        jr.setUserID     (rs.getString("userID"));
        jr.setRequestedAt(rs.getTimestamp("requestedAt").toLocalDateTime());
        jr.setStatus     (rs.getString("status"));
        Timestamp rts    = rs.getTimestamp("respondedAt");
        if (rts != null) jr.setRespondedAt(rts.toLocalDateTime());
        return jr;
    }
}
