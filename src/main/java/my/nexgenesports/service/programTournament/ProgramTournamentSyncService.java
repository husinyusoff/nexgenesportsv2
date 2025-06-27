// src/main/java/my/nexgenesports/service/programTournament/ProgramTournamentSyncService.java
package my.nexgenesports.service.programTournament;

import my.nexgenesports.client.ChallongeClient;
import my.nexgenesports.dao.programTournament.ProgramTournamentDao;
import my.nexgenesports.dao.programTournament.ProgramTournamentDaoImpl;
import my.nexgenesports.dao.programTournament.ProgramTournamentSyncDao;
import my.nexgenesports.dao.programTournament.ProgramTournamentSyncDaoImpl;
import my.nexgenesports.model.ChallongeState;
import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.ProgramTournamentSync;
import my.nexgenesports.service.general.ServiceException;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProgramTournamentSyncService {
    private static final Logger LOG = Logger.getLogger(ProgramTournamentSyncService.class.getName());

    private final ProgramTournamentDao        tournamentDao = new ProgramTournamentDaoImpl();
    private final ProgramTournamentSyncDao    syncDao       = new ProgramTournamentSyncDaoImpl();
    private final ChallongeClient             client        = new ChallongeClient();

public void createInChallonge(String progID) throws ServiceException {
  try {
    // load core to get display name
    ProgramTournament t = tournamentDao.findById(progID);
    if (t == null) throw new ServiceException("No such tournament: " + progID);

    // pass both progID & friendly name to client
    ProgramTournamentSync sync =
      client.createTournament(progID, t.getProgramName());
    syncDao.insertOrUpdate(sync);

  } catch (IOException|InterruptedException e) {
    throw new ServiceException("Challonge API error creating tournament", e);
  } catch (SQLException e) {
    throw new ServiceException("DB error during sync insert", e);
  }
}

public void cancelInChallonge(String progID) throws ServiceException {
  try {
    ProgramTournamentSync existing = syncDao.findByProgId(progID)
      .orElseThrow(() -> new ServiceException("No sync record for " + progID));

    client.cancelTournament(existing.getChallongeTournamentId());

    existing.setChallongeState(ChallongeState.cancelled);
    existing.setChallongeLastSyncAt(LocalDateTime.now());
    syncDao.insertOrUpdate(existing);

  } catch (IOException e) {
    throw new ServiceException("Challonge API error cancelling tournament", e);
  } catch (InterruptedException e) {
    Thread.currentThread().interrupt();
    throw new ServiceException("Interrupted cancelling tournament", e);
  } catch (SQLException e) {
    throw new ServiceException("DB error during cancel sync", e);
  }
}

public void syncState(String progID) throws ServiceException {
  try {
    ProgramTournamentSync local = syncDao.findByProgId(progID)
      .orElseThrow(() -> new ServiceException("No sync record for " + progID));

    // pass progID + challongeId
    ProgramTournamentSync remote =
      client.fetchTournament(progID, local.getChallongeTournamentId());

    // ensure FK
    remote.setProgID(progID);
    syncDao.insertOrUpdate(remote);

  } catch (IOException e) {
    throw new ServiceException("Challonge API error during state sync", e);
  } catch (InterruptedException e) {
    Thread.currentThread().interrupt();
    throw new ServiceException("Interrupted during state sync", e);
  } catch (SQLException e) {
    throw new ServiceException("DB error during state sync", e);
  }
}

    
      /**
   * Pass-through to DAO so JSP/servlet can look up the latest sync row.
     * @param progID
     * @return 
   */
  public Optional<ProgramTournamentSync> findByProgId(String progID) throws ServiceException {
    try {
      return syncDao.findByProgId(progID);
    } catch (SQLException e) {
      throw new ServiceException("DB error fetching sync record for " + progID, e);
    }
  }

}
