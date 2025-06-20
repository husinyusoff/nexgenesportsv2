package my.nexgenesports.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class Booking {
    private int         bookingID;
    private String      userID;
    private String      stationID;
    private LocalDate   date;
    private LocalTime   startTime;
    private LocalTime   endTime;
    private String      status;          // e.g. "PENDING","PAID","FAILED"
    private String      priceType;       // "Normal" or "HappyHour"
    private int         playerCount;
    private BigDecimal  price;
    private String      paymentStatus;   // enum: PENDING, PAID, FAILED
    private Integer     paymentReference;
    private int         hourCount;

    // getters & setters
    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }

    public String getStationID() { return stationID; }
    public void setStationID(String stationID) { this.stationID = stationID; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPriceType() { return priceType; }
    public void setPriceType(String priceType) { this.priceType = priceType; }

    public int getPlayerCount() { return playerCount; }
    public void setPlayerCount(int playerCount) { this.playerCount = playerCount; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Integer getPaymentReference() { return paymentReference; }
    public void setPaymentReference(Integer paymentReference) { this.paymentReference = paymentReference; }

    public int getHourCount() { return hourCount; }
    public void setHourCount(int hourCount) { this.hourCount = hourCount; }
}
