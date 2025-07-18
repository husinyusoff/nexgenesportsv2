// src/main/java/my/nexgenesports/service/general/PaymentService.java
package my.nexgenesports.service.general;

import my.nexgenesports.service.booking.BookingService;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;

import java.math.BigDecimal;
import java.sql.SQLException;

public class PaymentService {
    private final BookingService    bookingSvc    = new BookingService();
    private final MembershipService membershipSvc = new MembershipService();
    private final PassService       passSvc       = new PassService();

    /** Local test mode – flips to real gateway when you implement it */
    private final boolean simulate = true;

    /**
     * Kick off a payment: returns the URL to redirect the user to.
     * @param module  "booking", "membership" or "pass"
     * @param id      primary key of the record being paid
     * @param amount  how much to charge
     * @return redirect URL
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
     * Callback entrypoint: flips statuses or records references.
     * @param module    "booking", "membership" or "pass"
     * @param id        primary key (bookingID, ucm.id, ugp.id)
     * @param paid      true if payment succeeded
     * @param reference external reference string
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
                // NEW: flip pass status too
                String status = paid ? "ACTIVE" : "CANCELLED";
                passSvc.updatePassRecord(id, reference, status);
            }
            default -> throw new IllegalArgumentException("Unknown module: " + module);
        }
    }
}
