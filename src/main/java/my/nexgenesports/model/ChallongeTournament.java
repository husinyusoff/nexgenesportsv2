// src/main/java/my/nexgenesports/model/ChallongeTournament.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class ChallongeTournament {
    private int            progId;
    private String         challongeId;
    private String         challongeUrl;
    private String         state;
    private String         metadata;     // raw JSON from Challonge
    private LocalDateTime  createdAt;
    private LocalDateTime  lastSyncAt;

    // getters + setters
    public int getProgId()                  { return progId; }
    public void setProgId(int progId)       { this.progId = progId; }
    public String getChallongeId()          { return challongeId; }
    public void setChallongeId(String i)    { this.challongeId = i; }
    public String getChallongeUrl()         { return challongeUrl; }
    public void setChallongeUrl(String u)   { this.challongeUrl = u; }
    public String getState()                { return state; }
    public void setState(String s)          { this.state = s; }
    public String getMetadata()             { return metadata; }
    public void setMetadata(String m)       { this.metadata = m; }
    public LocalDateTime getCreatedAt()     { return createdAt; }
    public void setCreatedAt(LocalDateTime t){ this.createdAt = t; }
    public LocalDateTime getLastSyncAt()    { return lastSyncAt; }
    public void setLastSyncAt(LocalDateTime t){ this.lastSyncAt = t; }
}
