<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard – NexGen Esports</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <jsp:include page="header.jsp"/>

  <button id="openToggle" class="open-toggle">☰</button>
  <div class="container">
    <div class="sidebar">
      <button id="closeToggle" class="close-toggle">×</button>
      <jsp:include page="sidebar.jsp"/>
    </div>

    <div class="content">
      <div class="dashboard-container">
        <h2>Welcome, <c:out value="${sessionScope.username}"/>!</h2>
        <p>Your role: <c:out value="${sessionScope.role}"/></p>
        <p>Accessible pages:</p>
        <ul>
          <!-- Example: you could query rp_permissions_full view for their perms -->
        </ul>
      </div>
    </div>
  </div>

  <jsp:include page="footer.jsp"/>

  <script>
    document.getElementById('openToggle').onclick  = () => document.body.classList.remove('sidebar-collapsed');
    document.getElementById('closeToggle').onclick = () => document.body.classList.add('sidebar-collapsed');
  </script>
</body>
</html>
