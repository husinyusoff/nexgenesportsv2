package my.nexgenesports.service.programTournament;

import java.sql.SQLException;
import my.nexgenesports.model.TournamentParticipant;
import my.nexgenesports.dao.programTournament.BracketMatchDao;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import my.nexgenesports.model.BracketMatch;

public class BracketUtils {

    /**
     * Seed first‐round matches: pair participants in list order.If odd count, last one gets a “bye” (paired with null).
     * @param parts
     * @return 
     */
    public static List<BracketMatch> seed(List<TournamentParticipant> parts) {
        List<BracketMatch> matches = new ArrayList<>();
        int idx = 1;
        for (int i = 0; i < parts.size(); i += 2) {
            TournamentParticipant p1 = parts.get(i);
            TournamentParticipant p2 = (i+1 < parts.size() ? parts.get(i+1) : null);
            BracketMatch m = new BracketMatch();
            m.setRound(1);
            m.setMatchNumber(idx++);
            m.setParticipant1(p1.getId());
            m.setParticipant2(p2 != null ? p2.getId() : null);
            matches.add(m);
        }
        return matches;
    }

    /**
     * Advance the winner of a completed match into the next round.Next match's matchNumber = ceil(current.matchNumber/2).
     * @param completed
     * @param dao
     */
    public static void advance(BracketMatch completed, BracketMatchDao dao) {
        int nextRound = completed.getRound() + 1;
        int nextMatchNum = (completed.getMatchNumber() + 1) / 2;

        // try loading the next‐round match
        BracketMatch next = null;
        try {
            next = dao.findByBracketAndRoundAndMatch(
                    completed.getBracketId(),
                    nextRound,
                    nextMatchNum
            );
        } catch (SQLException ex) {
            Logger.getLogger(BracketUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (next == null) {
            // create it if missing
            next = new BracketMatch();
            next.setBracketId(completed.getBracketId());
            next.setRound(nextRound);
            next.setMatchNumber(nextMatchNum);
            // assign winner into slot #1 or #2
            if (completed.getMatchNumber() % 2 == 1) {
                next.setParticipant1(completed.getWinner());
            } else {
                next.setParticipant2(completed.getWinner());
            }
            try {
                dao.insert(next);
            } catch (SQLException ex) {
                Logger.getLogger(BracketUtils.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            // update existing slot
            if (completed.getMatchNumber() % 2 == 1) {
                next.setParticipant1(completed.getWinner());
            } else {
                next.setParticipant2(completed.getWinner());
            }
            try {
                dao.updateParticipants(next);
            } catch (SQLException ex) {
                Logger.getLogger(BracketUtils.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
