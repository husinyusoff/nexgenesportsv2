<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>
<jsp:include page="sidebar.jsp"/>

<div class="container">
  <div class="content">
    <h2>Game Details</h2>

    <p><strong>ID:</strong> ${game.gameID}</p>
    <p><strong>Name:</strong> ${game.gameName}</p>
    <p><strong>Genre:</strong> ${game.genre}</p>
    <p><strong>Created:</strong> ${game.createdAt}</p>
    <p><strong>Updated:</strong> ${game.updatedAt}</p>

    <c:if test="${canEdit}">
      <a href="${pageContext.request.contextPath}/games/edit?id=${game.gameID}"
         class="button green-button">Edit</a>
    </c:if>
    <c:if test="${canDelete}">
      <form action="${pageContext.request.contextPath}/games/delete"
            method="post" style="display:inline">
        <input type="hidden" name="id" value="${game.gameID}"/>
        <input type="hidden" name="csrfToken"
               value="${sessionScope.csrfToken}"/>
        <button type="submit" class="button red-button"
                onclick="return confirm('Delete this game?')">
          Delete
        </button>
      </form>
    </c:if>

    <a href="${pageContext.request.contextPath}/games"
       class="button blue-button">Back to List</a>
  </div>
</div>

<jsp:include page="footer.jsp"/>
