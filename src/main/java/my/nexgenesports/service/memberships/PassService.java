/*
 * Decompiled with CFR 0.152.
 */
package my.nexgenesports.service.memberships;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import my.nexgenesports.dao.memberships.PassBenefitsDao;
import my.nexgenesports.dao.memberships.PassTierDao;
import my.nexgenesports.dao.memberships.UserGamingPassDao;
import my.nexgenesports.model.PassBenefit;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserGamingPass;

public class PassService {
    private final PassTierDao tierDao = new PassTierDao();
    private final PassBenefitsDao passBenefitsDao = new PassBenefitsDao();
    private final UserGamingPassDao ugpDao = new UserGamingPassDao();

    public List<PassTier> listPassTiers() throws SQLException {
        return this.tierDao.findAll();
    }

    public UserGamingPass getCurrentPass(String userId) throws SQLException {
        UserGamingPass p = this.ugpDao.findLatestByUser(userId);
        if (p != null && "ACTIVE".equals(p.getStatus()) && p.getExpiryDate().isBefore(LocalDateTime.now())) {
            p.setStatus("EXPIRED");
            this.ugpDao.update(p);
        }
        return p;
    }

    public List<PassBenefit> listBenefits(int tierId) throws SQLException {
        return this.passBenefitsDao.findByTierId(tierId);
    }

    public void purchasePass(String userId, int tierId) throws SQLException {
        PassTier tier = this.tierDao.findById(tierId);
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiry = now.plusDays(30L);
        UserGamingPass p = new UserGamingPass();
        p.setUserId(userId);
        p.setTier(tier);
        p.setPurchaseDate(now);
        p.setExpiryDate(expiry);
        p.setStatus("ACTIVE");
        p.setPaymentReference(null);
        this.ugpDao.insert(p);
    }

    public UserGamingPass createPending(String userId, int tierId) throws SQLException {
        PassTier tier = this.tierDao.findById(tierId);
        LocalDateTime now = LocalDateTime.now();
        UserGamingPass p = new UserGamingPass();
        p.setUserId(userId);
        p.setTier(tier);
        p.setPurchaseDate(now);
        p.setExpiryDate(now.plusDays(30L));
        p.setStatus("PENDING");
        p.setPaymentReference(null);
        this.ugpDao.insert(p);
        return p;
    }

    public void updatePassRecord(int ugpId, String reference, String status) throws SQLException {
        UserGamingPass p = this.ugpDao.findById(ugpId);
        if (p == null) {
            throw new IllegalArgumentException("No pass with id=" + ugpId);
        }
        p.setPaymentReference(reference);
        p.setStatus(status);
        this.ugpDao.update(p);
    }

    public List<PassTier> getAllTiers() throws SQLException {
        return this.tierDao.findAll();
    }

    public PassTier getTierById(int tierId) throws SQLException {
        return this.tierDao.findById(tierId);
    }

    public void createTier(PassTier tier) throws SQLException {
        this.tierDao.insert(tier);
    }

    public void updateTier(PassTier tier) throws SQLException {
        this.tierDao.update(tier);
    }

    public void deleteTier(int tierId) throws SQLException {
        this.tierDao.deleteById(tierId);
    }

    public List<PassBenefit> getTierBenefits(int tierId) throws SQLException {
        return this.passBenefitsDao.findByTierId(tierId);
    }

    public void addTierBenefit(int tierId, String name, String text) throws SQLException {
        int nextOrder = this.passBenefitsDao.countByTierId(tierId) + 1;
        PassBenefit b = new PassBenefit();
        b.setTierId(tierId);
        b.setBenefitOrder(nextOrder);
        b.setBenefitName(name);
        b.setBenefitText(text);
        this.passBenefitsDao.insert(b);
    }

    public void updateTierBenefit(int id, String name, String text, int order) throws SQLException {
        PassBenefit b = new PassBenefit();
        b.setId(id);
        b.setBenefitName(name);
        b.setBenefitText(text);
        b.setBenefitOrder(order);
        this.passBenefitsDao.update(b);
    }

    public void deleteTierBenefit(int id) throws SQLException {
        this.passBenefitsDao.deleteById(id);
    }

    public void updateBenefitText(int id, String newText) throws SQLException {
        this.passBenefitsDao.updateText(id, newText);
    }

    public List<UserGamingPass> getAllUserPasses() throws SQLException {
        return this.ugpDao.findAll();
    }

    public void adminUpdatePass(int id, int tierId, String status, LocalDateTime purchaseDate, LocalDateTime expiryDate, String ref) throws SQLException {
        UserGamingPass p = this.ugpDao.findById(id);
        if (p == null) {
            throw new IllegalArgumentException("No pass with id=" + id);
        }
        PassTier tier = this.tierDao.findById(tierId);
        p.setTier(tier);
        p.setStatus(status);
        p.setPurchaseDate(purchaseDate);
        p.setExpiryDate(expiryDate);
        p.setPaymentReference(ref);
        this.ugpDao.update(p);
    }

    public void adminDeletePass(int id) throws SQLException {
        this.ugpDao.deleteById(id);
    }

    public void adminGrantPass(String userId, int tierId, LocalDateTime expiryDate, String ref) throws SQLException {
        PassTier tier = this.tierDao.findById(tierId);
        UserGamingPass p = new UserGamingPass();
        p.setUserId(userId);
        p.setTier(tier);
        p.setPurchaseDate(LocalDateTime.now());
        p.setExpiryDate(expiryDate);
        p.setStatus("ACTIVE");
        p.setPaymentReference(ref != null && !ref.isBlank() ? ref : "ADMIN-GRANT");
        this.ugpDao.insert(p);
    }
}