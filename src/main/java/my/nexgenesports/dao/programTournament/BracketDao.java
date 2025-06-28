// File: src/main/java/my/nexgenesports/dao/tournament/BracketDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.Bracket;
import java.sql.SQLException;
import java.util.List;

public interface BracketDao {

    Bracket insert(Bracket b) throws SQLException;
    Bracket findById(int bracketId) throws SQLException;
    List<Bracket> findByProg(String progId) throws SQLException;
    void delete(int bracketId) throws SQLException;
    void update(Bracket b) throws SQLException;
    void softDelete(int id) throws SQLException;
}
