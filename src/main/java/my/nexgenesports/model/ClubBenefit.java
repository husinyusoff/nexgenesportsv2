package my.nexgenesports.model;

import java.util.Objects;

public class ClubBenefit {
    private int    id;
    private String sessionId;
    private int    benefitOrder;
    private String benefitText;

    public ClubBenefit() {}

    public ClubBenefit(int id, String sessionId, int benefitOrder, String benefitText) {
        this.id            = id;
        this.sessionId     = sessionId;
        this.benefitOrder  = benefitOrder;
        this.benefitText   = benefitText;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public int getBenefitOrder() { return benefitOrder; }
    public void setBenefitOrder(int benefitOrder) { this.benefitOrder = benefitOrder; }

    public String getBenefitText() { return benefitText; }
    public void setBenefitText(String benefitText) { this.benefitText = benefitText; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ClubBenefit)) return false;
        ClubBenefit that = (ClubBenefit) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
