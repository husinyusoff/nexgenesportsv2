package my.nexgenesports.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Calculates discounts using a Sequential discount strategy:
 * FinalTotal = Subtotal * (1 - MemDiscountRate) * (1 - PassDiscountRate)
 */
public class PricingEngine {

    public static class PricingResult {
        private BigDecimal originalPrice;
        private BigDecimal membershipDiscountAmount;
        private BigDecimal passDiscountAmount;
        private BigDecimal finalPrice;

        public PricingResult(BigDecimal originalPrice, BigDecimal membershipDiscountAmount, BigDecimal passDiscountAmount, BigDecimal finalPrice) {
            this.originalPrice = originalPrice.setScale(2, RoundingMode.HALF_UP);
            this.membershipDiscountAmount = membershipDiscountAmount.setScale(2, RoundingMode.HALF_UP);
            this.passDiscountAmount = passDiscountAmount.setScale(2, RoundingMode.HALF_UP);
            this.finalPrice = finalPrice.setScale(2, RoundingMode.HALF_UP);
        }

        public BigDecimal getOriginalPrice() { return originalPrice; }
        public BigDecimal getMembershipDiscountAmount() { return membershipDiscountAmount; }
        public BigDecimal getPassDiscountAmount() { return passDiscountAmount; }
        public BigDecimal getFinalPrice() { return finalPrice; }
    }

    /**
     * Computes the pricing sequentially.
     * @param subtotal Original price before discounts
     * @param memDiscountRate integer percentage (e.g. 15 for 15%)
     * @param passDiscountRate integer percentage (e.g. 10 for 10%)
     */
    public static PricingResult calculate(BigDecimal subtotal, int memDiscountRate, int passDiscountRate) {
        if (subtotal == null) subtotal = BigDecimal.ZERO;
        
        BigDecimal remaining = subtotal;
        
        BigDecimal memDeduction = BigDecimal.ZERO;
        if (memDiscountRate > 0) {
            BigDecimal rate = new BigDecimal(memDiscountRate).divide(new BigDecimal(100), 4, RoundingMode.HALF_UP);
            memDeduction = remaining.multiply(rate);
            remaining = remaining.subtract(memDeduction);
        }
        
        BigDecimal passDeduction = BigDecimal.ZERO;
        if (passDiscountRate > 0) {
            BigDecimal rate = new BigDecimal(passDiscountRate).divide(new BigDecimal(100), 4, RoundingMode.HALF_UP);
            passDeduction = remaining.multiply(rate);
            remaining = remaining.subtract(passDeduction);
        }
        
        return new PricingResult(subtotal, memDeduction, passDeduction, remaining);
    }
}
