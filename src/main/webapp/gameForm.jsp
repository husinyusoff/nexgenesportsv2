<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>
      <c:choose>
        <c:when test="${not empty game}">Edit Game</c:when>
        <c:otherwise>New Game</c:otherwise>
      </c:choose> - NexGen Esports
    </title>
</head>
<body class="app-wrapper">
    <jsp:include page="/header.jsp"/>

    <div class="main-container">
        <!-- Sidebar Navigation -->
        <jsp:include page="/sidebar.jsp"/>

        <!-- Main Content -->
        <main class="content">
            <div class="module-header">
                <h2>
                  <c:choose>
                    <c:when test="${not empty game}">MODIFY PROTOCOL</c:when>
                    <c:otherwise>INITIALIZE NEW PROTOCOL</c:otherwise>
                  </c:choose>
                </h2>
                <a href="${pageContext.request.contextPath}/games" class="btn" style="border: 1px solid var(--text-muted); color: var(--text-muted);">ABORT</a>
            </div>
            
            <div class="glass-card" style="max-width: 600px; margin: 0 auto;">
                <form method="post" action="${pageContext.request.contextPath}/games${not empty game?'/edit':'/new'}">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <c:if test="${not empty game}">
                        <input type="hidden" name="gameID" value="${game.gameID}"/>
                    </c:if>

                    <label class="label" for="gameName">Designation (Game Name)</label>
                    <input class="input-field" type="text" id="gameName" name="gameName" required value="${game.gameName}" placeholder="Enter designation"/>
                    
                    <label class="label" for="genre">Classification (Genre)</label>
                    <input class="input-field" type="text" id="genre" name="genre" value="${game.genre}" placeholder="e.g. FPS, MOBA, Battle Royale"/>

                    <div style="display: flex; gap: 15px; margin-top: 30px;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">
                            <c:out value="${not empty game ? 'EXECUTE UPDATE' : 'INITIALIZE'}"/>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <jsp:include page="/footer.jsp"/>
</body>
</html>
