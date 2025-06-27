// src/main/java/my/nexgenesports/model/ProgramParticipant.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class ProgramParticipant {
    private long id;
    private String progID;
    private String userId;
    private String teamId;
    private LocalDateTime joinedAt;

    // getters & setters

    public long getId()                       { return id; }
    public void setId(long id)                { this.id = id; }

    public String getProgID()                 { return progID; }
    public void setProgID(String progID)      { this.progID = progID; }

    public String getUserId()                 { return userId; }
    public void setUserId(String userId)      { this.userId = userId; }

    public String getTeamId()                 { return teamId; }
    public void setTeamId(String teamId)      { this.teamId = teamId; }

    public LocalDateTime getJoinedAt()        { return joinedAt; }
    public void setJoinedAt(LocalDateTime js) { this.joinedAt = js; }
}
