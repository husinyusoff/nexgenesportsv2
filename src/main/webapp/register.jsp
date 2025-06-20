<!-- register.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign Up – NexGen Esports</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
    <!-- Header -->
    <div class="header">
        <img src="${pageContext.request.contextPath}/images/umt-logo.png" alt="UMT Logo" class="logo umt-logo">
        <img src="${pageContext.request.contextPath}/images/esports-logo.png" alt="Esports Logo" class="logo esports-logo">
        <h1>NEXGEN ESPORTS</h1>
    </div>

    <!-- ☰ open-sidebar button -->
    <button id="openToggle" class="open-toggle">☰</button>

    <div class="container">
        <!-- Sidebar (static for register/login) -->
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
            <div class="register-container">
                <h2>SIGN UP</h2>
                <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                    <label for="userID">User ID</label>
                    <input type="text" id="userID" name="userID" required>

                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required>

                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>

                    <label for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber">

                    <label for="selectedRole">Role</label>
                    <select id="selectedRole" name="selectedRole" required>
                        <option value="athlete">Athlete</option>
                        <option value="referee">Referee</option>
                        <option value="executive_council">Executive Council</option>
                        <option value="high_council">High Council</option>
                    </select>

                    <label for="position">Position</label>
                    <input type="text" id="position" name="position">

                    <label for="clubSessionID">Club Session</label>
                    <select id="clubSessionID" name="clubSessionID" required>
                        <option value="ESUMT_24/25">2024/2025</option>
                        <option value="ESUMT_25/26">2025/2026</option>
                    </select>

                    <label for="gamingPassID">Gaming Pass Tier</label>
                    <input id="gamingPassID" name="gamingPassID">

                    <button type="submit">Register</button>
                </form>
                <% if (request.getAttribute("message") != null) { %>
                    <p class="error"><%= request.getAttribute("message") %></p>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; NexGen Esports 2025 All Rights Reserved.
    </div>

    <!-- Toggle script -->
    <script>
        document.getElementById('openToggle').onclick  = () => document.body.classList.remove('sidebar-collapsed');
        document.getElementById('closeToggle').onclick = () => document.body.classList.add('sidebar-collapsed');
    </script>
</body>
</html>
