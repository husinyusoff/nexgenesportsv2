// src/main/java/my/nexgenesports/dao/MembershipSessionDao.java
package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.MembershipSession;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public interface MembershipSessionDao {
    /** Find a session by its ID.
     * @param sessionId
     * @return 
     * @throws java.sql.SQLException */
    MembershipSession findById(String sessionId) throws SQLException;

    /** List all active sessions whose start date is after the given date.
     * @param date
     * @return 
     * @throws java.sql.SQLException */
    List<MembershipSession> findUpcomingAfter(LocalDate date) throws SQLException;
}
