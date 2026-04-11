<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="my.nexgenesports.util.DBConnection" %>
<%
    out.println("Updating benefits...<br/>");
    try (Connection conn = DBConnection.getConnection()) {
        // Find existing session list
        String activeSessionId = "ESUMT_26/27"; 
        
        String sqlActiveSessionId = "SELECT sessionId FROM admin_settings LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sqlActiveSessionId);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                activeSessionId = rs.getString("sessionId");
            }
        }
        
        out.println("Target Session: " + activeSessionId + "<br/>");
        
        // Delete existing
        String deleteSql = "DELETE FROM club_benefits WHERE sessionId = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
            ps.setString(1, activeSessionId);
            int rowsDeleted = ps.executeUpdate();
            out.println("Deleted " + rowsDeleted + " existing benefits.<br/>");
        }
        
        // Insert new ones
        String[] newBenefits = {
            "Eligible to nominate oneself for the Esports Club Executive Council.",
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
            out.println("Inserted " + rowsInserted.length + " new benefits successfully.<br/>");
        }
        
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    }
%>
