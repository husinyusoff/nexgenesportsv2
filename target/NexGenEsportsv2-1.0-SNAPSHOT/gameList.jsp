<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>
<jsp:include page="sidebar.jsp"/>

<div class="container">
  <div class="content">
    <h2>Games</h2>

    <c:if test="${canCreate}">
      <a href="${pageContext.request.contextPath}/games/new"
         class="button green-button">
        + New Game
      </a>
    </c:if>

    <table>
      <thead>
        <tr>
          <th>ID</th><th>Name</th><th>Genre</th><th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="g" items="${games}">
          <tr>
            <td>${g.gameID}</td>
            <td>
              <a href="${pageContext.request.contextPath}/games/details?id=${g.gameID}">
                ${g.gameName}
              </a>
            </td>
            <td>${g.genre}</td>
            <td>
              <c:if test="${canEdit}">
                <a href="${pageContext.request.contextPath}/games/edit?id=${g.gameID}">
                  Edit
                </a>
              </c:if>
              <c:if test="${canDelete}">
                <form action="${pageContext.request.contextPath}/games/delete"
                      method="post" style="display:inline">
                  <input type="hidden" name="id" value="${g.gameID}"/>
                  <input type="hidden" name="csrfToken"
                         value="${sessionScope.csrfToken}"/>
                  <button type="submit"
                          onclick="return confirm('Delete this game?')">
                    Delete
                  </button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<jsp:include page="footer.jsp"/>
