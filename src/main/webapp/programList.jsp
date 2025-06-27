<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>All Programs</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>
  <h1>All Programs</h1>

  <!-- New Program button for executive_council -->
  <c:if test="${sessionScope.roles.contains('executive_council')}">
    <form action="${pageContext.request.contextPath}/programs/new" method="get" style="margin-bottom:1em;">
      <button type="submit">+ New Program</button>
    </form>
  </c:if>

  <!-- Filter form -->
  <form method="get" action="${pageContext.request.contextPath}/programs" style="margin-bottom:1em;">
    Status:
    <select name="status">
      <option value="">All</option>
      <option value="PENDING_APPROVAL" ${param.status=='PENDING_APPROVAL'?'selected':''}>Pending Approval</option>
      <option value="ACTIVE"           ${param.status=='ACTIVE'?'selected':''}>Active</option>
      <option value="COMPLETED"        ${param.status=='COMPLETED'?'selected':''}>Completed</option>
      <option value="CANCELLED"        ${param.status=='CANCELLED'?'selected':''}>Cancelled</option>
    </select>
    &nbsp;Mode:
    <select name="mode">
      <option value="">All</option>
      <option value="SOLO" ${param.mode=='SOLO'?'selected':''}>Solo</option>
      <option value="TEAM" ${param.mode=='TEAM'?'selected':''}>Team</option>
    </select>
    &nbsp;Type:
    <select name="programType">
      <option value="">All</option>
      <option value="TOURNAMENT" ${param.programType=='TOURNAMENT'?'selected':''}>Tournament</option>
      <option value="EVENT"      ${param.programType=='EVENT'?'selected':''}>Event</option>
    </select>
    <button type="submit">Filter</button>
  </form>

  <table border="1" cellpadding="5" cellspacing="0">
    <thead>
      <tr>
        <th>ID</th><th>Name</th><th>Type</th><th>Mode</th><th>Status</th>
        <th>Creator</th><th>Dates</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="p" items="${programs}">
        <tr>
          <td>${p.progID}</td>
          <td>
            <a href="${pageContext.request.contextPath}/programs/${p.progID}">
              ${p.programName}
            </a>
          </td>
          <td>${p.programType}</td>
          <td>${p.tournamentMode}</td>
          <td>${p.status}</td>
          <td>${p.creatorId}</td>
          <td>${p.startDate} → ${p.endDate}</td>
          <td>
            <!-- View -->
            <a href="${pageContext.request.contextPath}/programs/${p.progID}">View</a>

            <!-- Edit/Delete own pending -->
            <c:if test="
              ${p.status=='PENDING_APPROVAL'
                && sessionScope.userId==p.creatorId
                && sessionScope.roles.contains('executive_council')}">
              |
              <a href="${pageContext.request.contextPath}/programs/${p.progID}/edit">Edit</a>
              |
              <form action="${pageContext.request.contextPath}/programs/${p.progID}/delete"
                    method="post" style="display:inline;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <button type="submit" onclick="return confirm('Delete this draft?')">Delete</button>
              </form>
            </c:if>

            <!-- Approve by high_council -->
            <c:if test="
              ${p.status=='PENDING_APPROVAL'
                && sessionScope.roles.contains('high_council')}">
              |
              <form action="${pageContext.request.contextPath}/programs/${p.progID}/approve"
                    method="post" style="display:inline;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <button type="submit">Approve</button>
              </form>
            </c:if>

            <!-- Cancel permitted -->
            <c:if test="
              ${p.status!='COMPLETED'
                && (sessionScope.roles.contains('high_council')
                    || (sessionScope.roles.contains('executive_council')
                        && sessionScope.userId==p.creatorId))}">
              |
              <form action="${pageContext.request.contextPath}/programs/${p.progID}/cancel"
                    method="post" style="display:inline;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <button type="submit">Cancel</button>
              </form>
            </c:if>

            <!-- Join tournament -->
            <c:if test="
              ${p.programType=='TOURNAMENT'
                && p.status=='ACTIVE'
                && !joinedProgIds.contains(p.progID)
                && (sessionScope.roles.contains('athlete')
                    || sessionScope.roles.contains('executive_council')
                    || sessionScope.roles.contains('high_council'))}">
              |
              <form action="${pageContext.request.contextPath}/programs/${p.progID}/join"
                    method="post" style="display:inline;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <button type="submit">Join</button>
              </form>
            </c:if>
            <c:if test="${joinedProgIds.contains(p.progID)}">
              | Joined
            </c:if>

            <!-- Sync with Challonge -->
            <c:if test="
              ${p.programType=='TOURNAMENT'
                && sessionScope.roles.contains('high_council')}">
              |
              <form action="${pageContext.request.contextPath}/programs/${p.progID}/sync"
                    method="post" style="display:inline;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <button type="submit">Sync</button>
              </form>
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</body>
</html>
