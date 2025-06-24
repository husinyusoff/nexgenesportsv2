// src/main/java/my/nexgenesports/dao/memberships/PassBenefitsDao.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.PassBenefit;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO for fetching the ordered list of benefits for a given pass tier.
 */
public interface PassBenefitsDao {
    /**
     * Returns all PassBenefit rows for the given tierId, ordered by benefitOrder.
     * @param tierId
     * @return 
     * @throws java.sql.SQLException
     */
    List<PassBenefit> findByTierId(int tierId) throws SQLException;
}
