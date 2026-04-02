package my.nexgenesports.model;

import java.util.Objects;

public class PassBenefit {
    private int id;
    private int tierId;
    private int benefitOrder;
    private String benefitText;
    private String benefitName;

    public PassBenefit() {}

    public PassBenefit(int id, int tierId, int benefitOrder, String benefitText) {
        this.id            = id;
        this.tierId        = tierId;
        this.benefitOrder  = benefitOrder;
        this.benefitText   = benefitText;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTierId() { return tierId; }
    public void setTierId(int tierId) { this.tierId = tierId; }

    public int getBenefitOrder() { return benefitOrder; }
    public void setBenefitOrder(int benefitOrder) { this.benefitOrder = benefitOrder; }

    public String getBenefitText() { return benefitText; }
    public void setBenefitText(String benefitText) { this.benefitText = benefitText; }

    public String getBenefitName() { return benefitName; }
    public void setBenefitName(String benefitName) { this.benefitName = benefitName; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PassBenefit)) return false;
        PassBenefit that = (PassBenefit) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
