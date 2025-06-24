package my.nexgenesports.service.memberships;

import my.nexgenesports.dao.memberships.PassTierDao;
import my.nexgenesports.dao.memberships.PassTierDaoImpl;
import my.nexgenesports.dao.memberships.PassBenefitsDao;
import my.nexgenesports.dao.memberships.PassBenefitsDaoImpl;
import my.nexgenesports.dao.memberships.UserGamingPassDao;
import my.nexgenesports.dao.memberships.UserGamingPassDaoImpl;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.model.PassBenefit;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class PassService {

    private final PassTierDao       tierDao    = new PassTierDaoImpl();
    private final PassBenefitsDao   passBenefitsDao = new PassBenefitsDaoImpl();
    private final UserGamingPassDao ugpDao     = new UserGamingPassDaoImpl();

    public List<PassTier> listPassTiers() throws SQLException {
        return tierDao.findAll();
    }

    public UserGamingPass getCurrentPass(String userId) throws SQLException {
        return ugpDao.findLatestByUser(userId);
    }

    public List<PassBenefit> listBenefits(int tierId) throws SQLException {
        return passBenefitsDao.findByTierId(tierId);
    }

    public void purchasePass(String userId, int tierId) throws SQLException {
        PassTier tier = tierDao.findById(tierId);
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiry = now.plusDays(30);

        UserGamingPass p = new UserGamingPass();
        p.setUserId(userId);
        p.setTier(tier);
        p.setPurchaseDate(now);
        p.setExpiryDate(expiry);
        p.setStatus("ACTIVE");
        p.setPaymentReference(null);

        ugpDao.insert(p);
    }

    public UserGamingPass createPending(String userId, int tierId) throws SQLException {
        PassTier tier = tierDao.findById(tierId);

        UserGamingPass p = new UserGamingPass();
        p.setUserId(userId);
        p.setTier(tier);
        p.setPurchaseDate(LocalDateTime.now());
        p.setExpiryDate(LocalDateTime.now().plusDays(30));
        p.setStatus("PENDING");
        p.setPaymentReference(null);

        ugpDao.insert(p);
        return p;
    }

    public void updatePassRecord(int ugpId, String reference, String status) throws SQLException {
        UserGamingPass p = ugpDao.findById(ugpId);
        if (p == null) {
            throw new IllegalArgumentException("No pass with id=" + ugpId);
        }
        p.setPaymentReference(reference);
        p.setStatus(status);
        ugpDao.update(p);
    }
}
