package my.nexgenesports.service.programTournament;

import java.sql.SQLException;
import java.util.Objects;

import my.nexgenesports.dao.programTournament.TournamentParticipantDao;
import my.nexgenesports.dao.programTournament.TournamentParticipantDaoImpl;
import my.nexgenesports.model.TournamentParticipant;
import my.nexgenesports.service.general.ServiceException;

public class ParticipantService {

    private final TournamentParticipantDao tpDao = new TournamentParticipantDaoImpl();

    /**
     * Creates a PENDING registration row and returns its generated ID.
     *
     * @param progId  program/tournament ID
     * @param userId  the user to register
     * @param teamId  null for solo, else team ID
     * @param role    "MAIN" or "SUB"
     * @return the generated participant ID
     */
    public int createPending(int progId, String userId, Integer teamId, String role) {
        if (Objects.isNull(role)) {
            throw new IllegalArgumentException("Role must be MAIN or SUB");
        }
        TournamentParticipant tp = new TournamentParticipant();
        tp.setProgId(progId);
        tp.setUserId(userId);
        tp.setTeamId(teamId);
        tp.setRole(role);
        tp.setStatus("PENDING");
        tp.setPaymentReference(null);
        try {
            return tpDao.insertPending(tp);
        } catch (SQLException e) {
            throw new ServiceException("Failed to initialize registration", e);
        }
    }

    /**
     * Marks that registration was PAID or CANCELLED.
     */
    public void finalizeRegistration(int leaderPartId, boolean paid, String reference) {
        try {
            TournamentParticipant leader = tpDao.findById(leaderPartId);
            if (leader == null) {
                throw new IllegalArgumentException("No registration id=" + leaderPartId);
            }
            String newStatus = paid ? "PAID" : "CANCELLED";
            String refToSave = paid ? reference : null;
            tpDao.updatePaymentStatusForTeam(
                leader.getProgId(),
                leader.getTeamId(),
                newStatus,
                refToSave
            );
        } catch (SQLException e) {
            throw new ServiceException("Failed to finalize registration", e);
        }
    }
}
