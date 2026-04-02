package my.nexgenesports.service.programTournament;

import java.sql.SQLException;
import java.util.List;

import my.nexgenesports.dao.programTournament.BracketDao;
import my.nexgenesports.dao.programTournament.BracketDaoImpl;
import my.nexgenesports.dao.programTournament.ChallongeTournamentDao;
import my.nexgenesports.dao.programTournament.ChallongeTournamentDaoImpl;
import my.nexgenesports.dao.programTournament.GameDao;
import my.nexgenesports.dao.programTournament.MeritLevelDao;
import my.nexgenesports.dao.programTournament.MeritLevelDaoImpl;
import my.nexgenesports.dao.programTournament.ProgramTournamentDao;
import my.nexgenesports.dao.programTournament.ProgramTournamentDaoImpl;
import my.nexgenesports.dao.programTournament.TournamentParticipantDao;
import my.nexgenesports.dao.programTournament.TournamentParticipantDaoImpl;
import my.nexgenesports.model.Bracket;
import my.nexgenesports.model.ChallongeTournament;
import my.nexgenesports.model.Game;
import my.nexgenesports.model.MeritLevel;
import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.TournamentParticipant;
import my.nexgenesports.service.general.ServiceException;

public class ProgramTournamentService {

    private final ProgramTournamentDao ptDao
            = new ProgramTournamentDaoImpl();
    private final TournamentParticipantDao tpDao
            = new TournamentParticipantDaoImpl();
    private final BracketDao bracketDao
            = new BracketDaoImpl();
    private final ChallongeTournamentDao challongeDao
            = new ChallongeTournamentDaoImpl();
    private final GameDao gameDao
            = new GameDao();
    private final MeritLevelDao meritDao
            = new MeritLevelDaoImpl();
    private final ChallongeService challongeService = new ChallongeService();

    // --- PROGRAM / TOURNAMENT CRUD + STATUS --------------------------------
    public ProgramTournament getProgramById(int progId) {
        return ptDao.findById(progId);
    }

    public void createProgramTournament(ProgramTournament pt) {
        ptDao.insert(pt);
    }

    public void updateProgramTournament(ProgramTournament pt) {
        ptDao.update(pt);
    }

    public void deleteProgramTournament(int progId) {
        ptDao.softDelete(progId);
    }

    public void approveProgramTournament(int progId) {
        ptDao.updateStatus(progId, "OPEN");
    }

    public void rejectProgramTournament(int progId) {
        ptDao.updateStatus(progId, "REJECTED");
    }

    public void changeStatus(int progId, String newStatus) {
        ProgramTournament pt = getProgramById(progId);
        String old = pt.getStatus();
        if (!List.of("APPROVED", "OPEN", "CLOSED").contains(old)
                || !List.of("OPEN", "CLOSED").contains(newStatus)) {
            throw new ServiceException("Invalid status transition: " + old + "→" + newStatus);
        }
        ptDao.updateStatus(progId, newStatus);
    }

    // --- PARTICIPANTS -------------------------------------------------------
    public void registerParticipant(int progId, String userId, Integer teamId) {
        try {
            TournamentParticipant tp = new TournamentParticipant();
            tp.setProgId(progId);
            tp.setUserId(userId);
            tp.setTeamId(teamId);
            tp.setRole("MAIN");
            tp.setStatus("PAID");
            tpDao.insert(tp);
        } catch (SQLException e) {
            throw new ServiceException("Failed to register participant", e);
        }
    }

    public List<TournamentParticipant> listParticipants(int progId) {
        try {
            return tpDao.findByProgId(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list participants", e);
        }
    }

    // --- BRACKETS -----------------------------------------------------------
    public List<Bracket> listBrackets(int progId) {
        try {
            return bracketDao.findByProg(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list brackets", e);
        }
    }

    // fetch our local Challonge mapping record
    public ChallongeTournament getChallonge(int progId) {
        try {
            return challongeDao.findByProgId(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to load Challonge mapping", e);
        }
    }

    /**
     * Creates & seeds a brand-new Challonge bracket, persists the mapping and
     * returns the new ChallongeTournament.
     */
    public ChallongeTournament provisionChallonge(int progId) {
        return challongeService.provision(progId);
    }

    /**
     * Updates name and description on Challonge (and in our metadata).
     * @param progId
     * @param name
     * @param description
     */
    public void updateChallonge(int progId, String name, String description) {
        challongeService.update(progId, name, description);
    }

        public void syncWithChallonge(int progId) {
        try {
            // 1) look up existing mapping
            ChallongeTournament existing = challongeDao.findByProgId(progId);
            ChallongeService client       = new ChallongeService();
            ChallongeTournament updated;

            if (existing == null) {
                // no mapping yet → provision brand-new
                updated = client.provision(progId);
            } else {
                // already exists → just refresh sync
                updated = client.syncTournament(existing);
            }

            // 2) persist back into our table
            challongeDao.insertOrUpdate(updated);

        } catch (SQLException e) {
            throw new ServiceException("Challonge sync failed", e);
        }
    }
        
    /**
     * Deletes the bracket remotely in Challonge and locally in our DB.
     * @param progId
     */
    public void deleteChallonge(int progId) {
        challongeService.delete(progId);
    }

    // --- PROGRAM/TOURNAMENT LISTING ----------------------------------------
    public List<ProgramTournament> listPublicProgramsAndTournaments() {
        return ptDao.findByStatusIn(List.of("OPEN", "ACTIVE"));
    }

    public List<ProgramTournament> listAllProgramsAndTournaments() {
        return ptDao.findByStatusIn(List.of(
                "PENDING_APPROVAL", "APPROVED", "OPEN", "ACTIVE", "CLOSED", "COMPLETED", "CANCELLED", "REJECTED"
        ));
    }

    public List<ProgramTournament> listAllPrograms() {
        return ptDao.findAll();
    }

    // --- DROPDOWNS ---------------------------------------------------------
    public List<Game> listAllGames() {
        try {
            return gameDao.listAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed to list games", e);
        }
    }

    public List<MeritLevel> listAllMeritLevels() {
        try {
            return meritDao.findAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed to list merit levels", e);
        }
    }

    public Integer resolveMeritId(String programType, String scope) {
        String category = "PROGRAM".equalsIgnoreCase(programType) ? "Program" : "Tournament";
        try {
            MeritLevel ml = meritDao.findByCategoryAndScope(category, scope);
            return ml != null ? ml.getMeritId() : null;
        } catch (SQLException e) {
            throw new ServiceException("Failed to resolve merit ID", e);
        }
    }

    // --- TEAM SIZE ---------------------------------------------------------
    public Integer getMinTeamMember(int progId) {
        return getProgramById(progId).getMinTeamMember();
    }

    public Integer getMaxTeamMember(int progId) {
        return getProgramById(progId).getMaxTeamMember();
    }
}
