// File: src/main/java/my/nexgenesports/dao/tournament/MeritLevelDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.MeritLevel;
import java.sql.SQLException;
import java.util.List;

public interface MeritLevelDao {
    MeritLevel insert(MeritLevel ml) throws SQLException;
    MeritLevel findById(int meritId) throws SQLException;
    List<MeritLevel> findAll() throws SQLException;
    MeritLevel findByCategoryAndScope(String category, String scope) throws SQLException;
    void update(MeritLevel ml) throws SQLException;
    void delete(int meritId) throws SQLException;
}
