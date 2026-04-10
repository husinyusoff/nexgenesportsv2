import my.nexgenesports.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class UpdateDb {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            s.executeUpdate("UPDATE GamingStation SET stationName='PlayStation 5 (A) (PS5-01)' WHERE stationID='PS5A'");
            s.executeUpdate("UPDATE GamingStation SET stationID='PS5-01' WHERE stationID='PS5A'");
            
            s.executeUpdate("INSERT IGNORE INTO GamingStation (stationID, stationName, normalPrice1Player, normalPrice2Player, happyHourPrice1Player, happyHourPrice2Player) VALUES ('PS5-02', 'PlayStation 5 (B) (PS5-02)', 6.00, 10.00, 5.00, 8.00)");
            
            s.executeUpdate("UPDATE GamingStation SET stationName='Racing Simulator (RS01)' WHERE stationID='RSM'");
            s.executeUpdate("UPDATE GamingStation SET stationID='RS01' WHERE stationID='RSM'");
            
            s.executeUpdate("DELETE FROM GamingStation WHERE stationID='PS4' OR stationID='PS5B'");
            System.out.println("DB Updated Successfully!");
        } catch(Exception e){
            e.printStackTrace();
        }
    }
}
