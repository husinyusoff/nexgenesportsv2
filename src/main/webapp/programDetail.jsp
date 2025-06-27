<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Program: ${program.programName}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>
  <h1>${program.programName}</h1>

  <section>
    <h2>Core Info</h2>
    <p><strong>ID:</strong> ${program.progID}</p>
    <p><strong>Type:</strong> ${program.programType}</p>
    <p><strong>Description:</strong> ${program.description}</p>
    <p><strong>Schedule:</strong> ${program.startDate} → ${program.endDate}</p>
    <c:if test="${program.startAt != null}">
      <p><strong>Override Start:</strong> ${program.startAt}</p>
    </c:if>
    <c:if test="${program.endAt != null}">
      <p><strong>Override End:</strong> ${program.endAt}</p>
    </c:if>
  </section>

  <c:if test="${program.programType=='TOURNAMENT'}">
    <section>
      <h2>Tournament Settings</h2>
      <p><strong>Game:</strong> ${program.gameID}</p>
      <p><strong>Mode:</strong> ${program.tournamentMode}</p>
      <p><strong>Capacity:</strong> ${program.capacity}
        <c:if test="${program.tournamentMode=='TEAM'}">
          (max ${program.maxTeamMember} per team)
        </c:if>
      </p>
      <p><strong>Fee:</strong> ${program.progFee}</p>
      <p><strong>Prize Pool:</strong> ${program.prizePool}</p>
      <p><strong>Open Signup:</strong>
        <c:choose>
          <c:when test="${program.openSignup}">Yes</c:when>
          <c:otherwise>No</c:otherwise>
        </c:choose>
      </p>
      <p><strong>Status:</strong> ${program.status}</p>
    </section>

    <c:if test="${sync != null}">
      <section>
        <h2>External Sync (Challonge)</h2>
        <p><strong>URL:</strong>
          <a href="${sync.challongeUrl}" target="_blank">${sync.challongeUrl}</a>
        </p>
        <p><strong>State:</strong> ${sync.challongeState}</p>
        <p><strong>Created:</strong> ${sync.challongeCreatedAt}</p>
        <p><strong>Last Synced:</strong> ${sync.challongeLastSyncAt}</p>
        <c:if test="${sessionScope.roles.contains('high_council')}">
          <form action="${pageContext.request.contextPath}/programs/${program.progID}/sync"
                method="post" style="margin-top:0.5em;">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
            <button type="submit">Sync Now</button>
          </form>
        </c:if>
      </section>
    </c:if>

    <section>
      <h3>Participants</h3>
      <ul>
        <c:forEach var="pt" items="${participants}">
          <li>${pt.userId} <small>joined at ${pt.joinedAt}</small></li>
        </c:forEach>
      </ul>

      <c:if test="
        ${program.status=='ACTIVE'
          && !joinedProgIds.contains(program.progID)
          && sessionScope.roles.contains('athlete')}">
        <form action="${pageContext.request.contextPath}/programs/${program.progID}/join"
              method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
          <button type="submit">Join Tournament</button>
        </form>
      </c:if>
      <c:if test="${joinedProgIds.contains(program.progID)}">
        <p><em>You have joined this tournament.</em></p>
      </c:if>
    </section>

    <section>
      <h3>Raw Challonge Metadata</h3>
      <pre style="background:#f9f9f9; padding:1em; border:1px solid #ddd;">
${sync.challongeMetadata}
      </pre>
    </section>
  </c:if>

  <c:if test="${program.programType=='EVENT'}">
    <section>
      <h2>Event Details</h2>
      <p>This is a non-tournament event; no external bracket is created.</p>
    </section>
  </c:if>

  <p style="margin-top:1em;">
    <a href="${pageContext.request.contextPath}/programs">← Back to Programs</a>
  </p>
</body>
</html>
