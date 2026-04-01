<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - NexGen Esports</title>
</head>
<body class="app-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <!-- Sidebar Navigation -->
        <jsp:include page="sidebar.jsp"/>

        <!-- Main Content -->
        <main class="content">
            <div class="module-header">
                <h2>INCOMING TRANSMISSION: DASHBOARD</h2>
            </div>
            
            <div class="glass-card">
                <h3 style="color: var(--neon-cyan); margin-bottom: 10px;">Welcome back, <c:out value="${sessionScope.username}"/>!</h3>
                <p style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 20px;">
                    Current Access Level: <strong style="color: var(--text-primary); text-transform: uppercase;"><c:out value="${sessionScope.role}"/></strong>
                </p>
                
                <p>Welcome to the core. All systems nominal. Select a module from the terminal sidebar to proceed.</p>
            </div>
        </main>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>
