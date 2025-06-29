// File: src/main/java/my/nexgenesports/dao/tournament/MeritLevelDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.MeritLevel;
import my.nexgenesports.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MeritLevelDaoImpl implements MeritLevelDao {

    @Override
    public MeritLevel insert(MeritLevel ml) throws SQLException {
        String sql = """
            INSERT INTO merit_level (name, description)
            VALUES (?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, ml.getName());
            ps.setString(2, ml.getDescription());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    ml.setMeritId(rs.getInt(1));
                }
            }
            return ml;
        }
    }

    @Override
    public MeritLevel findById(int meritId) throws SQLException {
        String sql = "SELECT * FROM merit_level WHERE merit_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, meritId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public List<MeritLevel> findAll() throws SQLException {
        String sql = "SELECT * FROM merit_level";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<MeritLevel> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapRow(rs));
            }
            return out;
        }
    }

    @Override
    public MeritLevel findByCategoryAndScope(String category, String scope) throws SQLException {
        String sql = "SELECT * FROM merit_level WHERE category = ? AND scope = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, category);
            ps.setString(2, scope);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public void update(MeritLevel ml) throws SQLException {
        String sql = """
            UPDATE merit_level
               SET name = ?, description = ?
             WHERE merit_id = ?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, ml.getName());
            ps.setString(2, ml.getDescription());
            ps.setInt   (3, ml.getMeritId());
            ps.executeUpdate();
        }
    }

    @Override
    public void delete(int meritId) throws SQLException {
        String sql = "DELETE FROM merit_level WHERE merit_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, meritId);
            ps.executeUpdate();
        }
    }

    private MeritLevel mapRow(ResultSet rs) throws SQLException {
        MeritLevel ml = new MeritLevel();
        ml.setMeritId   (rs.getInt("merit_id"));
        ml.setName      (rs.getString("name"));
        ml.setDescription(rs.getString("description"));
        return ml;
    }
}
