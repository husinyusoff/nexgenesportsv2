// src/main/java/my/nexgenesports/dao/UserClubMembershipDao.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.UserClubMembership;
import java.sql.SQLException;

public interface UserClubMembershipDao {
    /** Insert a new membership record
     * @param m
     * @throws java.sql.SQLException */
    void insert(UserClubMembership m) throws SQLException;

    /** Find the latest (active) membership by user
     * @param userId
     * @return 
     * @throws java.sql.SQLException */
    UserClubMembership findLatestByUser(String userId) throws SQLException;

    /** NEW: Find a membership record by its primary key
     * @param id
     * @return 
     * @throws java.sql.SQLException */
    UserClubMembership findById(int id) throws SQLException;

    /** NEW: Update status, expiry, payment reference, etc.
     * @param m
     * @throws java.sql.SQLException */
    void update(UserClubMembership m) throws SQLException;
}
