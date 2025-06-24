package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class UserGamingPass {
    private int            id;
    private String         userId;
    private PassTier       tier;
    private LocalDateTime  purchaseDate;
    private LocalDateTime  expiryDate;
    private String         status;
    private String         paymentReference;

    public UserGamingPass() {}

    public UserGamingPass(int id,
                          String userId,
                          PassTier tier,
                          LocalDateTime purchaseDate,
                          LocalDateTime expiryDate,
                          String status,
                          String paymentReference) {
        this.id               = id;
        this.userId           = userId;
        this.tier             = tier;
        this.purchaseDate     = purchaseDate;
        this.expiryDate       = expiryDate;
        this.status           = status;
        this.paymentReference = paymentReference;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public PassTier getTier() {
        return tier;
    }

    public void setTier(PassTier tier) {
        this.tier = tier;
    }

    public LocalDateTime getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(LocalDateTime purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public LocalDateTime getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDateTime expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentReference() {
        return paymentReference;
    }

    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }

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
               ", status='" + status + '\'' +
               ", paymentReference='" + paymentReference + '\'' +
               '}';
    }
}
