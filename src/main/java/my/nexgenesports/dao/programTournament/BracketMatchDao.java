// File: src/main/java/my/nexgenesports/dao/tournament/BracketMatchDao.java
package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.BracketMatch;
import java.sql.SQLException;
import java.util.List;

public interface BracketMatchDao {

    BracketMatch insert(BracketMatch bm) throws SQLException;
    List<BracketMatch> findByBracket(int bracketId) throws SQLException;
    BracketMatch findById(int matchId) throws SQLException;
    void updateScore(int matchId, int score1, int score2, Long winnerId) throws SQLException;
    void delete(int matchId) throws SQLException;
    BracketMatch findByBracketAndRoundAndMatch(int bracketId,int round,int matchNumber) throws SQLException;
    void updateParticipants(BracketMatch m) throws SQLException;
}
