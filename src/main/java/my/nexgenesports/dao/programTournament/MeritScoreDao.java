// File: src/main/java/my/nexgenesports/dao/tournament/MeritScoreDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.MeritScore;
import java.sql.SQLException;
import java.util.List;

public interface MeritScoreDao {
    MeritScore insert(MeritScore ms) throws SQLException;
    List<MeritScore> findByMeritId(int meritId) throws SQLException;
    void update(MeritScore ms) throws SQLException;
    void delete(int meritId, String rank) throws SQLException;
}
