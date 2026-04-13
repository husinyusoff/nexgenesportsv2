<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - NexGen Esports</title>
    <style>
        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            transition: color 0.3s ease;
        }
        .password-toggle-btn:hover {
            color: var(--neon-cyan);
        }
        .password-toggle-btn svg {
            position: absolute;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .password-toggle-btn .eye-open {
            opacity: 0;
            transform: scale(0.5) rotate(-45deg);
        }
        .password-toggle-btn .eye-closed {
            opacity: 1;
            transform: scale(1) rotate(0);
        }
        .password-toggle-btn.is-visible .eye-open {
            opacity: 1;
            transform: scale(1) rotate(0);
        }
        .password-toggle-btn.is-visible .eye-closed {
            opacity: 0;
            transform: scale(0.5) rotate(45deg);
        }
    </style>
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
                        <div class="password-toggle-btn" id="togglePassword" aria-label="Toggle password visibility">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-open">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-closed">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                <line x1="1" y1="1" x2="23" y2="23"></line>
                            </svg>
                        </div>
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
                  eyeBtn = document.getElementById('togglePassword');
            
            if (pwd && eyeBtn) {
                eyeBtn.addEventListener('click', () => {
                    const isVisible = pwd.type === 'password';
                    pwd.type = isVisible ? 'text' : 'password';
                    eyeBtn.classList.toggle('is-visible', isVisible);
                    if (isVisible) {
                        eyeBtn.style.color = 'var(--neon-cyan)';
                    } else {
                        eyeBtn.style.color = 'var(--text-muted)';
                    }
                });
            }
        });
    </script>
</body>
</html>
