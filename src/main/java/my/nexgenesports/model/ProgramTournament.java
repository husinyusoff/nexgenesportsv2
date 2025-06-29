// File: src/main/java/my/nexgenesports/model/ProgramTournament.java
package my.nexgenesports.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class ProgramTournament {
    private int progId;
    private String creatorId;
    private Integer gameId;
    private String programName;
    private String programType;
    private Integer meritId;
    private String place;
    private String description;
    private BigDecimal progFee;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private BigDecimal prizePool;
    private int maxCapacity;
    private Integer maxTeamMember;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean deletedFlag;

    public Integer getProgId() {
        return progId;
    }
    public void setProgId(Integer progId) {
        this.progId = progId;
    }
    public String getCreatorId() {
        return creatorId;
    }
    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }
    public Integer getGameId() {
        return gameId;
    }
    public void setGameId(Integer gameId) {
        this.gameId = gameId;
    }
    public String getProgramName() {
        return programName;
    }
    public void setProgramName(String programName) {
        this.programName = programName;
    }
    public String getProgramType() {
        return programType;
    }
    public void setProgramType(String programType) {
        this.programType = programType;
    }
    public Integer getMeritId() {
        return meritId;
    }
    public void setMeritId(Integer meritId) {
        this.meritId = meritId;
    }
    public String getPlace() {
        return place;
    }
    public void setPlace(String place) {
        this.place = place;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public BigDecimal getProgFee() {
        return progFee;
    }
    public void setProgFee(BigDecimal progFee) {
        this.progFee = progFee;
    }
    public LocalDate getStartDate() {
        return startDate;
    }
    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }
    public LocalDate getEndDate() {
        return endDate;
    }
    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
    public LocalTime getStartTime() {
        return startTime;
    }
    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }
    public LocalTime getEndTime() {
        return endTime;
    }
    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }
    public BigDecimal getPrizePool() {
        return prizePool;
    }
    public void setPrizePool(BigDecimal prizePool) {
        this.prizePool = prizePool;
    }
    public int getMaxCapacity() {
        return maxCapacity;
    }
    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }
    public Integer getMaxTeamMember() {
        return maxTeamMember;
    }
    public void setMaxTeamMember(Integer maxTeamMember) {
        this.maxTeamMember = maxTeamMember;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    public boolean isDeletedFlag() {
        return deletedFlag;
    }
    public void setDeletedFlag(boolean deletedFlag) {
        this.deletedFlag = deletedFlag;
    }
}
