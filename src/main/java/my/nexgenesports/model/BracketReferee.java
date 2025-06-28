// File: src/main/java/my/nexgenesports/model/BracketReferee.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class BracketReferee {
    private int id;
    private int bracketId;
    private String refereeId;
    private LocalDateTime assignedAt;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getBracketId() {
        return bracketId;
    }
    public void setBracketId(int bracketId) {
        this.bracketId = bracketId;
    }
    public String getRefereeId() {
        return refereeId;
    }
    public void setRefereeId(String refereeId) {
        this.refereeId = refereeId;
    }
    public LocalDateTime getAssignedAt() {
        return assignedAt;
    }
    public void setAssignedAt(LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }
}
