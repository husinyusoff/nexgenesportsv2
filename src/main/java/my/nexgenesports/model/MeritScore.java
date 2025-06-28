// File: src/main/java/my/nexgenesports/model/MeritScore.java
package my.nexgenesports.model;

public class MeritScore {
    private int meritId;
    private String rank;
    private int points;

    public int getMeritId() {
        return meritId;
    }
    public void setMeritId(int meritId) {
        this.meritId = meritId;
    }
    public String getRank() {
        return rank;
    }
    public void setRank(String rank) {
        this.rank = rank;
    }
    public int getPoints() {
        return points;
    }
    public void setPoints(int points) {
        this.points = points;
    }
}
