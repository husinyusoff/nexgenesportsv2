package my.nexgenesports.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

public class MembershipSession {
    private String sessionId;
    private String sessionName;
    private LocalDateTime startMembershipDate;
    private LocalDateTime endMembershipDate;
    private BigDecimal fee;
    private boolean isActive;
    private Integer capacityLimit;
    private List<String> benefitLines;

    public MembershipSession() {}

    public MembershipSession(String sessionId,
                             String sessionName,
                             LocalDateTime startMembershipDate,
                             LocalDateTime endMembershipDate,
                             BigDecimal fee,
                             boolean isActive,
                             Integer capacityLimit,
                             List<String> benefitLines) {
        this.sessionId = sessionId;
        this.sessionName = sessionName;
        this.startMembershipDate = startMembershipDate;
        this.endMembershipDate = endMembershipDate;
        this.fee = fee;
        this.isActive = isActive;
        this.capacityLimit = capacityLimit;
        this.benefitLines = benefitLines;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getSessionName() {
        return sessionName;
    }

    public void setSessionName(String sessionName) {
        this.sessionName = sessionName;
    }

    public LocalDateTime getStartMembershipDate() {
        return startMembershipDate;
    }

    public void setStartMembershipDate(LocalDateTime startMembershipDate) {
        this.startMembershipDate = startMembershipDate;
    }

    public LocalDateTime getEndMembershipDate() {
        return endMembershipDate;
    }

    public void setEndMembershipDate(LocalDateTime endMembershipDate) {
        this.endMembershipDate = endMembershipDate;
    }

    public BigDecimal getFee() {
        return fee;
    }

    public void setFee(BigDecimal fee) {
        this.fee = fee;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Integer getCapacityLimit() {
        return capacityLimit;
    }

    public void setCapacityLimit(Integer capacityLimit) {
        this.capacityLimit = capacityLimit;
    }

    public List<String> getBenefitLines() {
        return benefitLines;
    }

    public void setBenefitLines(List<String> benefitLines) {
        this.benefitLines = benefitLines;
    }

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
               ", isActive=" + isActive +
               ", capacityLimit=" + capacityLimit +
               ", benefitLines=" + benefitLines +
               '}';
    }
}
