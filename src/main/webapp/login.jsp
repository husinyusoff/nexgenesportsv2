<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - NexGen Esports</title>
</head>
<body>
    <t:AppShell cssClass="auth-wrapper" hideSidebar="true">
        <t:GlassCard cssClass="auth-box">
            <h2 style="text-align: center; margin-bottom: 24px; color: var(--text-primary); font-family: var(--font-heading); text-transform: uppercase;">LOGIN</h2>
            
            <c:if test="${param.error == 'badcreds'}">
                <t:Alert variant="danger">Invalid user ID, password or role.</t:Alert>
            </c:if>
            <c:if test="${param.status == 'passwordReset'}">
                <t:Alert variant="success">Password reset successful! You can now login with your new password.</t:Alert>
             </c:if>
            <c:if test="${param.status == 'sessionExpired'}">
                <t:Alert variant="danger">Your session has expired due to inactivity. Please log in again.</t:Alert>
            </c:if>

            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <div class="roles-grid" style="margin-bottom: 24px;">
                    <label class="role-pill">
                        <input type="radio" name="selectedRole" value="athlete" checked> 
                        <span>Athlete</span>
                    </label>
                    <label class="role-pill">
                        <input type="radio" name="selectedRole" value="referee"> 
                        <span>Referee</span>
                    </label>
                    <label class="role-pill">
                        <input type="radio" name="selectedRole" value="executive_council"> 
                        <span>Exec Council</span>
                    </label>
                    <label class="role-pill">
                        <input type="radio" name="selectedRole" value="high_council"> 
                        <span>High Council</span>
                    </label>
                </div>

                <t:Field id="userID" label="User ID" required="true">
                    <input class="input-field" type="text" id="userID" name="userID" required placeholder="Enter User ID">
                </t:Field>

                <t:Field id="password" label="Password" required="true">
                    <div class="password-wrapper" style="position: relative;">
                        <input class="input-field" style="width: 100%; padding-right: 40px;" type="password" id="password" name="password" required placeholder="••••••••">
                        <span class="eye-icon" id="togglePassword" style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);">👁</span>
                    </div>
                </t:Field>

                <div style="margin-top: 30px;">
                    <t:Button variant="primary" type="submit" cssClass="w-100" style="width: 100%;">Login</t:Button>
                </div>
                
                <div class="auth-links" style="margin-top: 20px; display: flex; justify-content: space-between; font-size: 0.85rem;">
                    <a href="${pageContext.request.contextPath}/register.jsp" style="color: var(--neon-cyan); transition: var(--transition);">Don't have an account? Sign Up</a>
                    <a href="${pageContext.request.contextPath}/forgotPassword.jsp" style="color: var(--neon-cyan); transition: var(--transition);">Forgot password?</a>
                </div>
            </form>
        </t:GlassCard>
    </t:AppShell>

    <!-- Password “reveal” script -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const pwd = document.getElementById('password'),
                  eye = document.getElementById('togglePassword');
            
            if (pwd && eye) {
                let isVisible = false;
                eye.addEventListener('click', () => {
                    isVisible = !isVisible;
                    pwd.type = isVisible ? 'text' : 'password';
                    eye.style.color = isVisible ? '#00e5ff' : '#a0a0ab';
                });
            }
        });
    </script>
</body>
</html>
