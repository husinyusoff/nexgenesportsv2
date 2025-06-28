package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ChallongeTournament;
import java.sql.SQLException;

public interface ChallongeTournamentDao {
    /** load by program‐ID
     * @param progId
     * @return 
     * @throws java.sql.SQLException */
    ChallongeTournament findByProg(String progId) throws SQLException;

    /** insert a new sync record
     * @param ct
     * @throws java.sql.SQLException */
    void insert(ChallongeTournament ct) throws SQLException;

    /** delete the sync record
     * @param progId
     * @throws java.sql.SQLException */
    void delete(String progId) throws SQLException;

    /** update an existing sync record
     * @param ct
     * @throws java.sql.SQLException */
    void update(ChallongeTournament ct) throws SQLException;
}
