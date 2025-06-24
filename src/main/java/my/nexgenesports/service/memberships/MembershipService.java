package my.nexgenesports.service.memberships;

import my.nexgenesports.dao.memberships.ClubBenefitsDao;
import my.nexgenesports.dao.memberships.ClubBenefitsDaoImpl;
import my.nexgenesports.dao.memberships.MembershipSessionDao;
import my.nexgenesports.dao.memberships.MembershipSessionDaoImpl;
import my.nexgenesports.dao.memberships.UserClubMembershipDao;
import my.nexgenesports.dao.memberships.UserClubMembershipDaoImpl;
import my.nexgenesports.model.ClubBenefit;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.UserClubMembership;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class MembershipService {

    private final UserClubMembershipDao ucmDao          = new UserClubMembershipDaoImpl();
    private final MembershipSessionDao  sessionDao      = new MembershipSessionDaoImpl();
    private final ClubBenefitsDao       clubBenefitsDao = new ClubBenefitsDaoImpl();

    public UserClubMembership getCurrentMembership(String userId) throws SQLException {
        return ucmDao.findLatestByUser(userId);
    }

    public List<MembershipSession> listUpcomingSessions(String userId) throws SQLException {
        UserClubMembership current = getCurrentMembership(userId);
        LocalDateTime cutoff = (current == null)
                ? LocalDateTime.now()
                : current.getExpiryDate();
        return sessionDao.findUpcomingAfter(cutoff);
    }

    public MembershipSession getActiveSession() throws SQLException {
        return sessionDao.findActiveOn(LocalDateTime.now());
    }

    public List<ClubBenefit> listBenefits(String sessionId) throws SQLException {
        return clubBenefitsDao.findBySessionId(sessionId);
    }

    public void purchaseMembership(String userId, String sessionId) throws SQLException {
        MembershipSession sess = sessionDao.findById(sessionId);
        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDateTime.now());
        m.setExpiryDate(sess.getEndMembershipDate());
        m.setStatus("ACTIVE");
        m.setPaymentReference(null);
        ucmDao.insert(m);
    }

    public void updateMembershipRecord(int ucmId, String status, String reference) throws SQLException {
        UserClubMembership m = ucmDao.findById(ucmId);
        if (m == null) {
            throw new IllegalArgumentException("No membership with id=" + ucmId);
        }
        m.setStatus(status);
        m.setPaymentReference(reference);
        ucmDao.update(m);
    }

    public UserClubMembership createPending(String userId, String sessionId) throws SQLException {
        MembershipSession sess = sessionDao.findById(sessionId);
        UserClubMembership m = new UserClubMembership();
        m.setUserId(userId);
        m.setSession(sess);
        m.setPurchaseDate(LocalDateTime.now());
        m.setExpiryDate(sess.getEndMembershipDate());
        m.setStatus("PENDING");
        m.setPaymentReference(null);
        ucmDao.insert(m);
        return m;
    }
}
