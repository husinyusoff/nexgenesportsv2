package my.nexgenesports.dao.team;

import my.nexgenesports.model.AuditLog;
import java.sql.SQLException;

public interface AuditLogDao {
    void insert(AuditLog log) throws SQLException;
}
