// File: src/main/java/my/nexgenesports/dao/team/TeamMemberDao.java
package my.nexgenesports.dao.team;

import my.nexgenesports.model.TeamMember;
import java.sql.SQLException;
import java.util.List;

public interface TeamMemberDao {

    /**
     * Add a new membership record.
     *
     * @param m the TeamMember to insert
     * @throws SQLException if a database error occurs
     */
    void insert(TeamMember m) throws SQLException;

    /**
     * Update a member’s status (e.g. to “Declined”).
     *
     * @param teamID the team ID
     * @param userID the user ID
     * @param status new status value
     * @throws SQLException if a database error occurs
     */
    void updateStatus(int teamID, String userID, String status) throws SQLException;

    /**
     * Change a member’s role (and bump roleAssignedAt to now).
     *
     * @param teamID the team ID
     * @param userID the user ID
     * @param role   new role value
     * @throws SQLException if a database error occurs
     */
    void updateRole(int teamID, String userID, String role) throws SQLException;

    /**
     * Total number of Active members in this team (for capacity checks).
     *
     * @param teamID the team ID
     * @return count of active members
     * @throws SQLException if a database error occurs
     */
    int countActiveMembers(int teamID) throws SQLException;

    /**
     * Number of Active members in this team holding exactly the given role.
     *
     * @param teamID the team ID
     * @param role   the role name
     * @return count of active members with that role
     * @throws SQLException if a database error occurs
     */
    int countActiveRole(int teamID, String role) throws SQLException;

    /**
     * All membership records (any status/role) for a given team.
     *
     * @param teamID the team ID
     * @return list of TeamMember
     * @throws SQLException if a database error occurs
     */
    List<TeamMember> listByTeam(int teamID) throws SQLException;

    /**
     * All membership records (any status/role) for a given user.
     *
     * @param userID the user ID
     * @return list of TeamMember
     * @throws SQLException if a database error occurs
     */
    List<TeamMember> listByUser(String userID) throws SQLException;

    /**
     * Permanently remove a single member from a team.
     *
     * @param teamID the team ID
     * @param userID the user ID
     * @throws SQLException if a database error occurs
     */
    void removeMember(int teamID, String userID) throws SQLException;

    /**
     * Permanently remove _all_ members from a given team.
     *
     * @param teamID the team ID
     * @throws SQLException if a database error occurs
     */
    void removeAll(int teamID) throws SQLException;

    /**
     * Change the Team.leader column.
     *
     * @param teamID    the team ID
     * @param newLeader the user ID to set as leader
     * @throws SQLException if a database error occurs
     */
    void updateLeader(int teamID, String newLeader) throws SQLException;

    /**
     * Archive this membership row into archived_teammember.
     *
     * @param teamID the team ID
     * @param userID the user ID
     * @throws SQLException if a database error occurs
     */
    void archive(int teamID, String userID) throws SQLException;
}
