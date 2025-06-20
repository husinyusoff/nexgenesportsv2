// src/main/java/my/nexgenesports/dao/PassTierDao.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.PassTier;
import java.sql.SQLException;
import java.util.List;

public interface PassTierDao {
    /** List all pass tiers in ascending tierId order.
     * @return 
     * @throws java.sql.SQLException */
    List<PassTier> findAll() throws SQLException;

    /** Find a specific pass tier by its ID.
     * @param tierId
     * @return 
     * @throws java.sql.SQLException */
    PassTier findById(int tierId) throws SQLException;
}
