package my.nexgenesports.dao.programTournament;

import my.nexgenesports.model.Game;
import java.sql.SQLException;
import java.util.List;

public interface GameDao {
    int insert(Game game) throws SQLException;
    Game findById(int id) throws SQLException;
    List<Game> listAll() throws SQLException;
    void update(Game game) throws SQLException;
    void softDelete(int id) throws SQLException;
}
