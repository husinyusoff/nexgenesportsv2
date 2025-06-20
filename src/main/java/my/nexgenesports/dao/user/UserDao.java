package my.nexgenesports.dao.user;

import my.nexgenesports.model.User;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class UserDao {

    /**
     * Insert a new User into the database.
     * @param u
     * @throws java.sql.SQLException
     */
    public void save(User u) throws SQLException {
        String sql = "INSERT INTO users "
                   + "(userID,name,password_hash,phoneNumber,rp_id,clubSessionID,gamingPassID) "
                   + "VALUES (?,?,?,?,?,?,?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, u.getUserID());
            ps.setString(2, u.getName());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getPhoneNumber());
            ps.setInt   (5, u.getRpId());
            ps.setString(6, u.getClubSessionID());

            if (u.getGamingPassID() == null) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, u.getGamingPassID());
            }

            ps.executeUpdate();
        }
    }

    /**
     * Retrieve a User by userID, including their RP→position via JOIN.
     * @param userID
     * @return 
     * @throws java.sql.SQLException
     */
    public User findByUserID(String userID) throws SQLException {
        String sql =
            "SELECT u.userID, u.name, u.password_hash, u.phoneNumber, u.rp_id,"
          + "       u.clubSessionID, u.gamingPassID, rp.position"
          + "  FROM users u"
          + "  LEFT JOIN role_positions rp ON u.rp_id = rp.id"
          + " WHERE u.userID = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                User u = new User();
                u.setUserID       (rs.getString("userID"));
                u.setName         (rs.getString("name"));
                u.setPasswordHash (rs.getString("password_hash"));
                u.setPhoneNumber  (rs.getString("phoneNumber"));
                u.setRpId         (rs.getInt   ("rp_id"));
                u.setClubSessionID(rs.getString("clubSessionID"));

                int gp = rs.getInt("gamingPassID");
                if (rs.wasNull())    u.setGamingPassID(null);
                else                 u.setGamingPassID(gp);

                u.setPosition     (rs.getString("position")); // ← NEW

                return u;
            }
        }
    }
}
