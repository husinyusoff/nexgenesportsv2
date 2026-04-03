<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - NexGen Esports</title>
</head>
<body>
    <t:AppShell cssClass="auth-wrapper" hideSidebar="true">
        <t:GlassCard cssClass="auth-box">
            <h2 style="text-align: center; margin-bottom: 24px; color: var(--text-primary); font-family: var(--font-heading); text-transform: uppercase;">FORGOT PASSWORD</h2>
            <p style="color: var(--text-muted); text-align: center; margin-bottom: 25px; font-size: 0.95rem;">
                Enter your registered email address and we'll send you a password reset link.
            </p>

            <% if (request.getAttribute("successMsg") != null) { %>
                <t:Alert variant="success"><%= request.getAttribute("successMsg") %></t:Alert>
            <% } %>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <t:Alert variant="danger"><%= request.getAttribute("errorMsg") %></t:Alert>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth?action=forgotPassword" method="post">
                <t:Field id="email" label="Email Address" required="true">
                    <input class="input-field" type="email" id="email" name="email" required
                           placeholder="your.email@student.umt.edu.my">
                </t:Field>

                <div style="margin-top: 30px;">
                    <t:Button variant="primary" type="submit" cssClass="w-100" style="width: 100%;">Send Reset Link</t:Button>
                </div>

                <div class="auth-links" style="justify-content: center; margin-top: 20px; font-size: 0.85rem;">
                    <a href="${pageContext.request.contextPath}/login.jsp" style="color: var(--neon-cyan); transition: var(--transition);">Back to Login</a>
                </div>
            </form>
        </t:GlassCard>
    </t:AppShell>
</body>
</html>
