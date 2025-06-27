package my.nexgenesports.dao.team;

import my.nexgenesports.model.JoinRequest;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public interface JoinRequestDao {

    /**
     * Create a new join-request
     *
     * @param jr
     * @return
     * @throws java.sql.SQLException
     */
    JoinRequest insert(JoinRequest jr) throws SQLException;

    /**
     * Accept or reject a request, recording when
     *
     * @param requestID
     * @param respondedAt
     * @param status
     * @throws java.sql.SQLException
     */
    void updateStatus(int requestID,
            String status,
            LocalDateTime respondedAt)
            throws SQLException;

    /**
     * Lookup any request by its PK
     *
     * @param requestID
     * @return
     * @throws java.sql.SQLException
     */
    JoinRequest findById(int requestID) throws SQLException;

    /**
     * Has this user already made one for that team?
     *
     * @param teamID
     * @param userID
     * @return
     * @throws java.sql.SQLException
     */
    JoinRequest findPendingByTeamAndUser(int teamID, String userID)
            throws SQLException;

    /**
     * All pending requests for leaders to review
     *
     * @param teamID
     * @return
     * @throws java.sql.SQLException
     */
    List<JoinRequest> listPendingByTeam(int teamID)
            throws SQLException;

    List<JoinRequest> listPendingByUser(String userID) 
            throws SQLException;
}
