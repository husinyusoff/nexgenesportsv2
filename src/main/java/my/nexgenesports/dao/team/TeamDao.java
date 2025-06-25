package my.nexgenesports.dao.team;

import my.nexgenesports.model.Team;
import java.sql.SQLException;
import java.util.List;

public interface TeamDao {

    Team insert(Team team) throws SQLException;
    Team findById(int teamID) throws SQLException;
    List<Team> findByMember(String userID) throws SQLException;
    List<Team> findAllActive() throws SQLException;
    void delete(int teamID) throws SQLException;  // used when disbanding
    void updateCapacity(int teamID, int capacity) throws SQLException;
    List<Team> findAllActiveSorted(String sortBy, String direction) throws SQLException;
}
