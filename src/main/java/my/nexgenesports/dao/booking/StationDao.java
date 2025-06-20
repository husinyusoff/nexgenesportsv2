// src/main/java/my/nexgenesports/dao/StationDao.java
package my.nexgenesports.dao.booking;

import my.nexgenesports.model.Station;
import my.nexgenesports.util.DBConnection;

import java.sql.*;
import java.util.*;

public class StationDao {
    public List<Station> listAll() throws SQLException {
        String sql = "SELECT * FROM GamingStation";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet r = p.executeQuery())
        {
            List<Station> list = new ArrayList<>();
            while (r.next()) {
                Station s = new Station();
                s.setStationID(r.getString("stationID"));
                s.setStationName(r.getString("stationName"));
                s.setNormalPrice1Player(r.getBigDecimal("normalPrice1Player"));
                s.setNormalPrice2Player(r.getBigDecimal("normalPrice2Player"));
                s.setHappyHourPrice1Player(r.getBigDecimal("happyHourPrice1Player"));
                s.setHappyHourPrice2Player(r.getBigDecimal("happyHourPrice2Player"));
                list.add(s);
            }
            return list;
        }
    }

    public Station findById(String id) throws SQLException {
        String sql = "SELECT * FROM GamingStation WHERE stationID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql))
        {
            p.setString(1, id);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    Station s = new Station();
                    s.setStationID(r.getString("stationID"));
                    s.setStationName(r.getString("stationName"));
                    s.setNormalPrice1Player(r.getBigDecimal("normalPrice1Player"));
                    s.setNormalPrice2Player(r.getBigDecimal("normalPrice2Player"));
                    s.setHappyHourPrice1Player(r.getBigDecimal("happyHourPrice1Player"));
                    s.setHappyHourPrice2Player(r.getBigDecimal("happyHourPrice2Player"));
                    return s;
                }
                return null;
            }
        }
    }

    public void insert(Station s) throws SQLException {
        String sql = "INSERT INTO GamingStation"
                   + "(stationID,stationName,normalPrice1Player,normalPrice2Player,"
                   + " happyHourPrice1Player,happyHourPrice2Player)"
                   + " VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql))
        {
            p.setString(1, s.getStationID());
            p.setString(2, s.getStationName());
            p.setBigDecimal(3, s.getNormalPrice1Player());
            p.setBigDecimal(4, s.getNormalPrice2Player());
            p.setBigDecimal(5, s.getHappyHourPrice1Player());
            p.setBigDecimal(6, s.getHappyHourPrice2Player());
            p.executeUpdate();
        }
    }

    public void update(Station s) throws SQLException {
        String sql = "UPDATE GamingStation SET stationName=?,"
                   + " normalPrice1Player=?, normalPrice2Player=?,"
                   + " happyHourPrice1Player=?, happyHourPrice2Player=?"
                   + " WHERE stationID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql))
        {
            p.setString(1, s.getStationName());
            p.setBigDecimal(2, s.getNormalPrice1Player());
            p.setBigDecimal(3, s.getNormalPrice2Player());
            p.setBigDecimal(4, s.getHappyHourPrice1Player());
            p.setBigDecimal(5, s.getHappyHourPrice2Player());
            p.setString(6, s.getStationID());
            p.executeUpdate();
        }
    }

    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM GamingStation WHERE stationID=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql))
        {
            p.setString(1, id);
            p.executeUpdate();
        }
    }
}
