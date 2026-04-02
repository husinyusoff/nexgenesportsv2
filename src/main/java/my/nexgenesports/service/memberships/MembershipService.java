/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.service.memberships;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import my.nexgenesports.dao.memberships.ClubBenefitsDao;
import my.nexgenesports.dao.memberships.MembershipSessionDao;
import my.nexgenesports.dao.memberships.UserClubMembershipDao;
import my.nexgenesports.model.ClubBenefit;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.UserClubMembership;

public class MembershipService {
    private final UserClubMembershipDao ucmDao = new UserClubMembershipDao();
    private final MembershipSessionDao sessionDao = new MembershipSessionDao();
    private final ClubBenefitsDao clubBenefitsDao = new ClubBenefitsDao();

    public UserClubMembership getCurrentMembership(String userId) throws SQLException {
        UserClubMembership m = this.ucmDao.findLatestByUser(userId);
        if (m != null && "ACTIVE".equals(m.getStatus()) && m.getExpiryDate().isBefore(LocalDateTime.now())) {
            m.setStatus("EXPIRED");
            this.ucmDao.update(m);
        }
        return m;
    }

    public List<MembershipSession> listUpcomingSessions(String userId) throws SQLException {
        UserClubMembership current = this.getCurrentMembership(userId);
        LocalDateTime cutoff = current == null ? LocalDateTime.now() : current.getExpiryDate();
        return this.sessionDao.findUpcomingAfter(cutoff);
    }

    public MembershipSession getActiveSession() throws SQLException {
        return this.sessionDao.findActiveOn(LocalDateTime.now());
    }

    public List<ClubBenefit> listBenefits(String sessionId) throws SQLException {
        return this.clubBenefitsDao.findBySessionId(sessionId);
    }

    public void purchaseMembership(String userId, String sessionId) throws SQLException {
        MembershipSession sess = this.sessionDao.findById(sessionId);
        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDateTime.now());
        m.setExpiryDate(sess.getEndMembershipDate());
        m.setStatus("ACTIVE");
        m.setPaymentReference(null);
        this.ucmDao.insert(m);
    }

    public void updateMembershipRecord(int ucmId, String status, String reference) throws SQLException {
        UserClubMembership m = this.ucmDao.findById(ucmId);
        if (m == null) {
            throw new IllegalArgumentException("No membership with id=" + ucmId);
        }
        m.setStatus(status);
        m.setPaymentReference(reference);
        this.ucmDao.update(m);
    }

    public UserClubMembership createPending(String userId, String sessionId) throws SQLException {
        MembershipSession sess = this.sessionDao.findById(sessionId);
        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDateTime.now());
        m.setExpiryDate(sess.getEndMembershipDate());
        m.setStatus("PENDING");
        m.setPaymentReference(null);
        this.ucmDao.insert(m);
        return m;
    }

    public List<MembershipSession> getAllSessions() throws SQLException {
        return this.sessionDao.findAll();
    }

    public MembershipSession getSessionById(String sessionId) throws SQLException {
        return this.sessionDao.findById(sessionId);
    }

    public void createSession(MembershipSession session) throws SQLException {
        this.sessionDao.insert(session);
    }

    public void updateSession(MembershipSession session) throws SQLException {
        this.sessionDao.update(session);
        this.ucmDao.updateExpiryDatesBySessionId(session.getSessionId(), session.getEndMembershipDate());
    }

    public void deleteSession(String sessionId) throws SQLException {
        this.sessionDao.deleteById(sessionId);
    }

    public List<ClubBenefit> getSessionBenefits(String sessionId) throws SQLException {
        return this.clubBenefitsDao.findBySessionId(sessionId);
    }

    public void addSessionBenefit(String sessionId, String text) throws SQLException {
        int nextOrder = this.clubBenefitsDao.countBySessionId(sessionId) + 1;
        ClubBenefit b = new ClubBenefit();
        b.setSessionId(sessionId);
        b.setBenefitOrder(nextOrder);
        b.setBenefitText(text);
        this.clubBenefitsDao.insert(b);
    }

    public void updateSessionBenefit(int id, String text, int order) throws SQLException {
        ClubBenefit b = new ClubBenefit();
        b.setId(id);
        b.setBenefitText(text);
        b.setBenefitOrder(order);
        this.clubBenefitsDao.update(b);
    }

    public void deleteSessionBenefit(int id) throws SQLException {
        this.clubBenefitsDao.deleteById(id);
    }

    public List<UserClubMembership> getAllUserMemberships() throws SQLException {
        return this.ucmDao.findAll();
    }

    public void adminUpdateMembership(int id, String status, LocalDateTime purchaseDate, LocalDateTime expiryDate, String ref) throws SQLException {
        UserClubMembership m = this.ucmDao.findById(id);
        if (m == null) {
            throw new IllegalArgumentException("No membership with id=" + id);
        }
        m.setStatus(status);
        m.setPurchaseDate(purchaseDate);
        m.setExpiryDate(expiryDate);
        m.setPaymentReference(ref);
        this.ucmDao.update(m);
    }

    public void adminDeleteMembership(int id) throws SQLException {
        this.ucmDao.deleteById(id);
    }

    public void adminGrantMembership(String userId, String sessionId, LocalDateTime expiryDate, String ref) throws SQLException {
        MembershipSession sess = this.sessionDao.findById(sessionId);
        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDateTime.now());
        m.setExpiryDate(expiryDate);
        m.setStatus("ACTIVE");
        m.setPaymentReference(ref != null && !ref.isBlank() ? ref : "ADMIN-GRANT");
        this.ucmDao.insert(m);
    }
}