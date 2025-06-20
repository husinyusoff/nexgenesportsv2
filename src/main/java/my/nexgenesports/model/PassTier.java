// src/main/java/com/nexgenesports/model/PassTier.java
package my.nexgenesports.model;

import java.math.BigDecimal;
import java.util.Objects;

public class PassTier {
    private int         tierId;
    private String      tierName;
    private BigDecimal  price;
    private int         discountRate;

    public PassTier() {}

    public PassTier(int tierId,
                    String tierName,
                    BigDecimal price,
                    int discountRate) {
        this.tierId       = tierId;
        this.tierName     = tierName;
        this.price        = price;
        this.discountRate = discountRate;
    }

    public int getTierId() { return tierId; }
    public void setTierId(int tierId) { this.tierId = tierId; }

    public String getTierName() { return tierName; }
    public void setTierName(String tierName) { this.tierName = tierName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getDiscountRate() { return discountRate; }
    public void setDiscountRate(int discountRate) { this.discountRate = discountRate; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PassTier)) return false;
        PassTier that = (PassTier) o;
        return tierId == that.tierId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(tierId);
    }

    @Override
    public String toString() {
        return "PassTier{" +
               "tierId=" + tierId +
               ", tierName='" + tierName + '\'' +
               ", price=" + price +
               ", discountRate=" + discountRate +
               '}';
    }
}
