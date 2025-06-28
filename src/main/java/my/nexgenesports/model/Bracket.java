// File: Bracket.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class Bracket {
    private Integer bracketId;
    private String progId;
    private String name;
    private String format;
    private String createdBy;
    private LocalDateTime createdAt;
    private boolean isDeleted;

    // getters + setters
    public Integer getBracketId() { return bracketId; }
    public void setBracketId(Integer bracketId) { this.bracketId = bracketId; }
    public String getProgId() { return progId; }
    public void setProgId(String progId) { this.progId = progId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }
}
