package my.nexgenesports;

import my.nexgenesports.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class CheckDB {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            try {
                s.executeUpdate("ALTER TABLE gamingstationbooking ADD COLUMN paymentDeadline DATETIME");
                System.out.println("Added paymentDeadline to gamingstationbooking");
            } catch (Exception e) { System.out.println("gamingstationbooking: " + e.getMessage()); }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
