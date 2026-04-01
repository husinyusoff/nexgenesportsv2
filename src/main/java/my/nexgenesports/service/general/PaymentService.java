// File: src/main/java/my/nexgenesports/service/general/PaymentService.java
package my.nexgenesports.service.general;

import my.nexgenesports.service.booking.BookingService;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;
import my.nexgenesports.service.programTournament.ParticipantService;

import java.math.BigDecimal;
import java.sql.SQLException;

/**
 * Central payment orchestration.
 */
public class PaymentService {

    private final BookingService     bookingSvc    = new BookingService();
    private final MembershipService  membershipSvc = new MembershipService();
    private final PassService        passSvc       = new PassService();
    private final ParticipantService partSvc       = new ParticipantService();

    /** Toggle this to `false` once you wire up a real gateway. */
    private final boolean simulate = true;

    /**
     * Kick off a payment.
     */
    public String createCharge(String module, int id, BigDecimal amount) {
        if (simulate) {
            String reference = "SIM-" + System.currentTimeMillis();
            return "/paymentCallback"
                + "?module="    + module
                + "&id="        + id
                + "&paid=true"
                + "&reference=" + reference;
        }
        throw new UnsupportedOperationException("Real gateway not yet implemented");
    }

    /**
     * Handle the gateway callback.
     * @param module
     * @param id
     * @param paid
     * @param reference
     * @throws java.sql.SQLException
     */
    public void handleCallback(String module,
                               int id,
                               boolean paid,
                               String reference)
            throws SQLException
    {
        if (module == null) {
            throw new IllegalArgumentException("Unknown module: " + module);
        }

        switch (module) {
            case "booking" -> {
                bookingSvc.updatePaymentStatus(
                    id,
                    paid ? "PAID" : "FAILED",
                    paid ? Integer.valueOf(reference.replace("SIM-", "")) : null
                );
            }
            case "membership" -> {
                String status = paid ? "ACTIVE" : "CANCELLED";
                membershipSvc.updateMembershipRecord(id, status, reference);
            }
            case "pass" -> {
                String status = paid ? "ACTIVE" : "CANCELLED";
                passSvc.updatePassRecord(id, reference, status);
            }
            case "program", "tournament" -> {
                // batch‐update all participants (solo or team) in that group
                partSvc.finalizeRegistration(id, paid, reference);
            }
            default -> throw new IllegalArgumentException("Unknown module: " + module);
        }
    }
}
