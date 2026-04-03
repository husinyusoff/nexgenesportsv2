package my.nexgenesports.dao.user;

import my.nexgenesports.model.User;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    /* ---- CREATE ---- */

    public void save(User u) throws SQLException {
        String sql = "INSERT INTO users "
                   + "(userID, name, email, password_hash, phoneNumber, rp_id) "
                   + "VALUES (?,?,?,?,?,?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, u.getUserID());
            ps.setString(2, u.getName());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPasswordHash());
            ps.setString(5, u.getPhoneNumber());
            ps.setInt   (6, u.getRpId());

            ps.executeUpdate();
        }
    }

    /* ---- READ ---- */

    public User findByUserID(String userID) throws SQLException {
        String sql =
            "SELECT u.userID, u.name, u.email, u.password_hash, u.phoneNumber,"
          + "       u.matricNumber, u.ign, u.bio, u.discordID, u.registrationDate,"
          + "       u.password_reset_token, u.password_reset_expiry,"
          + "       u.rp_id, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " WHERE u.userID = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    public User findByEmail(String email) throws SQLException {
        String sql =
            "SELECT u.userID, u.name, u.email, u.password_hash, u.phoneNumber,"
          + "       u.matricNumber, u.ign, u.bio, u.discordID, u.registrationDate,"
          + "       u.password_reset_token, u.password_reset_expiry,"
          + "       u.rp_id, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " WHERE u.email = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    public User findByPhoneNumber(String phoneNumber) throws SQLException {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) return null;
        String sql =
            "SELECT u.userID, u.name, u.email, u.password_hash, u.phoneNumber,"
          + "       u.matricNumber, u.ign, u.bio, u.discordID, u.registrationDate,"
          + "       u.password_reset_token, u.password_reset_expiry,"
          + "       u.rp_id, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " WHERE u.phoneNumber = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    public User findByMatricNumber(String matricNumber) throws SQLException {
        if (matricNumber == null || matricNumber.trim().isEmpty()) return null;
        String sql =
            "SELECT u.userID, u.name, u.email, u.password_hash, u.phoneNumber,"
          + "       u.matricNumber, u.ign, u.bio, u.discordID, u.registrationDate,"
          + "       u.password_reset_token, u.password_reset_expiry,"
          + "       u.rp_id, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " WHERE u.matricNumber = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, matricNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    public User findByResetToken(String token) throws SQLException {
        String sql =
            "SELECT u.userID, u.name, u.email, u.password_hash, u.phoneNumber,"
          + "       u.matricNumber, u.ign, u.bio, u.discordID, u.registrationDate,"
          + "       u.password_reset_token, u.password_reset_expiry,"
          + "       u.rp_id, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " WHERE u.password_reset_token = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    /* ---- UPDATE ---- */

    public void updateProfile(User u, String oldUserID) throws SQLException {
        String sql = "UPDATE users SET userID=?, name=?, email=?, phoneNumber=?,"
                   + " matricNumber=?, ign=?, bio=?, discordID=?"
                   + " WHERE userID=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getUserID());
            ps.setString(2, u.getName());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhoneNumber());
            ps.setString(5, u.getMatricNumber());
            ps.setString(6, u.getIgn());
            ps.setString(7, u.getBio());
            ps.setString(8, u.getDiscordID());
            ps.setString(9, oldUserID);
            ps.executeUpdate();
        }
    }

    public void saveResetToken(String userID, String token, LocalDateTime expiry) throws SQLException {
        String sql = "UPDATE users SET password_reset_token=?, password_reset_expiry=? WHERE userID=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, Timestamp.valueOf(expiry));
            ps.setString(3, userID);
            ps.executeUpdate();
        }
    }

    public void updatePassword(String userID, String newPasswordHash) throws SQLException {
        String sql = "UPDATE users SET password_hash=?, password_reset_token=NULL, password_reset_expiry=NULL WHERE userID=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setString(2, userID);
            ps.executeUpdate();
        }
    }

    public void updateUserRole(String userID, int rpId) throws SQLException {
        String sql = "UPDATE users SET rp_id=? WHERE userID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rpId);
            ps.setString(2, userID);
            ps.executeUpdate();
        }
    }

    /* ---- READ ALL ---- */
    public List<User> listAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql =
            "SELECT u.userID, u.name, u.email, u.password_hash, u.phoneNumber,"
          + "       u.matricNumber, u.ign, u.bio, u.discordID, u.registrationDate,"
          + "       u.password_reset_token, u.password_reset_expiry,"
          + "       u.rp_id, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " ORDER BY u.registrationDate DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /* ---- HELPERS ---- */

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserID       (rs.getString("userID"));
        u.setName         (rs.getString("name"));
        u.setEmail        (rs.getString("email"));
        u.setPasswordHash (rs.getString("password_hash"));
        u.setPhoneNumber  (rs.getString("phoneNumber"));
        u.setMatricNumber (rs.getString("matricNumber"));
        u.setIgn          (rs.getString("ign"));
        u.setBio          (rs.getString("bio"));
        u.setDiscordID    (rs.getString("discordID"));
        u.setRpId         (rs.getInt   ("rp_id"));
        u.setPosition     (rs.getString("position"));

        Timestamp regTs = rs.getTimestamp("registrationDate");
        if (regTs != null) u.setRegistrationDate(regTs.toLocalDateTime());

        u.setPasswordResetToken(rs.getString("password_reset_token"));
        Timestamp expTs = rs.getTimestamp("password_reset_expiry");
        if (expTs != null) u.setPasswordResetExpiry(expTs.toLocalDateTime());

        return u;
    }
}
