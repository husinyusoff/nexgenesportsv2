package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.TournamentParticipant;
import java.sql.SQLException;
import java.util.List;

public interface TournamentParticipantDao {

    /**
     * Insert a new registration
     *
     * @param tp
     * @throws java.sql.SQLException
     */
    void insert(TournamentParticipant tp) throws SQLException;

    int insertPending(TournamentParticipant tp) throws SQLException;

    /**
     * @param id
     * @param status
     * @param reference
     * @throws java.sql.SQLException
     */
    void updatePaymentStatus(int id, String status, String reference) throws SQLException;

    boolean exists(int progId, String userId, Integer teamId) throws SQLException;

    long countByProgId(int progId) throws SQLException;

    /**
     * @param progId
     * @return
     * @throws java.sql.SQLException
     */
    List<TournamentParticipant> findByProgId(String progId) throws SQLException;

    /**
     * @param participantId
     * @throws java.sql.SQLException
     */
    void softDelete(long participantId) throws SQLException;
}
