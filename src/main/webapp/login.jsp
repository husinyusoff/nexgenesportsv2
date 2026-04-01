<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - NexGen Esports</title>
</head>
<body class="auth-wrapper">
    <!-- Header -->
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <!-- Main content -->
        <div class="content">
            <div class="auth-box glass-card">
                <h2>LOGIN</h2>
                <% if ("badcreds".equals(request.getParameter("error"))) { %>
                    <div class="error-msg">Invalid user ID, password or role.</div>
                <% } %>
                <% if ("passwordReset".equals(request.getParameter("status"))) { %>
                    <div style="color:var(--neon-cyan); text-align:center; margin-bottom: 20px; padding: 10px; border: 1px solid var(--neon-cyan); border-radius: 8px; background: rgba(0,229,255,0.1);">
                        Password reset successful! You can now login with your new password.
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                    <div class="roles-grid">
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

                    <label class="label" for="userID">User ID</label>
                    <input class="input-field" type="text" id="userID" name="userID" required placeholder="Enter User ID">

                    <label class="label" for="password">Password</label>
                    <div class="password-wrapper">
                        <input class="input-field" type="password" id="password" name="password" required placeholder="••••••••">
                        <span class="eye-icon" id="togglePassword">👁</span>
                    </div>

                    <button class="btn btn-primary btn-block" type="submit">Login</button>
                    
                    <div class="auth-links">
                        <a href="${pageContext.request.contextPath}/register.jsp">Don't have an account? Sign Up</a>
                        <a href="${pageContext.request.contextPath}/forgotPassword.jsp">Forgot password?</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp"/>

    <!-- Password “reveal” script -->
    <script>
        const pwd = document.getElementById('password'),
              eye = document.getElementById('togglePassword');
        
        let isVisible = false;
        eye.addEventListener('click', () => {
            isVisible = !isVisible;
            pwd.type = isVisible ? 'text' : 'password';
            eye.style.color = isVisible ? '#00e5ff' : '#a0a0ab';
        });
    </script>
</body>
</html>
