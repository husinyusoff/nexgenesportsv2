import java.sql.*;

public class InitBusinessConfig {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/trial_nexgenesports";
        String user = "root";
        String pass = "";

        // Ensure driver resolves
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {}

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            Statement stmt = con.createStatement();
            
            // We use simple REPLACE INTO or duplicate key update
            String[] queries = {
                "CREATE TABLE IF NOT EXISTS business_config (config_key VARCHAR(50) PRIMARY KEY, config_value INT) ENGINE=InnoDB;",
                "REPLACE INTO business_config (config_key, config_value) VALUES ('weekday_open', 14);",
                "REPLACE INTO business_config (config_key, config_value) VALUES ('weekend_open', 15);",
                "REPLACE INTO business_config (config_key, config_value) VALUES ('closing_hour', 23);",
                "REPLACE INTO business_config (config_key, config_value) VALUES ('happy_start_offset', 0);",
                "REPLACE INTO business_config (config_key, config_value) VALUES ('happy_end_hour', 19);"
            };

            for (String q : queries) {
                stmt.executeUpdate(q);
                System.out.println("Executed: " + q);
            }
            System.out.println("Config updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
