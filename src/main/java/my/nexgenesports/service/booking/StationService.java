// src/main/java/my/nexgenesports/service/StationService.java
package my.nexgenesports.service.booking;

import my.nexgenesports.dao.booking.StationDao;
import my.nexgenesports.model.Station;

import java.sql.SQLException;
import java.util.List;
import my.nexgenesports.service.general.ServiceException;

public class StationService {
    private final StationDao dao = new StationDao();

    /** Admin: list all stations
     * @return  */
    public List<Station> listAll() {
        try {
            return dao.listAll();
        } catch (SQLException e) {
            throw new ServiceException("Failed to load gaming stations", e);
        }
    }

    /** Admin: look up one station
     * @param id
     * @return  */
    public Station find(String id) {
        try {
            Station s = dao.findById(id);
            if (s == null) {
                throw new ServiceException("No station with ID: " + id);
            }
            return s;
        } catch (SQLException e) {
            throw new ServiceException("Failed to load station " + id, e);
        }
    }

    /** Admin: create a new station
     * @param s */
    public void create(Station s) {
        try {
            dao.insert(s);
        } catch (SQLException e) {
            throw new ServiceException("Failed to create station " + s.getStationID(), e);
        }
    }

    /** Admin: update an existing station
     * @param s */
    public void update(Station s) {
        try {
            dao.update(s);
        } catch (SQLException e) {
            throw new ServiceException("Failed to update station " + s.getStationID(), e);
        }
    }

    /** Admin: delete a station
     * @param stationID */
    public void delete(String stationID) {
        try {
            dao.delete(stationID);
        } catch (SQLException e) {
            throw new ServiceException("Failed to delete station " + stationID, e);
        }
    }
}
