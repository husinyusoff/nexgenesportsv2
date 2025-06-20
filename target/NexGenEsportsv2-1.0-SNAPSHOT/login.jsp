<!-- login.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login – NexGen Esports</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="header.jsp"/>

    <!-- ☰ open-sidebar button -->
    <button id="openToggle" class="open-toggle">☰</button>

    <div class="container">
        <!-- Sidebar (static for login/register) -->
        <div class="sidebar">
            <button id="closeToggle" class="close-toggle">×</button>
            <nav>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                    <li><a href="${pageContext.request.contextPath}/register.jsp">Sign Up</a></li>
                </ul>
            </nav>
        </div>

        <!-- Main content -->
        <div class="content">
            <div class="login-container">
                <h2>LOGIN</h2>
                <% if ("badcreds".equals(request.getParameter("error"))) { %>
                    <p class="error">❌ Invalid user ID, password or role.</p>
                <% } %>

                <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                    <div class="roles-grid">
                        <label><input type="radio" name="selectedRole" value="athlete"       checked> Athlete</label>
                        <label><input type="radio" name="selectedRole" value="referee"> Referee</label>
                        <label><input type="radio" name="selectedRole" value="executive_council"> Exec Council</label>
                        <label><input type="radio" name="selectedRole" value="high_council"> High Council</label>
                    </div>

                    <label for="userID">User ID</label>
                    <input type="text" id="userID" name="userID" required>

                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" required>
                        <span class="eye-icon" id="togglePassword"></span>
                    </div>

                    <a href="#" class="forgot">forgot password</a>
                    <button type="submit">Login</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp"/>

    <!-- Toggle script -->
    <script>
        document.getElementById('openToggle').onclick  = () => document.body.classList.remove('sidebar-collapsed');
        document.getElementById('closeToggle').onclick = () => document.body.classList.add('sidebar-collapsed');
    </script>

    <!-- Password “hold to reveal” script -->
    <script>
    (function(){
        const pwd = document.getElementById('password'),
              eye = document.getElementById('togglePassword');
        eye.addEventListener('mousedown', ()=> pwd.type='text');
        eye.addEventListener('mouseup',   ()=> pwd.type='password');
        eye.addEventListener('mouseleave',()=> pwd.type='password');
        eye.addEventListener('touchstart',()=> pwd.type='text');
        eye.addEventListener('touchend',  ()=> pwd.type='password');
    })();
    </script>
</body>
</html>
