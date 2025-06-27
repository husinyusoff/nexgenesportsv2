// src/main/java/my/nexgenesports/service/programTournament/ProgramTournamentService.java
package my.nexgenesports.service.programTournament;

import my.nexgenesports.dao.programTournament.ProgramParticipantDao;
import my.nexgenesports.dao.programTournament.ProgramParticipantDaoImpl;
import my.nexgenesports.dao.programTournament.ProgramTournamentDao;
import my.nexgenesports.dao.programTournament.ProgramTournamentDaoImpl;
import my.nexgenesports.model.ProgramParticipant;
import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.ProgramType;
import my.nexgenesports.model.TournamentStatus;
import my.nexgenesports.service.general.ServiceException;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class ProgramTournamentService {
    private final ProgramTournamentDao        dao         = new ProgramTournamentDaoImpl();
    private final ProgramTournamentSyncService syncSvc    = new ProgramTournamentSyncService();
    private final ProgramParticipantDao       partDao     = new ProgramParticipantDaoImpl();

    public ProgramTournament createProgram(ProgramTournament t)
            throws SQLException, ServiceException {
        t.setStatus(TournamentStatus.PENDING_APPROVAL);
        dao.insert(t);
        return dao.findById(t.getProgID());
    }

    public ProgramTournament findById(String progID)
            throws SQLException, ServiceException {
        ProgramTournament t = dao.findById(progID);
        if (t == null) {
            throw new ServiceException("Program not found: " + progID);
        }
        return t;
    }

    public void updateTournament(ProgramTournament t)
            throws SQLException, ServiceException {
        // you can add any business-rule checks here
        dao.update(t);
    }

    public void softDeleteTournament(String progID)
            throws SQLException, ServiceException {
        ProgramTournament t = dao.findById(progID);
        if (t == null) {
            throw new ServiceException("Program not found: " + progID);
        }
        // only allow delete in PENDING_APPROVAL
        if (t.getStatus() != TournamentStatus.PENDING_APPROVAL) {
            throw new ServiceException("Only PENDING_APPROVAL items can be deleted.");
        }
        dao.softDelete(progID);
        // also clean up sync & participants if needed...
    }

    public void approve(String progID)
            throws SQLException, ServiceException {
        ProgramTournament t = findById(progID);
        if (t.getStatus() != TournamentStatus.PENDING_APPROVAL) {
            throw new ServiceException("Only PENDING_APPROVAL items can be approved.");
        }
        t.setStatus(TournamentStatus.ACTIVE);
        dao.update(t);
        if (t.getProgramType() == ProgramType.TOURNAMENT) {
            syncSvc.createInChallonge(progID);
        }
    }

    public void cancel(String progID)
            throws SQLException, ServiceException {
        ProgramTournament t = findById(progID);
        if (t.getStatus() == TournamentStatus.COMPLETED) {
            throw new ServiceException("Cannot cancel a COMPLETED item.");
        }
        t.setStatus(TournamentStatus.CANCELLED);
        dao.update(t);
        if (t.getProgramType() == ProgramType.TOURNAMENT) {
            syncSvc.cancelInChallonge(progID);
        }
    }

    public List<ProgramTournament> listByCreator(String creatorId) throws SQLException {
        return dao.listByCreator(creatorId);
    }

    public List<ProgramTournament> listPendingApproval() throws SQLException {
        return dao.listByStatus(TournamentStatus.PENDING_APPROVAL.name());
    }

    public List<ProgramTournament> listActive() throws SQLException {
        return dao.listByStatus(TournamentStatus.ACTIVE.name());
    }

    /**
     * Join a program/tournament.For SOLO, just one record; for TEAM you must
 handle team-selection yourself (not implemented here).
     * @param progID
     * @param userId
     * @throws java.sql.SQLException
     */
    public void joinTournament(String progID, String userId)
            throws SQLException, ServiceException {
        ProgramTournament t = findById(progID);

        if (t.getStatus() != TournamentStatus.ACTIVE) {
            throw new ServiceException("Can only join ACTIVE items.");
        }

        // prevent double-join
        if (partDao.exists(progID, userId)) {
            throw new ServiceException("User already joined.");
        }

        // capacity check
        int count = partDao.countByProgId(progID);
        if (count >= t.getCapacity()) {
            throw new ServiceException("This program is full.");
        }

        // all good, create participant record
        ProgramParticipant p = new ProgramParticipant();
        p.setProgID(progID);
        p.setUserId(userId);
        p.setTeamId(null);
        p.setJoinedAt(LocalDateTime.now());
        partDao.insert(p);
    }
    
    // in ProgramTournamentService.java
/**
 * Lookup by arbitrary status string.
     * @param status
     * @return 
     * @throws java.sql.SQLException
 */
public List<ProgramTournament> listByStatus(String status) throws SQLException {
    return dao.listByStatus(status);
}
}
