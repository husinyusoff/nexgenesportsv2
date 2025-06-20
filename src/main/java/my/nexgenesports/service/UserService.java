package my.nexgenesports.service;

import my.nexgenesports.dao.user.RolePositionDao;
import my.nexgenesports.dao.user.UserDao;
import my.nexgenesports.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    private final UserDao         userDao = new UserDao();
    private final RolePositionDao rpDao   = new RolePositionDao();

    /**
     * Register a new user.
     * @param userID
     * @param name
     * @param password
     * @param confirmPassword
     * @param phone
     * @param role
     * @param position
     * @param clubSessionID
     * @param gamingPassID
     */
    public void register(
            String userID,
            String name,
            String password,
            String confirmPassword,
            String phone,
            String role,
            String position,
            String clubSessionID,
            Integer gamingPassID
    ) {
        if (!password.equals(confirmPassword)) {
            throw new ServiceException("❌ Passwords do not match.");
        }

        try {
            if (userDao.findByUserID(userID) != null) {
                throw new ServiceException("❌ That UserID already exists.");
            }
        } catch (SQLException e) {
            throw new ServiceException("Registration failed (DB error).", e);
        }

        int rpId;
        try {
            rpId = rpDao.findIdByRoleAndPosition(role, position);
        } catch (SQLException e) {
            throw new ServiceException("❌ Invalid role/position.", e);
        }

        String hash = BCrypt.hashpw(password, BCrypt.gensalt());

        User u = new User();
        u.setUserID        (userID);
        u.setName          (name);
        u.setPasswordHash  (hash);
        u.setPhoneNumber   (phone);
        u.setRpId          (rpId);
        u.setClubSessionID (clubSessionID);
        u.setGamingPassID  (gamingPassID);

        try {
            userDao.save(u);
        } catch (SQLException e) {
            throw new ServiceException("❌ Registration failed (DB error).", e);
        }
    }

    /**
     * Authenticate a user + allow them to pick any of their effective roles.
     * @param userID
     * @param password
     * @param selectedRole
     * @return 
     */
    public User authenticate(String userID, String password, String selectedRole) {
        try {
            // 1) look up user + password check
            User u = userDao.findByUserID(userID);
            if (u == null || !BCrypt.checkpw(password, u.getPasswordHash())) {
                throw new ServiceException("❌ Invalid user ID or password.");
            }

            // 2) get their base role
            String actualRole = rpDao.findRoleByRpId(u.getRpId());

            // 3) compute the full set of roles they may *act* as
            List<String> eff = getEffectiveRoles(actualRole, u.getPosition());

            // 4) only allow login if they requested one of those
            if (!eff.contains(selectedRole)) {
                throw new ServiceException("❌ You are not authorized for that role.");
            }

            // at this point, u.getPosition() was already populated by UserDao
            return u;

        } catch (SQLException e) {
            throw new ServiceException("Login failed (DB error).", e);
        }
    }

    /**
     * Build a simple hierarchy:
     *   high_council      → [high_council, executive_council, athlete]
     *   executive_council → [executive_council, athlete]
     *   athlete/referee   → [athlete] or [referee]
     * @param role
     * @param position
     * @return 
     */
    public List<String> getEffectiveRoles(String role, String position) {
        List<String> eff = new ArrayList<>();
        switch (role) {
            case "high_council":
                eff.add("high_council");
                eff.add("executive_council");
                eff.add("athlete");
                break;
            case "executive_council":
                eff.add("executive_council");
                eff.add("athlete");
                break;
            default:
                eff.add(role);
        }
        return eff;
    }
}
