<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container" style="display:flex;">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">
    <h2>Bracket: ${bracket.name}</h2>
    <p>Format: ${bracket.format}</p>

    <h3>Matches</h3>
    <table class="summary-table">
      <thead><tr>
        <th>#</th><th>P1</th><th>P2</th><th>S1</th><th>S2</th><th>Action</th>
      </tr></thead>
      <tbody>
        <c:forEach var="m" items="${matches}" varStatus="st">
          <tr>
            <td>${st.index + 1}</td>
            <td>${m.participant1Name}</td>
            <td>${m.participant2Name}</td>
            <td>${m.score1}</td>
            <td>${m.score2}</td>
            <td>
              <c:if test="${m.openForScoring}">
                <form method="post" action="${ctx}/brackets/score" style="display:inline">
                  <input type="hidden" name="csrfToken"
                         value="${sessionScope.csrfToken}"/>
                  <input type="hidden" name="bracketId"
                         value="${bracket.bracketId}"/>
                  <input type="hidden" name="matchId" value="${m.matchId}"/>
                  <input name="score1" size="2" value="${m.score1}"/>
                  <input name="score2" size="2" value="${m.score2}"/>
                  <button type="submit" class="btn small-btn">Save</button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <br/>
    <a href="${ctx}/brackets/edit?bracketId=${bracket.bracketId}"
       class="btn blue-btn">Edit</a>
    <form method="post" action="${ctx}/brackets/delete" style="display:inline">
      <input type="hidden" name="csrfToken"
             value="${sessionScope.csrfToken}"/>
      <input type="hidden" name="bracketId" value="${bracket.bracketId}"/>
      <input type="hidden" name="progId"   value="${bracket.progId}"/>
      <button type="submit" class="btn red-btn"
              onclick="return confirm('Delete this bracket?')">
        Delete
      </button>
    </form>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
