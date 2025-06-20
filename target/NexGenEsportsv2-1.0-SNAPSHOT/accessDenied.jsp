<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>Access Denied – NexGen Esports</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <jsp:include page="header.jsp"/>
  <div class="container">
    <div class="content">
      <h2>🚫 Access Denied</h2>
      <p>You don’t have permission to view that page.</p>
      <a href="${pageContext.request.contextPath}/dashboard.jsp">Return to Dashboard</a>
    </div>
  </div>
  <jsp:include page="footer.jsp"/>
</body>
</html>
