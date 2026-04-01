<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
<<<<<<< Updated upstream
    <meta charset="UTF-8">
    <title>Sign Up - NexGen Esports</title>
</head>
<body class="auth-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <div class="content">
            <div class="auth-box glass-card" style="max-width: 480px;">
                <h2>CREATE ACCOUNT</h2>

                <% if ("success".equals(request.getParameter("status"))) { %>
                    <div style="color:var(--neon-cyan); text-align:center; margin-bottom: 20px; padding: 10px; border: 1px solid var(--neon-cyan); border-radius: 8px; background: rgba(0,229,255,0.1);">
                        Registration successful! <a href="login.jsp" style="color: white; font-weight: bold;">Login here</a>
                    </div>
                <% } %>
                <% if (request.getAttribute("errorMsg") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("errorMsg") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth?action=register" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                    <label class="label" for="userID">User ID</label>
                    <input class="input-field" type="text" id="userID" name="userID" required
                           placeholder="Choose a unique User ID" pattern="[a-zA-Z0-9_]+"
                           title="Only letters, numbers, and underscores allowed">

                    <label class="label" for="name">Full Name</label>
                    <input class="input-field" type="text" id="name" name="name" required
                           placeholder="Enter your full name">

                    <label class="label" for="email">Email</label>
                    <input class="input-field" type="email" id="email" name="email" required
                           placeholder="your.email@student.umt.edu.my">

                    <label class="label" for="phoneNumber">Phone Number</label>
                    <input class="input-field" type="tel" id="phoneNumber" name="phoneNumber"
                           placeholder="01X-XXXXXXX">

                    <label class="label" for="matricNumber">Matric / Staff Number</label>
                    <input class="input-field" type="text" id="matricNumber" name="matricNumber"
                           placeholder="e.g. S12345 (Student), Staff ID (Staff)">

                    <label class="label" for="newPassword">Password</label>
                    <div class="password-wrapper">
                        <input class="input-field" type="password" id="newPassword" name="password" required
                               placeholder="Minimum 6 characters" minlength="6">
                        <span class="eye-icon" id="togglePassword">&#128065;</span>
                    </div>

                    <label class="label" for="confirmPassword">Confirm Password</label>
                    <div class="password-wrapper">
                        <input class="input-field" type="password" id="confirmPassword" name="confirmPassword" required
                               placeholder="Re-enter password" minlength="6">
                        <span class="eye-icon" id="toggleConfirm">&#128065;</span>
                    </div>

                    <button class="btn btn-primary btn-block" type="submit">Sign Up</button>

                    <div class="auth-links" style="justify-content: center;">
                        <a href="${pageContext.request.contextPath}/login.jsp">Already have an account? Login</a>
                    </div>
                </form>
            </div>
        </div>
=======
  <meta charset="UTF-8">
  <title>Sign Up – NexGen Esports</title>
  <link rel="stylesheet" href="${ctx}/styles.css"/>
</head>
<body class="sidebar-collapsed">

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
          <li><a href="${ctx}/login.jsp">Login</a></li>
          <li><a href="${ctx}/register.jsp">Sign Up</a></li>
        </ul>
      </nav>
    </div>

    <!-- Main content -->
    <div class="content">
      <div class="login-container">
        <h2>SIGN UP</h2>

        <form action="${ctx}/RegisterServlet" method="post">
          <!-- CSRF token -->
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

          <label for="userID">User ID</label>
          <input type="text" id="userID" name="userID"
                 value="${fn:escapeXml(param.userID)}" required/>

          <label for="name">Full Name</label>
          <input type="text" id="name" name="name"
                 value="${fn:escapeXml(param.name)}" required/>

          <label for="password">Password</label>
          <input type="password" id="password" name="password" required/>

          <label for="confirmPassword">Confirm Password</label>
          <input type="password" id="confirmPassword" name="confirmPassword" required/>

          <label for="phoneNumber">Phone Number</label>
          <input type="tel" id="phoneNumber" name="phoneNumber"
                 value="${fn:escapeXml(param.phoneNumber)}"/>

          <!-- only a logged-in “president” can pick role/position -->
          <c:choose>
            <c:when test="${not empty sessionScope.username 
                           and sessionScope.position == 'president'}">
              <label for="selectedRole">Role</label>
              <select id="selectedRole" name="selectedRole" required>
                <option value="athlete">Athlete</option>
                <option value="referee">Referee</option>
                <option value="executive_council">Executive Council</option>
                <option value="high_council">High Council</option>
              </select>

              <label for="position">Position</label>
              <input type="text" id="position" name="position"
                     value="${fn:escapeXml(param.position)}"/>
            </c:when>
            <c:otherwise>
              <input type="hidden" name="selectedRole" value="athlete"/>
<!--              <input type="hidden" name="position"     value=""/>-->
            </c:otherwise>
          </c:choose>

          <button type="submit" class="btn">Register</button>
        </form>

        <!-- show any validation or processing message -->
        <c:if test="${not empty message}">
          <p class="error">${message}</p>
        </c:if>
      </div>
>>>>>>> Stashed changes
    </div>
  </div>

<<<<<<< Updated upstream
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
        setupToggle('togglePassword', 'newPassword');
        setupToggle('toggleConfirm', 'confirmPassword');
    </script>
=======
  <!-- Footer -->
  <div class="footer">
    &copy; NexGen Esports 2025 All Rights Reserved.
  </div>

  <!-- Sidebar toggle scripts -->
  <script>
    document.getElementById('openToggle').onclick  =
      () => document.body.classList.remove('sidebar-collapsed');
    document.getElementById('closeToggle').onclick =
      () => document.body.classList.add('sidebar-collapsed');
  </script>
>>>>>>> Stashed changes
</body>
</html>
