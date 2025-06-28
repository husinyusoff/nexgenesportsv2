// File: src/main/java/my/nexgenesports/dao/tournament/BracketRefereeDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.BracketReferee;
import java.sql.SQLException;
import java.util.List;

public interface BracketRefereeDao {
    BracketReferee insert(BracketReferee br) throws SQLException;
    List<BracketReferee> findByBracket(int bracketId) throws SQLException;
    void delete(int id) throws SQLException;
}
