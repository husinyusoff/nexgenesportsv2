package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class Team {

    private int teamID;
    private String teamName;
    private String description;
    private String logoURL;
    private String leader;
    private LocalDateTime createdAt;
    private LocalDateTime disbandedAt;
    private String status; // "Active" or "Disbanded"
    private int capacity;       // ← new
    private int activeCount;
    private boolean member;

    public Team() {
    }

    public Team(int teamID, String teamName, String description, String logoURL,
            String createdBy, LocalDateTime createdAt,
            LocalDateTime disbandedAt, String status) {
        this.teamID = teamID;
        this.teamName = teamName;
        this.description = description;
        this.logoURL = logoURL;
        this.leader = leader;
        this.createdAt = createdAt;
        this.disbandedAt = disbandedAt;
        this.status = status;
    }

    // Getters & Setters
    public int getTeamID() {
        return teamID;
    }

    public void setTeamID(int teamID) {
        this.teamID = teamID;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogoURL() {
        return logoURL;
    }

    public void setLogoURL(String logoURL) {
        this.logoURL = logoURL;
    }

    public String getLeader() {
        return leader;
    }

    public void setLeader(String leader) {
        this.leader = leader;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getDisbandedAt() {
        return disbandedAt;
    }

    public void setDisbandedAt(LocalDateTime disbandedAt) {
        this.disbandedAt = disbandedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getActiveCount() {
        return activeCount;
    }

    public void setActiveCount(int activeCount) {
        this.activeCount = activeCount;
    }

    public boolean getMember() {
        return member;
    }

    public void setMember(boolean member) {
        this.member = member;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Team)) {
            return false;
        }
        Team team = (Team) o;
        return teamID == team.teamID;
    }

    @Override
    public int hashCode() {
        return Objects.hash(teamID);
    }

    @Override
    public String toString() {
        return "Team{"
                + "teamID=" + teamID
                + ", teamName='" + teamName + '\''
                + ", status='" + status + '\''
                + '}';
    }
}
