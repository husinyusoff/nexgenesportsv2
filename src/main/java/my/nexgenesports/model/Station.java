// src/main/java/my/nexgenesports/model/Station.java
package my.nexgenesports.model;

import java.math.BigDecimal;

public class Station {
    private String stationID;
    private String stationName;
    private BigDecimal normalPrice1Player;
    private BigDecimal normalPrice2Player;
    private BigDecimal happyHourPrice1Player;
    private BigDecimal happyHourPrice2Player;
    // getters & setters
    public String getStationID() { return stationID; }
    public void setStationID(String stationID) { this.stationID = stationID; }
    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }
    public BigDecimal getNormalPrice1Player() { return normalPrice1Player; }
    public void setNormalPrice1Player(BigDecimal p) { this.normalPrice1Player = p; }
    public BigDecimal getNormalPrice2Player() { return normalPrice2Player; }
    public void setNormalPrice2Player(BigDecimal p) { this.normalPrice2Player = p; }
    public BigDecimal getHappyHourPrice1Player() { return happyHourPrice1Player; }
    public void setHappyHourPrice1Player(BigDecimal p) { this.happyHourPrice1Player = p; }
    public BigDecimal getHappyHourPrice2Player() { return happyHourPrice2Player; }
    public void setHappyHourPrice2Player(BigDecimal p) { this.happyHourPrice2Player = p; }
}
