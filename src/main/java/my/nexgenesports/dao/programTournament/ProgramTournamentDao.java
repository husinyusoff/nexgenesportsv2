// ProgramTournamentDao.java
package my.nexgenesports.dao.programTournament;

import java.sql.SQLException;
import my.nexgenesports.model.ProgramTournament;
import java.util.List;
import my.nexgenesports.model.TournamentParticipant;

public interface ProgramTournamentDao {
    void insert(ProgramTournament pt);
    ProgramTournament findById(String progId);
    List<ProgramTournament> findByStatusIn(List<String> statuses);
    List<ProgramTournament> findAll();
    void update(ProgramTournament pt);
    void softDelete(String progId);
    void updateStatus(String progId, String status);
    List<TournamentParticipant> listParticipants(String progId) throws SQLException;
    public List<String> findAllScopes() throws SQLException;
}
