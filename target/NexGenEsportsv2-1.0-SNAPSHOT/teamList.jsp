<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>

<div class="container" style="display:flex;">
  <div class="sidebar">
    <jsp:include page="/sidebar.jsp"/>
  </div>
  <div class="content" style="flex:1; padding:1em;">
    <h2>TEAM LIST</h2>
    <c:if test="${totalMemberships ge joinLimit}">
      <div style="color:red; margin-bottom:1em;">
        Limit reached: ${joinLimit} teams per user. To join another team, please leave one of your current teams.
      </div>
    </c:if>

    <form method="get" action="${ctx}/team/list" style="display:flex; gap:0.5em; margin-bottom:1em;">
      <input type="text" name="q" placeholder="Search by name…" value="${param.q}"/>
      <label for="sortBy">Sort by:</label>
      <select name="sortBy" id="sortBy">
        <option value="createdAt"   ${param.sortBy=='createdAt'  ?'selected':''}>Created Date</option>
        <option value="teamName"    ${param.sortBy=='teamName'   ?'selected':''}>Team Name</option>
        <option value="activeCount" ${param.sortBy=='activeCount'?'selected':''}>Members</option>
      </select>
      <select name="dir">
        <option value="desc" ${param.dir=='desc'?'selected':''}>↓ Descending</option>
        <option value="asc"  ${param.dir=='asc' ?'selected':''}>↑ Ascending</option>
      </select>
      <button type="submit">Apply</button>
      <button type="button" onclick="location.href='${ctx}/team/manage'" style="margin-left:auto;">Your Team</button>
    </form>

    <table border="1" cellpadding="5" cellspacing="0" width="100%">
      <thead style="background:#eef;">
        <tr>
          <th>Team ID</th>
          <th>Team Name</th>
          <th>Leader</th>
          <th>Created Date</th>
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
            <td>${t.leader}</td>
            <td>${fn:replace(t.createdAt,'T',' ')}</td>
            <td>${t.activeCount}</td>
            <td>${t.capacity}</td>
            <td>
              <c:choose>
                <c:when test="${myTeamIds.contains(t.teamID)}">
                  <a href="${ctx}/team/manage?teamID=${t.teamID}">Manage</a>
                </c:when>
                <c:when test="${t.activeCount lt t.capacity and totalMemberships lt joinLimit}">
                  <c:choose>
                    <c:when test="${pendingTeamIds.contains(t.teamID)}">
                      <button disabled>Requested</button>
                    </c:when>
                    <c:otherwise>
                      <form method="post" action="${ctx}/team/joinRequest" style="display:inline">
                        <input type="hidden" name="teamID"    value="${t.teamID}"/>
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        <button type="submit">Request to Join</button>
                      </form>
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:when test="${totalMemberships ge joinLimit}">
                  <button disabled>Max Limit</button>
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
