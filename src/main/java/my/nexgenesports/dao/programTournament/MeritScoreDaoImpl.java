// File: src/main/java/my/nexgenesports/dao/tournament/MeritScoreDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.MeritScore;
import my.nexgenesports.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MeritScoreDaoImpl implements MeritScoreDao {

    @Override
    public MeritScore insert(MeritScore ms) throws SQLException {
        String sql = """
            INSERT INTO merit_score (merit_id, rank, points)
            VALUES (?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt   (1, ms.getMeritId());
            ps.setString(2, ms.getRank());
            ps.setInt   (3, ms.getPoints());
            ps.executeUpdate();
            return ms;
        }
    }

    @Override
    public List<MeritScore> findByMeritId(int meritId) throws SQLException {
        String sql = "SELECT * FROM merit_score WHERE merit_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, meritId);
            try (ResultSet rs = ps.executeQuery()) {
                List<MeritScore> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(mapRow(rs));
                }
                return out;
            }
        }
    }

    @Override
    public void update(MeritScore ms) throws SQLException {
        String sql = """
            UPDATE merit_score
               SET points = ?
             WHERE merit_id = ? AND rank = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt   (1, ms.getPoints());
            ps.setInt   (2, ms.getMeritId());
            ps.setString(3, ms.getRank());
            ps.executeUpdate();
        }
    }

    @Override
    public void delete(int meritId, String rank) throws SQLException {
        String sql = "DELETE FROM merit_score WHERE merit_id = ? AND rank = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt   (1, meritId);
            ps.setString(2, rank);
            ps.executeUpdate();
        }
    }

    private MeritScore mapRow(ResultSet rs) throws SQLException {
        MeritScore ms = new MeritScore();
        ms.setMeritId(rs.getInt("merit_id"));
        ms.setRank    (rs.getString("rank"));
        ms.setPoints  (rs.getInt("points"));
        return ms;
    }
}
