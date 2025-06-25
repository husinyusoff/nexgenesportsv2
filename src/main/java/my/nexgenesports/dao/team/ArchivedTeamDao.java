package my.nexgenesports.dao.team;

import my.nexgenesports.model.ArchivedTeam;
import java.sql.SQLException;

public interface ArchivedTeamDao {
    void insert(ArchivedTeam archived) throws SQLException;
}
