// src/main/java/my/nexgenesports/model/ProgramTournamentSync.java
package my.nexgenesports.model;

import com.fasterxml.jackson.databind.JsonNode;
import java.time.LocalDateTime;

public class ProgramTournamentSync {
    private String progID;
    private String challongeTournamentId;
    private String challongeUrl;
    private ChallongeState challongeState;
    private LocalDateTime challongeCreatedAt;
    private LocalDateTime challongeLastSyncAt;
    private JsonNode   challongeMetadata;

    public String getProgID() {
        return progID;
    }
    public void setProgID(String progID) {
        this.progID = progID;
    }

    public String getChallongeTournamentId() {
        return challongeTournamentId;
    }
    public void setChallongeTournamentId(String id) {
        this.challongeTournamentId = id;
    }

    public String getChallongeUrl() {
        return challongeUrl;
    }
    public void setChallongeUrl(String url) {
        this.challongeUrl = url;
    }

    public ChallongeState getChallongeState() {
        return challongeState;
    }
    public void setChallongeState(ChallongeState state) {
        this.challongeState = state;
    }

    public LocalDateTime getChallongeCreatedAt() {
        return challongeCreatedAt;
    }
    public void setChallongeCreatedAt(LocalDateTime ts) {
        this.challongeCreatedAt = ts;
    }

    public LocalDateTime getChallongeLastSyncAt() {
        return challongeLastSyncAt;
    }
    public void setChallongeLastSyncAt(LocalDateTime ts) {
        this.challongeLastSyncAt = ts;
    }

    public JsonNode getChallongeMetadata() {
        return challongeMetadata;
    }
    public void setChallongeMetadata(JsonNode metadata) {
        this.challongeMetadata = metadata;
    }
}
