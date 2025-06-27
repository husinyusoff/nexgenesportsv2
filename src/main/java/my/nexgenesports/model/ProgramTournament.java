package my.nexgenesports.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Objects;

public class ProgramTournament {

    private String progID;
    private String creatorId;
    private String gameID;
    private String programName;
    private String meritLevel;
    private String place;
    private String description;
    private BigDecimal progFee;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private BigDecimal prizePool;
    private int capacity;
    private TournamentMode tournamentMode;   // SOLO / TEAM
    private int maxTeamMember;
    private TournamentStatus status;        // PENDING_APPROVAL / ACTIVE / COMPLETED / CANCELLED
    private boolean deletedFlag;
    private int version;
    private String tournamentType;          // single_elimination, swiss, etc.
    private boolean openSignup;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private ProgramType programType;

    public ProgramTournament() {
    }

    // >>> Getters & setters omitted for brevity, generate via IDE <<<
    // For example:
    public String getProgID() {
        return progID;
    }

    public void setProgID(String progID) {
        this.progID = progID;
    }
    // … all other getters/setters …

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof ProgramTournament)) {
            return false;
        }
        return Objects.equals(progID, ((ProgramTournament) o).progID);
    }

    @Override
    public int hashCode() {
        return Objects.hash(progID);
    }

    public String getCreatorId() {
        return creatorId;
    }

    public String getGameID() {
        return gameID;
    }

    public String getProgramName() {
        return programName;
    }

    public String getMeritLevel() {
        return meritLevel;
    }

    public String getPlace() {
        return place;
    }

    public String getDescription() {
        return description;
    }

    public BigDecimal getProgFee() {
        return progFee;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public BigDecimal getPrizePool() {
        return prizePool;
    }

    public int getCapacity() {
        return capacity;
    }

    public TournamentMode getTournamentMode() {
        return tournamentMode;
    }

    public int getMaxTeamMember() {
        return maxTeamMember;
    }

    public TournamentStatus getStatus() {
        return status;
    }

    public boolean isDeletedFlag() {
        return deletedFlag;
    }

    public int getVersion() {
        return version;
    }

    public String getTournamentType() {
        return tournamentType;
    }

    public boolean isOpenSignup() {
        return openSignup;
    }

    public LocalDateTime getStartAt() {
        return startAt;
    }

    public LocalDateTime getEndAt() {
        return endAt;
    }

    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }

    public void setGameID(String gameID) {
        this.gameID = gameID;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }

    public void setMeritLevel(String meritLevel) {
        this.meritLevel = meritLevel;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setProgFee(BigDecimal progFee) {
        this.progFee = progFee;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public void setPrizePool(BigDecimal prizePool) {
        this.prizePool = prizePool;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public void setTournamentMode(TournamentMode tournamentMode) {
        this.tournamentMode = tournamentMode;
    }

    public void setMaxTeamMember(int maxTeamMember) {
        this.maxTeamMember = maxTeamMember;
    }

    public void setStatus(TournamentStatus status) {
        this.status = status;
    }

    public void setDeletedFlag(boolean deletedFlag) {
        this.deletedFlag = deletedFlag;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public void setTournamentType(String tournamentType) {
        this.tournamentType = tournamentType;
    }

    public void setOpenSignup(boolean openSignup) {
        this.openSignup = openSignup;
    }

    public void setStartAt(LocalDateTime startAt) {
        this.startAt = startAt;
    }

    public void setEndAt(LocalDateTime endAt) {
        this.endAt = endAt;
    }

    public ProgramType getProgramType() {
        return programType;
    }

    public void setProgramType(ProgramType programType) {
        this.programType = programType;
    }
}
