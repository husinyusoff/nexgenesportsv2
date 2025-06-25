package my.nexgenesports.dao.team;

import my.nexgenesports.model.AuditLog;
import my.nexgenesports.util.DBConnection;

import java.sql.*;

public class AuditLogDaoImpl implements AuditLogDao {

    @Override
    public void insert(AuditLog log) throws SQLException {
        String sql = """
            INSERT INTO auditlog
              (entityType, entityID, actionType, performedBy, ts, details)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString (1, log.getEntityType());
            ps.setString (2, log.getEntityID());
            ps.setString (3, log.getActionType());
            ps.setString (4, log.getPerformedBy());
            ps.setTimestamp(5, Timestamp.valueOf(log.getTs()));
            if (log.getDetails() != null) {
                ps.setString(6, log.getDetails());
            } else {
                ps.setNull(6, Types.LONGVARCHAR);
            }

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    log.setLogID(keys.getLong(1));
                }
            }
        }
    }
}
