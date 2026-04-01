// src/main/java/my/nexgenesports/dao/programTournament/ChallongeTournamentDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.ChallongeTournament;
import java.sql.SQLException;

public interface ChallongeTournamentDao {
    void insertOrUpdate(ChallongeTournament ct) throws SQLException;
    ChallongeTournament findByProgId(int progId) throws SQLException;
    void deleteByProgId(int progId) throws SQLException;
}
