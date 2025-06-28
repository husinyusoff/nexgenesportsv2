// File: TournamentParticipant.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class TournamentParticipant {
    private Long id;
    private String progId;
    private String userId;
    private String teamId;
    private String status;
    private String paymentRef;
    private LocalDateTime joinedAt;

    // getters + setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getProgId() { return progId; }
    public void setProgId(String progId) { this.progId = progId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPaymentRef() { return paymentRef; }
    public void setPaymentRef(String paymentRef) { this.paymentRef = paymentRef; }
    public LocalDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(LocalDateTime joinedAt) { this.joinedAt = joinedAt; }
}
