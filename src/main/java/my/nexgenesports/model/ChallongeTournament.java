// File: ChallongeTournament.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class ChallongeTournament {
    private String progId;
    private String challongeTournamentId;
    private String challongeUrl;
    private String challongeState;
    private LocalDateTime challongeCreatedAt;
    private LocalDateTime challongeLastSyncAt;
    private String challongeMetadata;

    // getters + setters
    public String getProgId() { return progId; }
    public void setProgId(String progId) { this.progId = progId; }
    public String getChallongeTournamentId() { return challongeTournamentId; }
    public void setChallongeTournamentId(String id) { this.challongeTournamentId = id; }
    public String getChallongeUrl() { return challongeUrl; }
    public void setChallongeUrl(String url) { this.challongeUrl = url; }
    public String getChallongeState() { return challongeState; }
    public void setChallongeState(String challongeState) { this.challongeState = challongeState; }
    public LocalDateTime getChallongeCreatedAt() { return challongeCreatedAt; }
    public void setChallongeCreatedAt(LocalDateTime challongeCreatedAt) { this.challongeCreatedAt = challongeCreatedAt; }
    public LocalDateTime getChallongeLastSyncAt() { return challongeLastSyncAt; }
    public void setChallongeLastSyncAt(LocalDateTime challongeLastSyncAt) { this.challongeLastSyncAt = challongeLastSyncAt; }
    public String getChallongeMetadata() { return challongeMetadata; }
    public void setChallongeMetadata(String challongeMetadata) { this.challongeMetadata = challongeMetadata; }
}
