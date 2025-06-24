package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class UserClubMembership {
    private int                 id;
    private String              userId;
    private MembershipSession   session;
    private LocalDateTime       purchaseDate;
    private LocalDateTime       expiryDate;
    private String              status;
    private String              paymentReference;

    public UserClubMembership() {}

    public UserClubMembership(int id,
                              String userId,
                              MembershipSession session,
                              LocalDateTime purchaseDate,
                              LocalDateTime expiryDate,
                              String status,
                              String paymentReference) {
        this.id               = id;
        this.userId           = userId;
        this.session          = session;
        this.purchaseDate     = purchaseDate;
        this.expiryDate       = expiryDate;
        this.status           = status;
        this.paymentReference = paymentReference;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public MembershipSession getSession() { return session; }
    public void setSession(MembershipSession session) { this.session = session; }

    public LocalDateTime getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(LocalDateTime purchaseDate) { this.purchaseDate = purchaseDate; }

    public LocalDateTime getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDateTime expiryDate) { this.expiryDate = expiryDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentReference() { return paymentReference; }
    public void setPaymentReference(String paymentReference) { this.paymentReference = paymentReference; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserClubMembership)) return false;
        UserClubMembership that = (UserClubMembership) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "UserClubMembership{" +
               "id=" + id +
               ", userId='" + userId + '\'' +
               ", session=" + session +
               ", purchaseDate=" + purchaseDate +
               ", expiryDate=" + expiryDate +
               ", status='" + status + '\'' +
               ", paymentReference='" + paymentReference + '\'' +
               '}';
    }
}
