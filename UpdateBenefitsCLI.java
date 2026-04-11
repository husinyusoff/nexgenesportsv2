import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UpdateBenefitsCLI {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/trial_nexgenesports?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String pass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                
                String activeSessionId = "ESUMT_26/27"; 
                String sqlActiveSessionId = "SELECT sessionId FROM membershipsessions WHERE is_active = 1 LIMIT 1";
                try (PreparedStatement ps = conn.prepareStatement(sqlActiveSessionId);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        activeSessionId = rs.getString("sessionId");
                    }
                }
                
                System.out.println("Target Session: " + activeSessionId);
                
                String deleteSql = "DELETE FROM club_benefits WHERE sessionId = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                    ps.setString(1, activeSessionId);
                    int rowsDeleted = ps.executeUpdate();
                    System.out.println("Deleted " + rowsDeleted + " existing benefits.");
                }
                
                String[] newBenefits = {
                    "Eligible to nominate oneself for the Esports Club Executive Council (Session 24/25).",
                    "Eligible to vote for Supreme Council nominations.",
                    "Membership in the Game Community.",
                    "Opportunity to represent the UMT Esports Club in external tournaments.",
                    "Access to training and scrims platform.",
                    "Member pricing for all programs and major tournaments organized by the UMT Esports Club.",
                    "Opportunity to become a committee member (AJK) in programs organized by the UMT Esports Club.",
                    "Exclusive access and privileges to the Esports Gaming Room."
                };
                
                String insertSql = "INSERT INTO club_benefits (sessionId, benefitOrder, benefitText) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    for (int i = 0; i < newBenefits.length; i++) {
                        ps.setString(1, activeSessionId);
                        ps.setInt(2, i + 1);
                        ps.setString(3, newBenefits[i]);
                        ps.addBatch();
                    }
                    int[] rowsInserted = ps.executeBatch();
                    System.out.println("Inserted " + rowsInserted.length + " new benefits successfully.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
