// src/main/java/my/nexgenesports/service/MembershipService.java
package my.nexgenesports.service.memberships;

import my.nexgenesports.dao.memberships.UserClubMembershipDao;
import my.nexgenesports.dao.memberships.UserClubMembershipDaoImpl;
import my.nexgenesports.dao.memberships.MembershipSessionDao;
import my.nexgenesports.dao.memberships.MembershipSessionDaoImpl;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.UserClubMembership;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class MembershipService {

    // ← Declare your DAOs here
    private final UserClubMembershipDao ucmDao = new UserClubMembershipDaoImpl();
    private final MembershipSessionDao sessionDao = new MembershipSessionDaoImpl();

    /**
     * Returns the user’s current active club membership, or null if none
     *
     * @param userId
     * @return
     * @throws java.sql.SQLException
     */
    public UserClubMembership getCurrentMembership(String userId) throws SQLException {
        return ucmDao.findLatestByUser(userId);
    }

    /**
     * Returns upcoming sessions after the user’s current expiry (or today if
     * none)
     *
     * @param userId
     * @return
     * @throws java.sql.SQLException
     */
    public List<MembershipSession> listUpcomingSessions(String userId) throws SQLException {
        UserClubMembership current = getCurrentMembership(userId);
        LocalDate cutoff = (current == null)
                ? LocalDate.now()
                : current.getExpiryDate();
        return sessionDao.findUpcomingAfter(cutoff);
    }

    /**
     * Purchases a new club session: looks up the session, builds a
     * UserClubMembership, and inserts it (status=ACTIVE, paymentReference left
     * null here).
     *
     * @param userId
     * @param sessionId
     * @throws java.sql.SQLException
     */
    public void purchaseMembership(String userId, String sessionId) throws SQLException {
        MembershipSession sess = sessionDao.findById(sessionId);
        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDate.now());
        m.setExpiryDate(sess.getEndMembershipDate());
        m.setStatus("ACTIVE");
        m.setPaymentReference(null);
        ucmDao.insert(m);
    }

    /**
     * **NEW**: Update an existing club‐membership record with payment status &
     * reference.
     *
     * @param ucmId the userclubmemberships.id
     * @param status e.g. "ACTIVE" or "CANCELLED"
     * @param reference external payment reference
     * @throws java.sql.SQLException
     */
    public void updateMembershipRecord(int ucmId,
            String status,
            String reference)
            throws SQLException {
        UserClubMembership m = ucmDao.findById(ucmId);
        if (m == null) {
            throw new IllegalArgumentException("No membership with id=" + ucmId);
        }
        m.setStatus(status);
        m.setPaymentReference(reference);
        ucmDao.update(m);
    }

    /**
     * Create a PENDING membership record so we have an ID for payment.     *
     * @param userId
     * @param sessionId
     * @return the newly‐inserted record, with its generated id set
     * @throws java.sql.SQLException
     */
    public UserClubMembership createPending(String userId, String sessionId)
            throws SQLException {
        MembershipSession sess = sessionDao.findById(sessionId);

        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDate.now());
        m.setExpiryDate(sess.getEndMembershipDate());
        m.setStatus("PENDING");
        m.setPaymentReference(null);

        ucmDao.insert(m);
        return m;
    }

}
