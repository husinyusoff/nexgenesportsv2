// src/main/java/my/nexgenesports/service/programTournament/ChallongeService.java
package my.nexgenesports.service.programTournament;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import my.nexgenesports.dao.programTournament.*;
import my.nexgenesports.model.*;
import my.nexgenesports.service.general.ServiceException;

import java.io.IOException;
import java.net.URI;
import java.net.http.*;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class ChallongeService {

    private static final String API_BASE = "https://api.challonge.com/v1";
    private static final String API_KEY = "WKSIQHV1XiHk7WTUeOf5wHpbBv1qv5yAsm7qLitp";

    private final ChallongeTournamentDao ctDao = new ChallongeTournamentDaoImpl();
    private final ProgramTournamentDaoImpl ptDao = new ProgramTournamentDaoImpl();
    private final TournamentParticipantDao tpDao = new TournamentParticipantDaoImpl();
    private final HttpClient http = HttpClient.newHttpClient();
    private static final ObjectMapper M = new ObjectMapper();

    /**
     * Create (provision) and seed a Challonge bracket.
     *
     * @param progId
     * @return
     */
    public ChallongeTournament provision(int progId) {
        try {
            ProgramTournament prog = ptDao.findById(progId);
            if (prog == null) {
                throw new ServiceException("Program/Tournament not found: " + progId);
            }

            // 1) Build a slug that Challonge will accept (only letters, numbers, underscores)
            String slug = prog.getProgramName()
                    .replaceAll("[^A-Za-z0-9]", "_")
                    .replaceAll("_+", "_")
                    .toLowerCase()
                    + "_" + progId;

            // 2) Map your enum to Challonge's exact tournament_type strings
            String type;
            type = switch (prog.getBracketFormat()) {
                case "SINGLE_ELIM" -> "single elimination";
                case "DOUBLE_ELIM" -> "double elimination";
                case "ROUND_ROBIN" -> "round robin";
                case "LEADERBOARD" -> "round robin";
                default -> "single elimination";
            }; // no native "leaderboard" in challonge

            // 3) Create the tournament
            JsonNode body = M.createObjectNode()
                    .putObject("tournament")
                    .put("name", prog.getProgramName())
                    .put("url", slug)
                    .put("tournament_type", type)
                    .put("open_signup", true)
                    .put("private", false);
            String payload = M.writeValueAsString(body);

            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(API_BASE + "/tournaments.json?api_key=" + API_KEY))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();
            HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());

            if (resp.statusCode() != 200 && resp.statusCode() != 201) {
                throw new ServiceException("Challonge create failed ["
                        + resp.statusCode() + "]: " + resp.body());
            }

            JsonNode tourn = M.readTree(resp.body()).get("tournament");
            String cid = tourn.get("id").asText();
            String curl = tourn.get("url").asText();

            // 4) Seed every paid participant
            List<TournamentParticipant> parts = tpDao.findByProgId(progId);
            for (TournamentParticipant p : parts) {
                // build the minimal JSON for each participant
                JsonNode pj = M.createObjectNode()
                        .putObject("participant")
                        .put("name", p.getTeamId() != null
                                ? "Team_" + p.getTeamId()
                                : p.getUserId());
                String pld = M.writeValueAsString(pj);

                HttpRequest pReq = HttpRequest.newBuilder()
                        .uri(URI.create(API_BASE
                                + "/tournaments/" + cid
                                + "/participants.json?api_key=" + API_KEY))
                        .header("Content-Type", "application/json")
                        .POST(HttpRequest.BodyPublishers.ofString(pld))
                        .build();
                HttpResponse<Void> pResp
                        = http.send(pReq, HttpResponse.BodyHandlers.discarding());
                if (pResp.statusCode() >= 400) {
                    // you could log or throw here if you want to fail fast
                    System.err.println("Failed to seed participant: " + p.getId());
                }
            }

            // 5) Persist our mapping
            ChallongeTournament ct = new ChallongeTournament();
            ct.setProgId(progId);
            ct.setChallongeId(cid);
            ct.setChallongeUrl(curl);
            ct.setState("pending");           // or "underway" if you want
            ct.setMetadata(resp.body());      // full JSON response
            ct.setCreatedAt(LocalDateTime.now());
            ct.setLastSyncAt(LocalDateTime.now());

            ctDao.insertOrUpdate(ct);
            return ct;

        } catch (IOException | InterruptedException | SQLException e) {
            throw new ServiceException("Failed to provision Challonge bracket", e);
        }
    }

    public ChallongeTournament syncTournament(ChallongeTournament existing) {
        try {
            // call the API
            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(API_BASE + "/tournaments/"
                            + existing.getChallongeId()
                            + ".json?api_key=" + API_KEY))
                    .GET()
                    .build();

            String body = http.send(req, HttpResponse.BodyHandlers.ofString())
                    .body();

            JsonNode wrapper = M.readTree(body);
            JsonNode t = wrapper.get("tournament");

            // pull out whatever fields you care about
            existing.setState(t.get("state").asText());
            existing.setMetadata(body);
            existing.setLastSyncAt(LocalDateTime.now());

            // persist that update
            ctDao.insertOrUpdate(existing);
            return existing;

        } catch (IOException | InterruptedException | SQLException e) {
            throw new ServiceException("Failed to sync Challonge bracket", e);
        }
    }

    /**
     * Look up in our DB.
     *
     * @param progId
     * @return
     */
    public ChallongeTournament find(int progId) {
        try {
            return ctDao.findByProgId(progId);
        } catch (SQLException e) {
            throw new ServiceException("Cannot load Challonge mapping", e);
        }
    }

    /**
     * Update name/description on Challonge + our DB.
     *
     * @param progId
     * @param name
     * @param description
     */
    public void update(int progId, String name, String description) {
        try {
            ChallongeTournament ct = ctDao.findByProgId(progId);
            if (ct == null) {
                throw new IllegalStateException("No bracket to edit");
            }
            // build JSON
            JsonNode body = M.createObjectNode()
                    .putObject("tournament")
                    .put("name", name)
                    .put("description", description);
            String payload = M.writeValueAsString(body);
            // call API
            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(API_BASE + "/tournaments/" + ct.getChallongeId() + ".json?api_key=" + API_KEY))
                    .header("Content-Type", "application/json")
                    .PUT(HttpRequest.BodyPublishers.ofString(payload))
                    .build();
            http.send(req, HttpResponse.BodyHandlers.ofString());
            // persist change
            ct.setMetadata(payload);
            ct.setLastSyncAt(LocalDateTime.now());
            ctDao.insertOrUpdate(ct);

        } catch (IOException | InterruptedException | SQLException e) {
            throw new ServiceException("Failed to update Challonge bracket", e);
        }
    }

    /**
     * Delete on Challonge + our DB.
     */
    public void delete(int progId) {
        try {
            ChallongeTournament ct = ctDao.findByProgId(progId);
            if (ct == null) {
                return;
            }
            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(API_BASE + "/tournaments/" + ct.getChallongeId() + ".json?api_key=" + API_KEY))
                    .DELETE()
                    .build();
            http.send(req, HttpResponse.BodyHandlers.discarding());
            ctDao.deleteByProgId(progId);
        } catch (IOException | InterruptedException | SQLException e) {
            throw new ServiceException("Failed to delete Challonge bracket", e);
        }
    }
}
