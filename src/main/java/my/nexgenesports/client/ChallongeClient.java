// src/main/java/my/nexgenesports/client/ChallongeClient.java
package my.nexgenesports.client;

import my.nexgenesports.model.ProgramTournamentSync;
import my.nexgenesports.model.ChallongeState;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;

public class ChallongeClient {
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final DateTimeFormatter CHALLONGE_TS_FMT =
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ssXXX");

    private final HttpClient http = HttpClient.newHttpClient();
    private final String apiKey;
    private final String baseUrl;   // e.g. "https://api.challonge.com/v1"

    public ChallongeClient() {
        this.apiKey   = System.getenv("CHALLONGE_API_KEY");
        this.baseUrl  = System.getenv("CHALLONGE_API_BASE_URL");
        if (apiKey == null || baseUrl == null) {
            throw new IllegalStateException(
                "Must set CHALLONGE_API_KEY and CHALLONGE_API_BASE_URL in env"
            );
        }
    }

    private String authHeader() {
        // Basic auth: apiKey + ":" → Base64
        String cred = Base64.getEncoder().encodeToString((apiKey + ":").getBytes());
        return "Basic " + cred;
    }

    /**
     * Create a new Challonge tournament and return a populated ProgramTournamentSync.
     * @param progID
     * @param displayName
     * @return 
     * @throws java.io.IOException
     * @throws java.lang.InterruptedException
     */
    public ProgramTournamentSync createTournament(String progID, String displayName) throws IOException, InterruptedException {
        // Build JSON: { tournament: { name, url } }
        ObjectNode root = MAPPER.createObjectNode();
        ObjectNode t    = root.putObject("tournament");
        t.put("name", displayName);
        t.put("url",  progID);

        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/tournaments.json"))
            .header("Authorization", authHeader())
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(MAPPER.writeValueAsString(root)))
            .build();

        HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
        if (resp.statusCode() / 100 != 2) {
            throw new IOException("Challonge create failed: " + resp.statusCode() + " → " + resp.body());
        }

        JsonNode tour = MAPPER.readTree(resp.body()).get("tournament");
        return mapToSync(progID, tour);
    }

    /**
     * Fetch the latest state & metadata from Challonge for an existing bracket.
     * @param progID
     * @param challongeId
     * @return 
     * @throws java.io.IOException
     * @throws java.lang.InterruptedException
     */
    public ProgramTournamentSync fetchTournament(String progID, String challongeId) throws IOException, InterruptedException {
        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/tournaments/" + challongeId + ".json"))
            .header("Authorization", authHeader())
            .GET()
            .build();

        HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
        if (resp.statusCode() / 100 != 2) {
            throw new IOException("Challonge fetch failed: " + resp.statusCode() + " → " + resp.body());
        }

        JsonNode tour = MAPPER.readTree(resp.body()).get("tournament");
        return mapToSync(progID, tour);
    }

    /**
     * Cancel a tournament on Challonge.
     * @param challongeId
     * @throws java.io.IOException
     * @throws java.lang.InterruptedException
     */
    public void cancelTournament(String challongeId) throws IOException, InterruptedException {
        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/tournaments/" + challongeId + "/cancel.json"))
            .header("Authorization", authHeader())
            .POST(HttpRequest.BodyPublishers.noBody())
            .build();

        HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
        if (resp.statusCode() / 100 != 2) {
            throw new IOException("Challonge cancel failed: " + resp.statusCode() + " → " + resp.body());
        }
    }

    // ────────────────────────────────────────────────────────────────────────────
    // Internal helper to map a Challonge `tournament` JSON node into our Sync model
    private ProgramTournamentSync mapToSync(String progID, JsonNode tour) {
        ProgramTournamentSync s = new ProgramTournamentSync();
        s.setProgID(progID);
        s.setChallongeTournamentId(tour.get("id").asText());
        s.setChallongeUrl(tour.get("full_challonge_url").asText());
        s.setChallongeState(ChallongeState.valueOf(tour.get("state").asText().toUpperCase()));

        // parse created_at (e.g. "2025-06-28T14:23:00Z")
        String created = tour.path("created_at").asText(null);
        if (created != null && !created.isEmpty()) {
            s.setChallongeCreatedAt(LocalDateTime.parse(created, CHALLONGE_TS_FMT));
        }

        // we'll mark lastSyncAt as 'now'
        s.setChallongeLastSyncAt(LocalDateTime.now());

        // store the full JSON payload for later inspection
        s.setChallongeMetadata(tour);
        return s;
    }
}
