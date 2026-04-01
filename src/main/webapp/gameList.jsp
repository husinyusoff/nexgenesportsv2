<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Games - NexGen Esports</title>
</head>
<body class="app-wrapper">
    <jsp:include page="/header.jsp"/>

    <div class="main-container">
        <!-- Sidebar Navigation -->
        <jsp:include page="/sidebar.jsp"/>

        <!-- Main Content -->
        <main class="content">
            <div class="module-header">
                <h2>GAME DATABASE</h2>
                <c:if test="${canCreate}">
                    <a href="${pageContext.request.contextPath}/games/new" class="btn btn-primary">+ ADD NEW GAME</a>
                </c:if>
            </div>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Game Title</th>
                        <th>Genre</th>
                        <th>System Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="g" items="${games}">
                        <tr>
                            <td data-label="Game Title">
                                <a href="${pageContext.request.contextPath}/games/details?id=${g.gameID}" style="color: var(--neon-cyan); text-decoration: none; font-weight: 800; font-size: 1.1rem; text-transform: uppercase;">
                                    ${g.gameName}
                                </a>
                                <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">ID: ${g.gameID}</div>
                            </td>
                            <td data-label="Genre" style="text-transform: uppercase;">${g.genre}</td>
                            <td data-label="Actions">
                                <div class="table-actions">
                                    <c:if test="${canEdit}">
                                        <a href="${pageContext.request.contextPath}/games/edit?id=${g.gameID}" class="btn" style="border: 1px solid var(--neon-cyan); color: var(--neon-cyan);">EDIT</a>
                                    </c:if>
                                    <c:if test="${canDelete}">
                                        <form action="${pageContext.request.contextPath}/games/delete" method="post" style="display:inline; flex: 1;">
                                            <input type="hidden" name="id" value="${g.gameID}"/>
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                            <button type="submit" class="btn btn-danger" style="width: 100%;" onclick="return confirm('OVERRIDE AUTHORIZED: Delete this game?')">DELETE</button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </main>
    </div>

    <jsp:include page="/footer.jsp"/>
</body>
</html>
