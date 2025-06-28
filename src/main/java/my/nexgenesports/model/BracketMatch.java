// File: BracketMatch.java
package my.nexgenesports.model;

import java.time.LocalDateTime;

public class BracketMatch {
    private Integer matchId;
    private Integer bracketId;
    private Integer round;
    private Integer matchNumber;
    private Long participant1;
    private Long participant2;
    private Integer score1;
    private Integer score2;
    private Long winner;
    private String updated_by;
    private LocalDateTime updated_at;

    // getters + setters
    public Integer getMatchId() { return matchId; }
    public void setMatchId(Integer matchId) { this.matchId = matchId; }
    public Integer getBracketId() { return bracketId; }
    public void setBracketId(Integer bracketId) { this.bracketId = bracketId; }
    public Integer getRound() { return round; }
    public void setRound(Integer round) { this.round = round; }
    public Integer getMatchNumber() { return matchNumber; }
    public void setMatchNumber(Integer matchNumber) { this.matchNumber = matchNumber; }
    public Long getParticipant1() { return participant1; }
    public void setParticipant1(Long participant1) { this.participant1 = participant1; }
    public Long getParticipant2() { return participant2; }
    public void setParticipant2(Long participant2) { this.participant2 = participant2; }
    public Integer getScore1() { return score1; }
    public void setScore1(Integer score1) { this.score1 = score1; }
    public Integer getScore2() { return score2; }
    public void setScore2(Integer score2) { this.score2 = score2; }
    public Long getWinner() { return winner; }
    public void setWinner(Long winner) { this.winner = winner; }
    public String getUpdatedBy() {return updated_by;}
    public LocalDateTime getUpdatedAt() {return updated_at;}
    public void setUpdatedBy(String updated_by) {this.updated_by = updated_by;}
    public void setUpdatedAt(LocalDateTime updated_at) {this.updated_at = updated_at;}
}
