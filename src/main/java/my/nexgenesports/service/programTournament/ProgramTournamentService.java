package my.nexgenesports.service.programTournament;

import java.io.IOException;
import java.sql.SQLException;
import my.nexgenesports.dao.programTournament.*;
import my.nexgenesports.model.*;
import my.nexgenesports.service.general.ServiceException;

import java.util.List;

public class ProgramTournamentService {
    private final ProgramTournamentDao ptDao =
            new ProgramTournamentDaoImpl();
    private final TournamentParticipantDao tpDao =
            new TournamentParticipantDaoImpl();
    private final BracketDao bracketDao =
            new BracketDaoImpl();
    private final ChallongeTournamentDao challongeDao =
            new ChallongeTournamentDaoImpl();
    private final GameDao gameDao =
            new GameDaoImpl();
    private final MeritLevelDao meritDao =
            new MeritLevelDaoImpl();

    /** CREATE
     * @param pt */
    public void createProgramTournament(ProgramTournament pt) {
        try {
            ptDao.insert(pt);
        } catch (Exception e) {
            throw new ServiceException("Failed to create", e);
        }
    }

    /** LIST PUBLIC (approved/open)
     * @return  */
    public List<ProgramTournament> listPublicProgramsAndTournaments() {
        try {
            return ptDao.findByStatusIn(List.of("OPEN","ACTIVE"));
        } catch (Exception e) {
            throw new ServiceException("Failed to list public", e);
        }
    }

    /** FIND DETAIL
     * @param progId
     * @return  */
    public ProgramTournament findById(String progId) {
        try {
            return ptDao.findById(progId);
        } catch (Exception e) {
            throw new ServiceException("Not found: "+progId, e);
        }
    }

    /** UPDATE
     * @param pt */
    public void updateProgramTournament(ProgramTournament pt) {
        try {
            ptDao.update(pt);
        } catch (Exception e) {
            throw new ServiceException("Failed to update", e);
        }
    }

    /** SOFT DELETE
     * @param progId */
    public void deleteProgramTournament(String progId) {
        try {
            ptDao.softDelete(progId);
        } catch (Exception e) {
            throw new ServiceException("Failed to delete", e);
        }
    }

    /** APPROVE → OPEN
     * @param progId
     * @param by */
    public void approveProgramTournament(String progId, String by) {
        try {
            ptDao.updateStatus(progId, "OPEN");
        } catch (Exception e) {
            throw new ServiceException("Failed to approve", e);
        }
    }

    /** REGISTER PARTICIPANT
     * @param progId
     * @param userId
     * @param teamId */
    public void registerParticipant(String progId, String userId, String teamId) {
        try {
            TournamentParticipant tp = new TournamentParticipant();
            tp.setProgId(progId);
            tp.setUserId(userId);
            tp.setTeamId(teamId);
            tpDao.insert(tp);
        } catch (SQLException e) {
            throw new ServiceException("Failed to register", e);
        }
    }

    /** LIST PARTICIPANTS
     * @param progId
     * @return  */
    public List<TournamentParticipant> listParticipants(String progId) {
        try {
            return tpDao.findByProgId(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list participants", e);
        }
    }

    /** LIST BRACKETS
     * @param progId
     * @return  */
    public List<Bracket> listBrackets(String progId) {
        try {
            return bracketDao.findByProg(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list brackets", e);
        }
    }

    /** GET CHALLONGE RECORD
     * @param progId
     * @return  */
    public ChallongeTournament getChallonge(String progId) {
        try {
            return challongeDao.findByProg(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to load bracket sync info", e);
        }
    }

    /** SYNC WITH CHALLONGE (stubbed)
     * @param progId */
    public void syncWithChallonge(String progId) {
        try {
            ProgramTournament pt = ptDao.findById(progId);
            ChallongeClient client = new ChallongeClient();
            ChallongeTournament out;
            ChallongeTournament existing = challongeDao.findByProg(progId);
            if (existing == null) {
                out = client.createTournament(pt);
                challongeDao.insert(out);
            } else {
                out = client.syncTournament(existing);
                challongeDao.update(out);
            }
        } catch (IOException | SQLException e) {
            throw new ServiceException("Challonge sync failed", e);
        }
    }

    /** FOR DROPDOWNS
     * @return  */
    public List<Game> listAllGames() {
        try { return gameDao.listAll(); }
        catch(SQLException e){ throw new ServiceException("Failed games",e); }
    }

    public List<MeritLevel> listAllMeritLevels() {
        try { return meritDao.findAll(); }
        catch(SQLException e){ throw new ServiceException("Failed merits",e); }
    }
}
