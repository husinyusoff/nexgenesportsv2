// src/main/java/my/nexgenesports/dao/programTournament/ProgramParticipantDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ProgramParticipant;

import java.sql.SQLException;
import java.util.List;

public interface ProgramParticipantDao {
    int countByProgId(String progID) throws SQLException;
    boolean exists(String progID, String userId) throws SQLException;
    void insert(ProgramParticipant p) throws SQLException;
    List<ProgramParticipant> listByProgId(String progID) throws SQLException;
}
