// src/main/java/my/nexgenesports/dao/programTournament/ProgramTournamentDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramTournament;
import java.sql.SQLException;
import java.util.List;

public interface ProgramTournamentDao {
    /** Insert a new tournament record
     * @param t
     * @throws java.sql.SQLException */
    void insert(ProgramTournament t) throws SQLException;

    /** Lookup a tournament by its primary key
     * @param progID
     * @return
     * @throws java.sql.SQLException  */
    ProgramTournament findById(String progID) throws SQLException;

    /** List all tournaments created by a given user
     * @param creatorId
     * @return 
     * @throws java.sql.SQLException */
    List<ProgramTournament> listByCreator(String creatorId) throws SQLException;

    /** List all tournaments in a given status (e.g."ACTIVE")
     * @param status
     * @return 
     * @throws java.sql.SQLException */
    List<ProgramTournament> listByStatus(String status) throws SQLException;

    /** Update an existing tournament (must match on progID and version for optimistic‐lock)
     * @param t
     * @throws java.sql.SQLException */
    void update(ProgramTournament t) throws SQLException;

    /** Soft‐delete (set deleted_flag)
     * @param progID
     * @throws java.sql.SQLException */
    void softDelete(String progID) throws SQLException;
}
