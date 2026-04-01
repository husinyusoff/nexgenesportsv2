<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password - NexGen Esports</title>
</head>
<body class="auth-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <div class="content">
            <div class="auth-box glass-card">
                <h2>RESET PASSWORD</h2>
                <p style="color: var(--text-muted); text-align: center; margin-bottom: 25px; font-size: 0.95rem;">
                    Enter your new password below.
                </p>

                <% if (request.getAttribute("errorMsg") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("errorMsg") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth?action=resetPassword" method="post">
                    <input type="hidden" name="token" value="${token}"/>

                    <label class="label" for="password">New Password</label>
                    <div class="password-wrapper">
                        <input class="input-field" type="password" id="password" name="password" required
                               placeholder="Minimum 6 characters" minlength="6">
                        <span class="eye-icon" id="togglePassword">&#128065;</span>
                    </div>

                    <label class="label" for="confirmPassword">Confirm Password</label>
                    <div class="password-wrapper">
                        <input class="input-field" type="password" id="confirmPassword" name="confirmPassword" required
                               placeholder="Re-enter password" minlength="6">
                        <span class="eye-icon" id="toggleConfirm">&#128065;</span>
                    </div>

                    <button class="btn btn-primary btn-block" type="submit">Reset Password</button>

                    <div class="auth-links" style="justify-content: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/login.jsp">Back to Login</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp"/>

    <script>
        function setupToggle(toggleId, fieldId) {
            document.getElementById(toggleId).addEventListener('click', function() {
                const field = document.getElementById(fieldId);
                if (field.type === 'password') {
                    field.type = 'text';
                    this.style.color = '#00e5ff';
                } else {
                    field.type = 'password';
                    this.style.color = '#a0a0ab';
                }
            });
        }
        setupToggle('togglePassword', 'password');
        setupToggle('toggleConfirm', 'confirmPassword');
    </script>
</body>
</html>
