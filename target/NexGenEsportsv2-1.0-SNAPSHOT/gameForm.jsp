<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>
<jsp:include page="sidebar.jsp"/>

<div class="container">
  <div class="content">
    <h2>
      <c:choose>
        <c:when test="${not empty game}">Edit Game</c:when>
        <c:otherwise>New Game</c:otherwise>
      </c:choose>
    </h2>

    <form method="post"
          action="${pageContext.request.contextPath}/games${not empty game?'/edit':'/new'}">
      <input type="hidden" name="csrfToken"
             value="${sessionScope.csrfToken}"/>
      <c:if test="${not empty game}">
        <input type="hidden" name="gameID" value="${game.gameID}"/>
      </c:if>

      <div>
        <label for="gameName">Name</label>
        <input id="gameName" name="gameName" required
               value="${game.gameName}"/>
      </div>
      <div>
        <label for="genre">Genre</label>
        <input id="genre" name="genre" value="${game.genre}"/>
      </div>

      <button type="submit" class="button green-button">
        <c:out value="${not empty game ? 'Update' : 'Create'}"/>
      </button>
      <a href="${pageContext.request.contextPath}/games"
         class="button blue-button">Cancel</a>
    </form>
  </div>
</div>

<jsp:include page="footer.jsp"/>
