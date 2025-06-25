package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class JoinRequest {
    private int requestID;
    private int teamID;
    private String userID;
    private LocalDateTime requestedAt;
    private String status;           // "Pending", "Accepted", "Rejected"
    private LocalDateTime respondedAt;

    public JoinRequest() {}

    public int getRequestID() {
        return requestID;
    }
    public void setRequestID(int requestID) {
        this.requestID = requestID;
    }

    public int getTeamID() {
        return teamID;
    }
    public void setTeamID(int teamID) {
        this.teamID = teamID;
    }

    public String getUserID() {
        return userID;
    }
    public void setUserID(String userID) {
        this.userID = userID;
    }

    public LocalDateTime getRequestedAt() {
        return requestedAt;
    }
    public void setRequestedAt(LocalDateTime requestedAt) {
        this.requestedAt = requestedAt;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRespondedAt() {
        return respondedAt;
    }
    public void setRespondedAt(LocalDateTime respondedAt) {
        this.respondedAt = respondedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof JoinRequest)) return false;
        JoinRequest that = (JoinRequest) o;
        return requestID == that.requestID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(requestID);
    }

    @Override
    public String toString() {
        return "JoinRequest{" +
               "requestID=" + requestID +
               ", teamID=" + teamID +
               ", userID='" + userID + '\'' +
               ", status='" + status + '\'' +
               ", requestedAt=" + requestedAt +
               ", respondedAt=" + respondedAt +
               '}';
    }
}
