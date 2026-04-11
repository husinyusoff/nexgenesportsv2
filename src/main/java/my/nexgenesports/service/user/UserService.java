package my.nexgenesports.service.user;

import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.dao.user.RolePositionDao;
import my.nexgenesports.dao.user.UserDao;
import my.nexgenesports.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService {
    private static final Logger LOG = Logger.getLogger(UserService.class.getName());

    private final UserDao         userDao = new UserDao();
    private final RolePositionDao rpDao   = new RolePositionDao();

    /* ---- REGISTRATION ---- */

    public void register(
            String userID,
            String name,
            String email,
            String password,
            String confirmPassword,
            String phone,
            String matricNumber,
            String role,
            String position
    ) {
        if (userID == null || userID.trim().isEmpty())
            throw new ServiceException("User ID is required.");
        if (name == null || name.trim().isEmpty())
            throw new ServiceException("Full name is required.");
        if (email == null || email.trim().isEmpty())
            throw new ServiceException("Email is required.");
        if (password == null || password.length() < 6)
            throw new ServiceException("Password must be at least 6 characters.");
        if (!password.equals(confirmPassword))
            throw new ServiceException("Passwords do not match.");

        try {
            if (userDao.findByUserID(userID) != null)
                throw new ServiceException("That User ID already exists.");
            if (userDao.findByEmail(email) != null)
                throw new ServiceException("That email is already registered.");
            if (phone != null && !phone.trim().isEmpty() && userDao.findByPhoneNumber(phone) != null)
                throw new ServiceException("That phone number is already registered.");
            if (matricNumber != null && !matricNumber.trim().isEmpty() && userDao.findByMatricNumber(matricNumber) != null)
                throw new ServiceException("That matric/staff number is already registered.");
        } catch (SQLException e) {
            throw new ServiceException("Registration failed (DB error).", e);
        }

        int rpId;
        try {
            // SECURITY FIX: Always force 'athlete' role on registration
            rpId = rpDao.findIdByRoleAndPosition("athlete", null);
        } catch (SQLException e) {
            throw new ServiceException("Registration failed: Default role not found.", e);
        }

        String hash = BCrypt.hashpw(password, BCrypt.gensalt());

        User u = new User();
        u.setUserID      (userID.trim());
        u.setName        (name.trim());
        u.setEmail       (email.trim().toLowerCase());
        u.setPasswordHash(hash);
        u.setPhoneNumber (phone);
        u.setMatricNumber(matricNumber);
        u.setRpId        (rpId);

        try {
            userDao.save(u);
        } catch (SQLException e) {
            throw new ServiceException("Registration failed (DB error).", e);
        }
    }

    /* ---- AUTHENTICATION ---- */

    public User authenticate(String userID, String password, String selectedRole) {
        try {
            User u = userDao.findByUserID(userID);
            if (u == null || !BCrypt.checkpw(password, u.getPasswordHash()))
                throw new ServiceException("Invalid user ID or password.");

            String actualRole = rpDao.findRoleByRpId(u.getRpId());
            
            if ("disabled".equals(actualRole)) {
                throw new ServiceException("Your account has been deactivated.");
            }

            List<String> eff = getEffectiveRoles(actualRole, u.getPosition());

            if (!eff.contains(selectedRole))
                throw new ServiceException("You are not authorized for that role.");

            return u;

        } catch (SQLException e) {
            throw new ServiceException("Login failed (DB error).", e);
        }
    }

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

    /* ---- PROFILE ---- */

    public User getProfile(String userID) {
        try {
            User u = userDao.findByUserID(userID);
            if (u == null) throw new ServiceException("User not found.");
            return u;
        } catch (SQLException e) {
            throw new ServiceException("Failed to load profile.", e);
        }
    }

    public void updateProfile(User u, String oldUserID) {
        try {
            // Check uniqueness for userID if changed
            if (!u.getUserID().equals(oldUserID)) {
                if (userDao.findByUserID(u.getUserID()) != null)
                    throw new ServiceException("User ID " + u.getUserID() + " is already taken.");
            }

            // Check uniqueness for email, phone, matric
            User existingEmail = userDao.findByEmail(u.getEmail());
            if (existingEmail != null && !existingEmail.getUserID().equals(oldUserID))
                throw new ServiceException("Email " + u.getEmail() + " is already taken.");

            User existingPhone = userDao.findByPhoneNumber(u.getPhoneNumber());
            if (existingPhone != null && !existingPhone.getUserID().equals(oldUserID))
                throw new ServiceException("Phone number " + u.getPhoneNumber() + " is already taken.");

            User existingMatric = userDao.findByMatricNumber(u.getMatricNumber());
            if (existingMatric != null && !existingMatric.getUserID().equals(oldUserID))
                throw new ServiceException("Matric/Staff number " + u.getMatricNumber() + " is already taken.");

            userDao.updateProfile(u, oldUserID);
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("foreign key constraint")) {
                throw new ServiceException("Cannot change User ID because it's referenced by other records (e.g. bookings). Please contact administrator.");
            }
            throw new ServiceException("Profile update failed (DB error).", e);
        }
    }

    /* ---- PASSWORD RESET ---- */

    public String requestPasswordReset(String email) {
        try {
            User u = userDao.findByEmail(email);
            if (u == null)
                throw new ServiceException("No account found with that email.");

            String token = UUID.randomUUID().toString().replace("-", "");
            LocalDateTime expiry = LocalDateTime.now().plusHours(1);

            userDao.saveResetToken(u.getUserID(), token, expiry);

            // Console Mock: Print the reset link to the server log
            LOG.log(Level.INFO,
                "\n====================================================\n"
              + "  PASSWORD RESET REQUEST\n"
              + "  User: {0}\n"
              + "  Token: {1}\n"
              + "  Expires: {2}\n"
              + "  Reset URL: /NexGenEsportsv2/auth?action=resetPassword&token={3}\n"
              + "====================================================",
                new Object[]{u.getUserID(), token, expiry, token});

            return token;

        } catch (SQLException e) {
            throw new ServiceException("Password reset failed (DB error).", e);
        }
    }

    public void resetPassword(String token, String newPassword, String confirmPassword) {
        if (newPassword == null || newPassword.length() < 6)
            throw new ServiceException("Password must be at least 6 characters.");
        if (!newPassword.equals(confirmPassword))
            throw new ServiceException("Passwords do not match.");

        try {
            User u = userDao.findByResetToken(token);
            if (u == null)
                throw new ServiceException("Invalid or expired reset link.");

            if (u.getPasswordResetExpiry() == null || u.getPasswordResetExpiry().isBefore(LocalDateTime.now()))
                throw new ServiceException("This reset link has expired. Please request a new one.");

            String hash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            userDao.updatePassword(u.getUserID(), hash);

        } catch (SQLException e) {
            throw new ServiceException("Password reset failed (DB error).", e);
        }
    }
}
