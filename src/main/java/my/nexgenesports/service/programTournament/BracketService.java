package my.nexgenesports.service.programTournament;

import java.sql.SQLException;
import my.nexgenesports.dao.programTournament.*;
import my.nexgenesports.model.*;
import my.nexgenesports.service.general.ServiceException;

import java.util.List;

public class BracketService {
    private final BracketDao bracketDao   = new BracketDaoImpl();
    private final BracketMatchDao matchDao= new BracketMatchDaoImpl();
    private final ProgramTournamentDao ptDao = new ProgramTournamentDaoImpl();

    /** CREATE & SEED MATCHES
     * @param b */
    public void createBracket(Bracket b) {
        try {
            bracketDao.insert(b);

            // seed initial matches
            var participants = ptDao.listParticipants(b.getProgId());
            var matches = BracketUtils.seed(participants);
            for (BracketMatch m : matches) {
                m.setBracketId(b.getBracketId());
                matchDao.insert(m);
            }
        } catch (SQLException e) {
            throw new ServiceException("Failed to create bracket", e);
        }
    }

    /** FIND & LIST
     * @param id
     * @return  */
    public Bracket findById(int id) {
        try { return bracketDao.findById(id); }
        catch (SQLException e) {
            throw new ServiceException("Bracket not found", e);
        }
    }

    public List<BracketMatch> listMatches(int bracketId) {
        try { return matchDao.findByBracket(bracketId); }
        catch (SQLException e) {
            throw new ServiceException("Failed to list matches", e);
        }
    }

    /** UPDATE META
     * @param b */
    public void updateBracket(Bracket b) {
        try { bracketDao.update(b); }
        catch(SQLException e) {
            throw new ServiceException("Failed to update bracket", e);
        }
    }

    /** SOFT DELETE
     * @param bracketId */
    public void deleteBracket(int bracketId) {
        try { bracketDao.softDelete(bracketId); }
        catch(SQLException e) {
            throw new ServiceException("Failed to delete bracket", e);
        }
    }

    /** RECORD SCORE & ADVANCE
     * @param matchId
     * @param s1
     * @param s2 */
    public void recordMatchScore(int matchId, int s1, int s2) {
        try {
            var m = matchDao.findById(matchId);
            m.setScore1(s1);
            m.setScore2(s2);
            m.setWinner(s1> s2 ? m.getParticipant1() : m.getParticipant2());
            ((BracketMatchDaoImpl)matchDao).updateScore(m);


            // advance winner into next round
            BracketUtils.advance(m, matchDao);
        } catch(SQLException e){
            throw new ServiceException("Failed to record score", e);
        }
    }
}
