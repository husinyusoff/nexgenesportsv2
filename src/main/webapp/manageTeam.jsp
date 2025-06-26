<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Team – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body class="team-page">
  <jsp:include page="/header.jsp"/>
  <button id="openToggle" class="open-toggle">☰</button>

  <div class="container">
    <div class="sidebar">
      <button id="closeToggle" class="close-toggle">×</button>
      <jsp:include page="/sidebar.jsp"/>
    </div>

    <div class="content">
      <div class="card">

        <h1>My Team</h1>
        <button
          class="btn blue-btn create-team-btn"
          onclick="location.href='${pageContext.request.contextPath}/team/create'">
          CREATE TEAM
        </button>
        <button
          class="btn blue-btn join-request-btn"
          onclick="location.href='${pageContext.request.contextPath}/team/join'">
          JOIN REQUEST
        </button>

        <table class="summary-table">
          <thead>
            <tr>
              <th>Logo</th>
              <th>Team Name</th>
              <th>Current Leader</th>
              <th>Creation Date</th>
              <th>Capacity</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="team" items="${teams}" varStatus="st">
              <tr>
                <td>
                  <img src="${team.logoURL}" alt="${team.teamName}" class="logo-thumb"/>
                </td>
                <td><c:out value="${team.teamName}"/></td>
                <td><c:out value="${team.leader}"/></td>
                <td>${fn:replace(team.createdAt,'T',' ')}</td>
                <td>${membersCountMap[team.teamID]}/${team.capacity}</td>
                <td>
                  <button
                    type="button"
                    class="btn green-btn details-btn"
                    data-idx="${st.index}">
                    DETAILS
                  </button>
                  <form class="inline-form"
                        action="${ctx}/team/create"
                        method="post">
                    <input type="hidden" name="action"    value="leave"/>
                    <input type="hidden" name="teamID"    value="${team.teamID}"/>
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <button type="submit" class="btn red-btn">LEAVE</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <div class="tab-switcher">
          <span class="tab-label active" data-tab="members">TEAM MEMBERS</span>
          <span class="tab-label"        data-tab="achievement">ACHIEVEMENT</span>
        </div>

        <div id="detailSection">
          <c:forEach var="team" items="${teams}" varStatus="st">
            <div class="panel" data-idx="${st.index}" style="display:none;">

              <div class="team-info">
                <img src="${team.logoURL}"
                     alt="${team.teamName}"
                     class="team-logo"/>
                <div class="team-meta">
                  <h2>${team.teamName}</h2>
                  <p>Current Leader: ${team.leader}</p>
                  <p>Created Date: ${fn:replace(team.createdAt,'T',' ')}</p>
                  <p>Capacity: ${membersCountMap[team.teamID]}/${team.capacity}</p>
                </div>
              </div>

              <div class="inner-panel members-panel" style="display:none;">
                <table class="members-table">
                  <thead>
                    <tr>
                      <th>No.</th>
                      <th>Name</th>
                      <th>Role</th>
                      <th>Joined Date</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="member"
                               items="${membersByTeam[team.teamID]}"
                               varStatus="ms">
                      <tr>
                        <td>${ms.index + 1}</td>
                        <td><c:out value="${member.userID}"/></td>
                        <td><c:out value="${member.teamRole}"/></td>
                        <td>${fn:replace(member.joinedAt,'T',' ')}</td>
                        <td>
                          <c:choose>
                            <c:when test="${sessionScope.username == member.userID}">
                              <form class="inline-form"
                                    action="${pageContext.request.contextPath}/team/manage"
                                    method="post">
                                <input type="hidden" name="action"       value="leave"/>
                                <input type="hidden" name="teamID"       value="${team.teamID}"/>
                                <input type="hidden" name="targetUserID" value="${member.userID}"/>
                                <input type="hidden" name="csrfToken"    value="${sessionScope.csrfToken}"/>
                                <button type="submit" class="btn red-btn">LEAVE</button>
                              </form>
                            </c:when>

                            <c:when test="${userRoleMap[team.teamID] == 'Leader' 
                                           && member.userID != sessionScope.username}">
                              <form class="inline-form"
                                    action="${pageContext.request.contextPath}/team/manage"
                                    method="post">
                                <input type="hidden" name="action"       value="changeRole"/>
                                <input type="hidden" name="teamID"       value="${team.teamID}"/>
                                <input type="hidden" name="targetUserID" value="${member.userID}"/>
                                <input type="hidden" name="csrfToken"    value="${sessionScope.csrfToken}"/>
                                <select name="newRole" class="role-select"
                                        <c:if test="${fn:length(membersByTeam[team.teamID]) == 1}">
                                          disabled
                                        </c:if>
                                        onchange="if (confirm('Change role to ' + this.value + '?'))
                                                     this.form.submit();">
                                  <option value="Leader"    ${member.teamRole=='Leader'    ? 'selected':''}>Leader</option>
                                  <option value="Co-Leader" ${member.teamRole=='Co-Leader' ? 'selected':''}>Co-Leader</option>
                                  <option value="Member"    ${member.teamRole=='Member'    ? 'selected':''}>Member</option>
                                </select>
                              </form>
                              <form class="inline-form"
                                    action="${pageContext.request.contextPath}/team/manage"
                                    method="post">
                                <input type="hidden" name="action"       value="removeMember"/>
                                <input type="hidden" name="teamID"       value="${team.teamID}"/>
                                <input type="hidden" name="targetUserID" value="${member.userID}"/>
                                <input type="hidden" name="csrfToken"    value="${sessionScope.csrfToken}"/>
                                <button type="submit" class="btn red-btn">KICK</button>
                              </form>
                            </c:when>

                            <c:otherwise/>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>

              <div class="inner-panel achievement-panel" style="display:none;">
                <table class="achievement-table">
                  <thead>
                    <tr>
                      <th>No.</th>
                      <th>Program Name</th>
                      <th>Date &amp; Time</th>
                      <th>Joined Date</th>
                      <th>Rank</th>
                      <th>Score</th>
                      <th>Personal Score</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="ach"
                               items="${achievementsByTeam[team.teamID]}"
                               varStatus="as">
                      <tr>
                        <td>${as.index + 1}</td>
                        <td><c:out value="${ach.programName}"/></td>
                        <td><fmt:formatDate value="${ach.eventDateTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td><fmt:formatDate value="${ach.joinedDate}"     pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>${ach.rank != null ? ach.rank : '-'}</td>
                        <td>${ach.score}</td>
                        <td>${ach.personalScore}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>

            </div>
          </c:forEach>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="/footer.jsp"/>

  <script>
    (function () {
      const panels  = document.querySelectorAll('#detailSection .panel'),
            buttons = document.querySelectorAll('.details-btn'),
            tabs    = document.querySelectorAll('.tab-label');
      let idx = -1;

      function showPanel(i) {
        if (i < 0 || i >= panels.length) return;
        if (idx >= 0) panels[idx].style.display = 'none';
        idx = i;
        panels[idx].style.display = 'block';
        tabs.forEach(t => t.classList.remove('active'));
        tabs[0].classList.add('active');
        panels[idx].querySelector('.members-panel').style.display     = 'block';
        panels[idx].querySelector('.achievement-panel').style.display = 'none';
        panels[idx].scrollIntoView({behavior:'smooth'});
      }

      buttons.forEach(btn =>
        btn.addEventListener('click', () => showPanel(+btn.dataset.idx))
      );

      tabs.forEach((lbl,i) =>
        lbl.addEventListener('click', () => {
          if (idx < 0) return;
          tabs.forEach(t => t.classList.remove('active'));
          lbl.classList.add('active');
          panels[idx].querySelector('.members-panel').style.display     = (i===0?'block':'none');
          panels[idx].querySelector('.achievement-panel').style.display = (i===1?'block':'none');
        })
      );
    })();
  </script>
</body>
</html>
