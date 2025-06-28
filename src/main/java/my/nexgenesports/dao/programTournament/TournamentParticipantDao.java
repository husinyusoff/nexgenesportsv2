package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.TournamentParticipant;
import java.sql.SQLException;
import java.util.List;

public interface TournamentParticipantDao {
    /** Insert a new registration
     * @param tp
     * @throws java.sql.SQLException */
    void insert(TournamentParticipant tp) throws SQLException;

    /** List all participants in a program
     * @param progId
     * @return 
     * @throws java.sql.SQLException */
    List<TournamentParticipant> findByProgId(String progId) throws SQLException;

    /** (Optional) soft-delete a registration
     * @param participantId
     * @throws java.sql.SQLException */
    void softDelete(long participantId) throws SQLException;
}
