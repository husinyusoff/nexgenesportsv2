package my.nexgenesports.model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Objects;

/**
 * Represents one monthly-gaming-pass tier.
 * Now holds its benefits as an ordered List<String>.
 */
public class PassTier {
    private int tierId;
    private String tierName;
    private BigDecimal price;
    private int discountRate;

    /** NEW: loaded from pass_benefits */
    private List<String> benefitLines;

    public PassTier() {}

    public PassTier(int tierId,
                    String tierName,
                    BigDecimal price,
                    int discountRate,
                    List<String> benefitLines) {
        this.tierId = tierId;
        this.tierName = tierName;
        this.price = price;
        this.discountRate = discountRate;
        this.benefitLines = benefitLines;
    }

    public int getTierId() {return tierId;}

    public String getTierName() {return tierName;}

    public BigDecimal getPrice() {return price;}

    public int getDiscountRate() {return discountRate;}

    public void setTierId(int tierId) {this.tierId = tierId;}

    public void setTierName(String tierName) {this.tierName = tierName;}

    public void setPrice(BigDecimal price) {this.price = price;}

    public void setDiscountRate(int discountRate) {this.discountRate = discountRate;}

    public List<String> getBenefitLines() {return benefitLines;}
    
    public void setBenefitLines(List<String> benefitLines) {this.benefitLines = benefitLines;}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PassTier)) return false;
        PassTier that = (PassTier) o;
        return getTierId() == that.getTierId();
    }

    @Override
    public int hashCode() {
        return Objects.hash(getTierId());
    }

    @Override
    public String toString() {
        return "PassTier{" +
               "tierId=" + getTierId() +
               ", tierName='" + getTierName() + '\'' +
               ", price=" + getPrice() +
               ", discountRate=" + getDiscountRate() +
               ", benefitLines=" + benefitLines +
               '}';
    }
}
