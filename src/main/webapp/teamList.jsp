<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/header.jsp"/>
<div class="container">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">
    <h2>Team List</h2>

    <!-- Search + Sort bar -->
    <form method="get" action="${ctx}/team/list" style="display:inline-block;">
      <input type="text" name="q" placeholder="Search…" value="${param.q}"/>
      <button type="submit">🔍</button>
    </form>
    <form method="get" action="${ctx}/team/list" style="display:inline-block; margin-left:1em;">
      <label for="sortBy">Sort by:</label>
      <select name="sortBy" id="sortBy">
        <option value="teamName" ${param.sortBy=='teamName'?'selected':''}>Name</option>
        <option value="createdAt" ${param.sortBy=='createdAt'?'selected':''}>Created</option>
        <option value="capacity" ${param.sortBy=='capacity'?'selected':''}>Capacity</option>
      </select>
      <select name="dir">
        <option value="asc"  ${param.dir=='asc'?'selected':''}>↑</option>
        <option value="desc" ${param.dir=='desc'?'selected':''}>↓</option>
      </select>
      <button type="submit">Sort</button>
    </form>

    <table class="stations-table" style="margin-top:1em; width:100%;">
      <thead>
        <tr>
          <th>Team ID</th>
          <th>Team Name</th>
          <th>Leader</th>
          <th>Members</th>
          <th>Capacity</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="t" items="${teams}">
          <tr>
            <td>${t.teamID}</td>
            <td>${t.teamName}</td>
            <td>${t.createdBy}</td>
            <td>${t.activeCount}/${t.capacity}</td>
            <td>${t.capacity}</td>
            <td>
              <c:choose>
                <c:when test="${t.getMember}">
                  <a href="${ctx}/team/detail?teamID=${t.teamID}">Your Team</a>
                </c:when>
                <c:when test="${t.activeCount < t.capacity}">
                  <form method="post" action="${ctx}/team/joinRequest" style="display:inline">
                    <input type="hidden" name="teamID" value="${t.teamID}"/>
                    <button type="submit">Request to Join</button>
                  </form>
                </c:when>
                <c:otherwise>
                  <button disabled>Full</button>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
