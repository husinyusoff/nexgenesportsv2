<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Game Details - NexGen Esports</title>
</head>
<body class="app-wrapper">
    <jsp:include page="/header.jsp"/>

    <div class="main-container">
        <!-- Sidebar Navigation -->
        <jsp:include page="/sidebar.jsp"/>

        <!-- Main Content -->
        <main class="content">
            <div class="module-header">
                <h2>GAME PROFILER: <span style="color: var(--neon-cyan);">${game.gameName}</span></h2>
                <a href="${pageContext.request.contextPath}/games" class="btn" style="border: 1px solid var(--text-muted); color: var(--text-muted);">BACK TO DATABASE</a>
            </div>
            
            <div class="glass-card">
                <div class="details-grid">
                    <div class="details-item">
                        <span class="label">System ID</span>
                        <br><strong>${game.gameID}</strong>
                    </div>
                    <div class="details-item">
                        <span class="label">Primary Title</span>
                        <br><strong style="color: var(--neon-cyan); text-transform: uppercase;">${game.gameName}</strong>
                    </div>
                    <div class="details-item">
                        <span class="label">Classification / Genre</span>
                        <br><strong style="text-transform: uppercase;">${game.genre}</strong>
                    </div>
                    <div class="details-item">
                        <span class="label">Data Initialization</span>
                        <br><strong>${game.createdAt}</strong>
                    </div>
                    <div class="details-item">
                        <span class="label">Last Sync</span>
                        <br><strong>${game.updatedAt}</strong>
                    </div>
                </div>
                
                <div style="display: flex; gap: 15px; margin-top: 30px;">
                    <c:if test="${canEdit}">
                        <a href="${pageContext.request.contextPath}/games/edit?id=${game.gameID}" class="btn btn-primary" style="flex: 1;">EDIT PROTOCOL</a>
                    </c:if>
                    <c:if test="${canDelete}">
                        <form action="${pageContext.request.contextPath}/games/delete" method="post" style="flex: 1;">
                            <input type="hidden" name="id" value="${game.gameID}"/>
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                            <button type="submit" class="btn btn-danger btn-block" style="margin-top: 0;" onclick="return confirm('OVERRIDE AUTHORIZED: Delete this record permanently?')">DELETE RECORD</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/footer.jsp"/>
</body>
</html>
