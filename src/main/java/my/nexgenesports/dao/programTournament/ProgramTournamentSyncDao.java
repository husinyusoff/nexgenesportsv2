// src/main/java/my/nexgenesports/dao/programTournament/ProgramTournamentSyncDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramTournamentSync;
import java.sql.SQLException;
import java.util.Optional;

public interface ProgramTournamentSyncDao {

    /**
     * Inserts a new sync record; fails if progID already exists.
     * @param sync
     * @throws java.sql.SQLException
     */
    void insert(ProgramTournamentSync sync) throws SQLException;

    /**
     * Updates an existing sync record.
     * @param sync
     * @throws java.sql.SQLException
     */
    void update(ProgramTournamentSync sync) throws SQLException;

    /**
     * Inserts or updates in one call.
     * @param sync
     */
    void upsert(ProgramTournamentSync sync) throws SQLException;

    /**
     * Alias for upsert(...).
     */
    default void insertOrUpdate(ProgramTournamentSync sync) throws SQLException {
        upsert(sync);
    }

    /**
     * Lookup by progID.
     */
    Optional<ProgramTournamentSync> findByProgId(String progID) throws SQLException;

    /**
     * Deletes the sync record (usually when tournament is deleted).
     */
    void deleteByProgId(String progID) throws SQLException;
}
