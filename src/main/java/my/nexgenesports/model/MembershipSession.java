// src/main/java/com/nexgenesports/model/MembershipSession.java
package my.nexgenesports.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Objects;

public class MembershipSession {
    private String    sessionId;
    private String    sessionName;
    private LocalDate startMembershipDate;
    private LocalDate endMembershipDate;
    private BigDecimal fee;
    private String    description;
    private boolean   isActive;
    private Integer   capacityLimit;

    public MembershipSession() {}

    public MembershipSession(String sessionId,
                             String sessionName,
                             LocalDate startMembershipDate,
                             LocalDate endMembershipDate,
                             BigDecimal fee,
                             String description,
                             boolean isActive,
                             Integer capacityLimit) {
        this.sessionId           = sessionId;
        this.sessionName         = sessionName;
        this.startMembershipDate = startMembershipDate;
        this.endMembershipDate   = endMembershipDate;
        this.fee                 = fee;
        this.description         = description;
        this.isActive            = isActive;
        this.capacityLimit       = capacityLimit;
    }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getSessionName() { return sessionName; }
    public void setSessionName(String sessionName) { this.sessionName = sessionName; }

    public LocalDate getStartMembershipDate() { return startMembershipDate; }
    public void setStartMembershipDate(LocalDate d) { this.startMembershipDate = d; }

    public LocalDate getEndMembershipDate() { return endMembershipDate; }
    public void setEndMembershipDate(LocalDate d) { this.endMembershipDate = d; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Integer getCapacityLimit() { return capacityLimit; }
    public void setCapacityLimit(Integer capacityLimit) { this.capacityLimit = capacityLimit; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MembershipSession)) return false;
        MembershipSession that = (MembershipSession) o;
        return Objects.equals(sessionId, that.sessionId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(sessionId);
    }

    @Override
    public String toString() {
        return "MembershipSession{" +
               "sessionId='" + sessionId + '\'' +
               ", sessionName='" + sessionName + '\'' +
               ", startMembershipDate=" + startMembershipDate +
               ", endMembershipDate=" + endMembershipDate +
               ", fee=" + fee +
               ", description='" + description + '\'' +
               ", isActive=" + isActive +
               ", capacityLimit=" + capacityLimit +
               '}';
    }
}
