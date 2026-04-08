<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Access Denied – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
</head>
<body class="app-wrapper">
  <jsp:include page="header.jsp"/>

  <div class="main-container" style="justify-content: center; align-items: center;">
    <main class="content" style="flex: none; width: 100%; max-width: 500px; margin: 0 auto;">
      <div class="glass-card" style="text-align: center;">
        <h2 style="color: var(--neon-pink); font-size: 2.2rem; margin-bottom: 20px; text-shadow: 0 0 15px rgba(255, 0, 127, 0.4);">
            🚫 Access Denied
        </h2>
        <p style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 30px;">
            You don’t have permission to view that page.
        </p>
        <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-primary" style="width: 100%;">
            Return to Dashboard
        </a>
      </div>
    </main>
  </div>

  <jsp:include page="footer.jsp"/>
</body>
</html>
