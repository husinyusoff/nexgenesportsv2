// File: src/main/java/my/nexgenesports/dao/tournament/BracketDaoImpl.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.Bracket;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BracketDaoImpl implements BracketDao {

    @Override
    public Bracket insert(Bracket b) throws SQLException {
        String sql = """
            INSERT INTO bracket
              (prog_id, name, format, created_by, created_at, is_deleted)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, b.getProgId());
            ps.setString(2, b.getName());
            ps.setString(3, b.getFormat());
            ps.setString(4, b.getCreatedBy());
            ps.setTimestamp(5, Timestamp.valueOf(b.getCreatedAt()));
            ps.setBoolean(6, b.isDeleted());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    b.setBracketId(rs.getInt(1));
                }
            }
            return b;
        }
    }

    @Override
    public Bracket findById(int bracketId) throws SQLException {
        String sql = "SELECT * FROM bracket WHERE bracket_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, bracketId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public List<Bracket> findByProg(String progId) throws SQLException {
        String sql = "SELECT * FROM bracket WHERE prog_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, progId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Bracket> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(mapRow(rs));
                }
                return out;
            }
        }
    }

    @Override
    public void delete(int bracketId) throws SQLException {
        String sql = "DELETE FROM bracket WHERE bracket_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, bracketId);
            ps.executeUpdate();
        }
    }

    private Bracket mapRow(ResultSet rs) throws SQLException {
        Bracket b = new Bracket();
        b.setBracketId(rs.getInt("bracket_id"));
        b.setProgId(rs.getString("prog_id"));
        b.setName(rs.getString("name"));
        b.setFormat(rs.getString("format"));
        b.setCreatedBy(rs.getString("created_by"));
        b.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        b.setDeleted(rs.getBoolean("is_deleted"));
        return b;
    }
    
@Override
public void update(Bracket b) throws SQLException {
    String sql = """
        UPDATE bracket
           SET prog_id = ?,
               name    = ?,
               format  = ?
         WHERE bracket_id = ?
           AND is_deleted  = 0
        """;

    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {

        int idx = 1;
        ps.setString(idx++, b.getProgId());
        ps.setString(idx++, b.getName());
        ps.setString(idx++, b.getFormat());
        ps.setInt(idx, b.getBracketId());
        ps.executeUpdate();
    }
}

    @Override
    public void softDelete(int id) throws SQLException {
        String sql = "UPDATE bracket SET is_deleted = 1 WHERE bracket_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
