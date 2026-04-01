package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.Game;
import my.nexgenesports.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GameDao {
    public int insert(Game g) throws SQLException {
        String sql = "INSERT INTO game (gameName, genre) VALUES (?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, g.getGameName());
            ps.setString(2, g.getGenre());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    g.setGameID(id);
                    return id;
                }
            }
        }
        return -1;
    }

    public Game findById(int id) throws SQLException {
        String sql = "SELECT * FROM game WHERE gameID = ? AND deleted_flag = FALSE";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<Game> listAll() throws SQLException {
        String sql = "SELECT * FROM game WHERE deleted_flag = FALSE ORDER BY gameName";
        var list = new ArrayList<Game>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public void update(Game g) throws SQLException {
        String sql = "UPDATE game SET gameName = ?, genre = ? WHERE gameID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, g.getGameName());
            ps.setString(2, g.getGenre());
            ps.setInt(3, g.getGameID());
            ps.executeUpdate();
        }
    }

    public void softDelete(int id) throws SQLException {
        String sql = "UPDATE game SET deleted_flag = TRUE WHERE gameID = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Game mapRow(ResultSet rs) throws SQLException {
        Game g = new Game();
        g.setGameID(rs.getInt("gameID"));
        g.setGameName(rs.getString("gameName"));
        g.setGenre(rs.getString("genre"));
        g.setDeletedFlag(rs.getBoolean("deleted_flag"));
        g.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        g.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return g;
    }
}
