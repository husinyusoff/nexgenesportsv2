// File: src/main/java/my/nexgenesports/dao/team/TeamMemberDao.java
package my.nexgenesports.dao.team;

import my.nexgenesports.model.TeamMember;
import java.sql.SQLException;
import java.util.List;

public interface TeamMemberDao {

    /**
     * Add a new membership record
     *
     * @param m
     * @throws java.sql.SQLException
     */
    void insert(TeamMember m) throws SQLException;

    /**
     * Update a member’s status (e.g.to “Declined”)
     *
     * @param teamID
     * @param userID
     * @param status
     * @throws java.sql.SQLException
     */
    void updateStatus(int teamID, String userID, String status) throws SQLException;

    /**
     * Change a member’s role (and bump roleAssignedAt to now)
     *
     * @param teamID
     * @param userID
     * @param role
     * @throws java.sql.SQLException
     */
    void updateRole(int teamID, String userID, String role) throws SQLException;

    /**
     * Total number of Active members in this team (for capacity checks)
     *
     * @param teamID
     * @return
     * @throws java.sql.SQLException
     */
    int countActiveMembers(int teamID) throws SQLException;

    /**
     * Number of Active members in this team holding exactly the given role
     *
     * @param teamID
     * @param role
     * @return
     * @throws java.sql.SQLException
     */
    int countActiveRole(int teamID, String role) throws SQLException;

    /**
     * All membership records (any status/role) for a given team
     *
     * @param teamID
     * @return
     * @throws java.sql.SQLException
     */
    List<TeamMember> listByTeam(int teamID) throws SQLException;

    /**
     * All membership records (any status/role) for a given user
     *
     * @param userID
     * @return
     * @throws java.sql.SQLException
     */
    List<TeamMember> listByUser(String userID) throws SQLException;

    void removeMember(int teamID, String userID) throws SQLException;
}
