// File: src/main/java/my/nexgenesports/model/TournamentParticipant.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class TournamentParticipant {

    private Long id;
    private Integer progId;             // INT in the DB
    private String userId;             // VARCHAR(50) in the DB
    private Integer teamId;             // INT in the DB
    private String role;          // ← NEW
    private String status;             // PENDING/PAID/CANCELLED
    private String paymentReference;   // VARCHAR(100) in the DB
    private LocalDateTime joinedAt;           // DATETIME in the DB

    public TournamentParticipant() {
    }

    // Optional convenience constructor—you can drop this if you never use it
    public TournamentParticipant(Integer progId, String userId, Integer teamId) {
        this.progId = progId;
        this.userId = userId;
        this.teamId = teamId;
    }

    // --- getters + setters ---
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getProgId() {
        return progId;
    }

    public void setProgId(Integer progId) {
        this.progId = progId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Integer getTeamId() {
        return teamId;
    }

    public void setTeamId(Integer teamId) {
        this.teamId = teamId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentReference() {
        return paymentReference;
    }

    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
