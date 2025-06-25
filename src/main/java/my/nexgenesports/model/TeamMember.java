package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class TeamMember {
    private int teamID;
    private String userID;
    private String status;     // "Pending","Active","Declined"
    private String teamRole;   // "Leader","Co-Leader","Member"
    private LocalDateTime joinedAt;
    private LocalDateTime roleAssignedAt;

    public TeamMember() {}

    public TeamMember(int teamID, String userID, String status, String teamRole,
                      LocalDateTime joinedAt, LocalDateTime roleAssignedAt) {
        this.teamID         = teamID;
        this.userID         = userID;
        this.status         = status;
        this.teamRole       = teamRole;
        this.joinedAt       = joinedAt;
        this.roleAssignedAt = roleAssignedAt;
    }

    // Getters & Setters
    public int getTeamID() { return teamID; }
    public void setTeamID(int teamID) { this.teamID = teamID; }

    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTeamRole() { return teamRole; }
    public void setTeamRole(String teamRole) { this.teamRole = teamRole; }

    public LocalDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(LocalDateTime joinedAt) { this.joinedAt = joinedAt; }

    public LocalDateTime getRoleAssignedAt() { return roleAssignedAt; }
    public void setRoleAssignedAt(LocalDateTime roleAssignedAt) { this.roleAssignedAt = roleAssignedAt; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TeamMember)) return false;
        TeamMember that = (TeamMember) o;
        return teamID == that.teamID && Objects.equals(userID, that.userID);
    }

    @Override
    public int hashCode() {
        return Objects.hash(teamID, userID);
    }

    @Override
    public String toString() {
        return "TeamMember{" +
               "teamID=" + teamID +
               ", userID='" + userID + '\'' +
               ", role='" + teamRole + '\'' +
               ", status='" + status + '\'' +
               '}';
    }
}
