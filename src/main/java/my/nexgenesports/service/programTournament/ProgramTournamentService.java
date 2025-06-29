package my.nexgenesports.service.programTournament;

import java.io.IOException;
import java.sql.SQLException;
import my.nexgenesports.dao.programTournament.*;
import my.nexgenesports.model.*;
import my.nexgenesports.service.general.ServiceException;

import java.util.List;

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
            = new GameDaoImpl();
    private final MeritLevelDao meritDao
            = new MeritLevelDaoImpl();

    /**
     * CREATE
     *
     * @param pt
     */
    public void createProgramTournament(ProgramTournament pt) {
        try {
            ptDao.insert(pt);
        } catch (Exception e) {
            throw new ServiceException("Failed to create", e);
        }
    }

    /**
     * LIST PUBLIC (approved/open)
     *
     * @return
     */
    public List<ProgramTournament> listPublicProgramsAndTournaments() {
        try {
            return ptDao.findByStatusIn(List.of("OPEN", "ACTIVE"));
        } catch (Exception e) {
            throw new ServiceException("Failed to list public", e);
        }
    }

    /**
     * FIND DETAIL
     *
     * @param progId
     * @return
     */
    public ProgramTournament findById(String progId) {
        try {
            return ptDao.findById(progId);
        } catch (Exception e) {
            throw new ServiceException("Not found: " + progId, e);
        }
    }

    /**
     * UPDATE
     *
     * @param pt
     */
    public void updateProgramTournament(ProgramTournament pt) {
        try {
            ptDao.update(pt);
        } catch (Exception e) {
            throw new ServiceException("Failed to update", e);
        }
    }

    /**
     * SOFT DELETE
     *
     * @param progId
     */
    public void deleteProgramTournament(String progId) {
        try {
            ptDao.softDelete(progId);
        } catch (Exception e) {
            throw new ServiceException("Failed to delete", e);
        }
    }

    /**
     * APPROVE → OPEN
     *
     * @param progId
     * @param by
     */
    public void approveProgramTournament(String progId, String by) {
        try {
            ptDao.updateStatus(progId, "OPEN");
        } catch (Exception e) {
            throw new ServiceException("Failed to approve", e);
        }
    }

    /**
     * REGISTER PARTICIPANT
     *
     * @param progId
     * @param userId
     * @param teamId
     */
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

    /**
     * LIST PARTICIPANTS
     *
     * @param progId
     * @return
     */
    public List<TournamentParticipant> listParticipants(String progId) {
        try {
            return tpDao.findByProgId(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list participants", e);
        }
    }

    /**
     * LIST BRACKETS
     *
     * @param progId
     * @return
     */
    public List<Bracket> listBrackets(String progId) {
        try {
            return bracketDao.findByProg(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list brackets", e);
        }
    }

    /**
     * GET CHALLONGE RECORD
     *
     * @param progId
     * @return
     */
    public ChallongeTournament getChallonge(String progId) {
        try {
            return challongeDao.findByProg(progId);
        } catch (SQLException e) {
            throw new ServiceException("Failed to load bracket sync info", e);
        }
    }

    /**
     * SYNC WITH CHALLONGE (stubbed)
     *
     * @param progId
     */
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

    /**
     * FOR DROPDOWNS
     *
     * @return
     */
    public List<Game> listAllGames() {
        try {
            return gameDao.listAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed games", e);
        }
    }

    public List<MeritLevel> listAllMeritLevels() {
        try {
            return meritDao.findAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed merits", e);
        }
    }

    public Integer resolveMeritId(String programType, String scope) {
        String category = "PROGRAM".equalsIgnoreCase(programType)
                ? "Program" : "Tournament";
        try {
            MeritLevel ml = meritDao.findByCategoryAndScope(category, scope);
            return ml != null ? ml.getMeritId() : null;
        } catch (SQLException e) {
            throw new ServiceException("Failed merits", e);
        }
    }

    /**
     * LIST ALL (any status)
     *
     * @return
     */
    public List<ProgramTournament> listAllProgramsAndTournaments() {
        try {
            return ptDao.findByStatusIn(List.of(
                    "PENDING_APPROVAL",
                    "APPROVED",
                    "OPEN",
                    "ACTIVE",
                    "CLOSED",
                    "COMPLETED",
                    "CANCELLED",
                    "REJECTED"
            ));
        } catch (Exception e) {
            throw new ServiceException("Failed to list all", e);
        }
    }

    public List<ProgramTournament> listAllPrograms() {
        try {
            return ptDao.findAll();
        } catch (Exception e) {
            throw new ServiceException("Failed to list programs", e);
        }
    }

    /**
     * Approve a pending tournament
     *
     * @param progId
     */
    public void approveTournament(int progId) {
        ProgramTournament pt = ptDao.findById(String.valueOf(progId));
        if (pt == null) {
            throw new ServiceException("Not found: " + progId);
        }
        if (!ProgramTournament.STATUS_PENDING.equals(pt.getStatus())) {
            throw new ServiceException("Can only approve when status is PENDING_APPROVAL");
        }
        ptDao.updateStatus(String.valueOf(progId), ProgramTournament.STATUS_APPROVED);
    }

    /**
     * Reject a pending tournament
     *
     * @param progId
     */
    public void rejectTournament(int progId) {
        ProgramTournament pt = ptDao.findById(String.valueOf(progId));
        if (pt == null) {
            throw new ServiceException("Not found: " + progId);
        }
        if (!ProgramTournament.STATUS_PENDING.equals(pt.getStatus())) {
            throw new ServiceException("Can only reject when status is PENDING_APPROVAL");
        }
        ptDao.updateStatus(String.valueOf(progId), ProgramTournament.STATUS_REJECTED);
    }

    public void changeStatus(String progId, String newStatus) {
        ProgramTournament pt = ptDao.findById(progId);
        if (pt == null) {
            throw new ServiceException("Not found: " + progId);
        }
        String old = pt.getStatus();
        // only allow transitions APPROVED→{OPEN,CLOSED} or OPEN↔CLOSED
        if (!List.of("APPROVED", "OPEN", "CLOSED").contains(old)
                || !List.of("OPEN", "CLOSED").contains(newStatus)) {
            throw new ServiceException("Invalid status change");
        }
        ptDao.updateStatus(progId, newStatus);
    }

}
