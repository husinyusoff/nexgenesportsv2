// src/main/java/my/nexgenesports/service/PassService.java
package my.nexgenesports.service.memberships;

import my.nexgenesports.dao.memberships.PassTierDao;
import my.nexgenesports.dao.memberships.PassTierDaoImpl;
import my.nexgenesports.dao.memberships.UserGamingPassDao;
import my.nexgenesports.dao.memberships.UserGamingPassDaoImpl;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserGamingPass;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class PassService {
    private final PassTierDao       tierDao = new PassTierDaoImpl();
    private final UserGamingPassDao ugpDao  = new UserGamingPassDaoImpl();

    /** List all available pass tiers (Essential, Extra, Premium…)
     * @return 
     * @throws java.sql.SQLException */
    public List<PassTier> listPassTiers() throws SQLException {
        return tierDao.findAll();
    }

    /** Get the user’s current active pass (or null if none)
     * @param userId
     * @return 
     * @throws java.sql.SQLException */
    public UserGamingPass getCurrentPass(String userId) throws SQLException {
        return ugpDao.findLatestByUser(userId);
    }

    /**
     * Purchases (or renews) the monthly pass:
     * looks up the tier, creates a UserGamingPass with 30-day expiry,
     * and inserts it.
     * @param userId
     * @param tierId
     * @throws java.sql.SQLException
     */
    public void purchasePass(String userId, int tierId) throws SQLException {
        PassTier tier = tierDao.findById(tierId);
        LocalDate today  = LocalDate.now();
        LocalDate expiry = today.plusDays(30);

        UserGamingPass p = new UserGamingPass();
        p.setUserId(userId);
        p.setTier(tier);
        p.setPurchaseDate(today);
        p.setExpiryDate(expiry);

        ugpDao.insert(p);
    }

    /**
     * **NEW**: Called on payment callback to record the reference (and optionally flip status).
     *
     * @param ugpId      the usergamingpasses.id
     * @param reference  external payment reference
     * @throws java.sql.SQLException
     */
    public void updatePassRecord(int ugpId, String reference) throws SQLException {
        UserGamingPass p = ugpDao.findById(ugpId);
        if (p == null) {
            throw new IllegalArgumentException("No pass with id=" + ugpId);
        }
        // ensure your UserGamingPass model has this setter:
        p.setPaymentReference(reference);
        ugpDao.update(p);
    }
    
/**
 * Create a PENDING pass record so we have an ID for payment.
     * @param userId
     * @param tierId
 * @return the newly‐inserted record, with its generated id set
     * @throws java.sql.SQLException
 */
public UserGamingPass createPending(String userId, int tierId) 
        throws SQLException {
    PassTier tier = tierDao.findById(tierId);

    UserGamingPass p = new UserGamingPass();
    p.setUserId(userId);
    p.setTier(tier);
    p.setPurchaseDate(LocalDate.now());
    p.setExpiryDate(LocalDate.now().plusDays(30));
    p.setPaymentReference(null);

    ugpDao.insert(p);      // DAO fills p.id from generated keys
    return p;
}
}
