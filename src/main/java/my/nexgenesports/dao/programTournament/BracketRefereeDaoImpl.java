// File: src/main/java/my/nexgenesports/dao/tournament/BracketRefereeDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.BracketReferee;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BracketRefereeDaoImpl implements BracketRefereeDao {

    @Override
    public BracketReferee insert(BracketReferee br) throws SQLException {
        String sql = """
            INSERT INTO bracket_referee
              (bracket_id, referee_id, assigned_at)
            VALUES (?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt      (1, br.getBracketId());
            ps.setString   (2, br.getRefereeId());
            ps.setTimestamp(3, Timestamp.valueOf(br.getAssignedAt()));
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    br.setId(rs.getInt(1));
                }
            }
            return br;
        }
    }

    @Override
    public List<BracketReferee> findByBracket(int bracketId) throws SQLException {
        String sql = "SELECT * FROM bracket_referee WHERE bracket_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, bracketId);
            try (ResultSet rs = ps.executeQuery()) {
                List<BracketReferee> out = new ArrayList<>();
                while (rs.next()) {
                    BracketReferee br = new BracketReferee();
                    br.setId         (rs.getInt("id"));
                    br.setBracketId  (rs.getInt("bracket_id"));
                    br.setRefereeId  (rs.getString("referee_id"));
                    br.setAssignedAt (rs.getTimestamp("assigned_at").toLocalDateTime());
                    out.add(br);
                }
                return out;
            }
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM bracket_referee WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
