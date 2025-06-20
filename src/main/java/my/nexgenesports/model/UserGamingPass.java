// src/main/java/com/nexgenesports/model/UserGamingPass.java
package my.nexgenesports.model;

import java.time.LocalDate;
import java.util.Objects;


public class UserGamingPass {
    private int       id;
    private String    userId;
    private PassTier  tier;
    private LocalDate purchaseDate;
    private LocalDate expiryDate;
    private String paymentReference;

    public UserGamingPass() {}

    public UserGamingPass(int id,
                          String userId,
                          PassTier tier,
                          LocalDate purchaseDate,
                          LocalDate expiryDate,
                          String paymentReference) {
        this.id               = id;
        this.userId           = userId;
        this.tier             = tier;
        this.purchaseDate     = purchaseDate;
        this.expiryDate       = expiryDate;
        this.paymentReference = paymentReference;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public PassTier getTier() { return tier; }
    public void setTier(PassTier tier) { this.tier = tier; }

    public LocalDate getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(LocalDate purchaseDate) { this.purchaseDate = purchaseDate; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }
    
    public void setPaymentReference(String paymentReference) { this.paymentReference = paymentReference; }
    
    public String getPaymentReference() { return paymentReference; }

    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserGamingPass)) return false;
        UserGamingPass that = (UserGamingPass) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "UserGamingPass{" +
               "id=" + id +
               ", userId='" + userId + '\'' +
               ", tier=" + tier +
               ", purchaseDate=" + purchaseDate +
               ", expiryDate=" + expiryDate +
               '}';
    }
}
