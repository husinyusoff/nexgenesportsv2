package my.nexgenesports.service.programTournament;

import my.nexgenesports.dao.programTournament.GameDao;
import my.nexgenesports.dao.programTournament.GameDaoImpl;
import my.nexgenesports.model.Game;
import my.nexgenesports.service.general.ServiceException;
import java.sql.SQLException;
import java.util.List;

public class GameService {
    private final GameDao dao = new GameDaoImpl();

    public Game createGame(Game g) {
        try {
            dao.insert(g);
            return g;
        } catch (SQLException e) {
            throw new ServiceException("Failed to create game", e);
        }
    }

    public List<Game> listGames() {
        try {
            return dao.listAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed to list games", e);
        }
    }

    public Game find(int id) {
        try {
            Game g = dao.findById(id);
            if (g == null) throw new ServiceException("No game " + id);
            return g;
        } catch (SQLException e) {
            throw new ServiceException("Failed to load game " + id, e);
        }
    }

    public void updateGame(Game g) {
        try {
            dao.update(g);
        } catch (SQLException e) {
            throw new ServiceException("Failed to update game", e);
        }
    }

    public void deleteGame(int id) {
        try {
            dao.softDelete(id);
        } catch (SQLException e) {
            throw new ServiceException("Failed to delete game", e);
        }
    }
}
