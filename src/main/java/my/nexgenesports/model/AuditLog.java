package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class AuditLog {
    private long logID;
    private String entityType;
    private String entityID;
    private String actionType;
    private String performedBy;
    private LocalDateTime ts;
    private String details; // JSON string

    public AuditLog() {}

    // Getters & Setters
    public long getLogID() { return logID; }
    public void setLogID(long logID) { this.logID = logID; }

    public String getEntityType() { return entityType; }
    public void setEntityType(String entityType) { this.entityType = entityType; }

    public String getEntityID() { return entityID; }
    public void setEntityID(String entityID) { this.entityID = entityID; }

    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }

    public String getPerformedBy() { return performedBy; }
    public void setPerformedBy(String performedBy) { this.performedBy = performedBy; }

    public LocalDateTime getTs() { return ts; }
    public void setTs(LocalDateTime ts) { this.ts = ts; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AuditLog)) return false;
        return logID == ((AuditLog) o).logID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(logID);
    }

    @Override
    public String toString() {
        return "AuditLog{" +
               "logID=" + logID +
               ", entityType='" + entityType + '\'' +
               ", actionType='" + actionType + '\'' +
               ", performedBy='" + performedBy + '\'' +
               ", ts=" + ts +
               '}';
    }
}
