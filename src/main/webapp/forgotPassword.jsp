<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - NexGen Esports</title>
</head>
<body class="auth-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <div class="content">
            <div class="auth-box glass-card">
                <h2>FORGOT PASSWORD</h2>
                <p style="color: var(--text-muted); text-align: center; margin-bottom: 25px; font-size: 0.95rem;">
                    Enter your registered email address and we'll send you a password reset link.
                </p>

                <% if (request.getAttribute("successMsg") != null) { %>
                    <div style="color:var(--neon-cyan); text-align:center; margin-bottom: 20px; padding: 12px; border: 1px solid var(--neon-cyan); border-radius: 8px; background: rgba(0,229,255,0.1); font-weight: 600;">
                        <%= request.getAttribute("successMsg") %>
                    </div>
                <% } %>
                <% if (request.getAttribute("errorMsg") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("errorMsg") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth?action=forgotPassword" method="post">
                    <label class="label" for="email">Email Address</label>
                    <input class="input-field" type="email" id="email" name="email" required
                           placeholder="your.email@student.umt.edu.my">

                    <button class="btn btn-primary btn-block" type="submit">Send Reset Link</button>

                    <div class="auth-links" style="justify-content: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/login.jsp">Back to Login</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>
