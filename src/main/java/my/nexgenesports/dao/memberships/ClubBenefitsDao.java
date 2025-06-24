// src/main/java/my/nexgenesports/dao/memberships/ClubBenefitsDao.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.ClubBenefit;
import java.sql.SQLException;
import java.util.List;

public interface ClubBenefitsDao {
    /** Fetch all benefits rows for a given sessionId, in order
     * @param sessionId
     * @return 
     * @throws java.sql.SQLException */
    List<ClubBenefit> findBySessionId(String sessionId) throws SQLException;
}
