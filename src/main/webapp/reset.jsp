<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="my.nexgenesports.util.DBConnection" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
    String newPassword = "password123";
    String targetUser = "husinyusoff";
    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(10));
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement("UPDATE users SET password_hash = ? WHERE userID = ?")) {
        
        stmt.setString(1, hashed);
        stmt.setString(2, targetUser);
        
        int updated = stmt.executeUpdate();
        
        if (updated > 0) {
            out.println("<h3>Success! User '" + targetUser + "' has been updated.</h3>");
            out.println("<p>Your new password is: <b>" + newPassword + "</b></p>");
            out.println("<a href='login.jsp'>Return to Login</a>");
        } else {
            out.println("<h3>Error: Could not find user '" + targetUser + "'.</h3>");
        }
    } catch (Exception e) {
        out.println("<h3>Database Error!</h3>");
        out.println("<pre>" + e.getMessage() + "</pre>");
    }
%>
