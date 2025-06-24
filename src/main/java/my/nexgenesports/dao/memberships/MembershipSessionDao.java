package my.nexgenesports.dao.memberships;

import my.nexgenesports.model.MembershipSession;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public interface MembershipSessionDao {
    MembershipSession findById(String sessionId) throws SQLException;
    List<MembershipSession> findUpcomingAfter(LocalDateTime dateTime) throws SQLException;
    MembershipSession findActiveOn(LocalDateTime dateTime) throws SQLException;
}
