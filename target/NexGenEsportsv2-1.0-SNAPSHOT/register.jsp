<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
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
    </div>
  </div>

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
</body>
</html>
