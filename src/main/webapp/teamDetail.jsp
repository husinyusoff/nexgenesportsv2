<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/header.jsp"/>
<div class="container">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">

    <!-- Team Header -->
    <h2>${team.teamName}</h2>
    <p>${team.description}</p>
    <p>Created by ${team.createdBy} on <fmt:formatDate value="${team.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
    <p>Capacity: ${team.activeCount}/${team.capacity}</p>

    <!-- If you are a leader/co-leader: show capacity form -->
    <c:if test="${myMember.teamRole=='Leader' || myMember.teamRole=='Co-Leader'}">
      <form method="post" action="${ctx}/team/setCapacity">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="teamID" value="${team.teamID}"/>
        <label for="newCap">Update Capacity (≥2):</label>
        <input type="number" id="newCap" name="capacity" min="2" value="${team.capacity}" required/>
        <button type="submit">Save</button>
      </form>
    </c:if>

    <!-- Members Table -->
    <h3>Members</h3>
    <table class="stations-table">
      <thead><tr><th>#</th><th>Name</th><th>Role</th><th>Joined</th><th>Action</th></tr></thead>
      <tbody>
        <c:forEach var="m" items="${members}" varStatus="st">
          <tr>
            <td>${st.index+1}</td>
            <td>${m.userID}</td>
            <td>${m.teamRole}</td>
            <td><fmt:formatDate value="${m.joinedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td>
              <c:choose>
                <!-- Self-leave -->
                <c:when test="${m.userID==sessionScope.username && m.teamRole!='Leader'}">
                  <form method="post" action="${ctx}/team/remove">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="teamID" value="${team.teamID}"/>
                    <input type="hidden" name="userID" value="${m.userID}"/>
                    <button type="submit">Leave</button>
                  </form>
                </c:when>
                <!-- Kick (Leader/Co-Leader kicking a member) -->
                <c:when test="${(myMember.teamRole=='Leader' || myMember.teamRole=='Co-Leader')
                               && m.teamRole=='Member'}">
                  <form method="post" action="${ctx}/team/remove" style="display:inline">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="teamID" value="${team.teamID}"/>
                    <input type="hidden" name="userID" value="${m.userID}"/>
                    <button type="submit">Kick</button>
                  </form>
                </c:when>
                <!-- Change Role only for Leader -->
                <c:when test="${myMember.teamRole=='Leader' && m.userID!=sessionScope.username}">
                  <form method="post" action="${ctx}/team/manage" style="display:inline">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="teamID" value="${team.teamID}"/>
                    <input type="hidden" name="action" value="changeRole"/>
                    <input type="hidden" name="userID" value="${m.userID}"/>
                    <select name="newRole">
                      <option value="Member"   ${m.teamRole=='Member'?'selected':''}>Member</option>
                      <option value="Co-Leader"${m.teamRole=='Co-Leader'?'selected':''}>Co-Leader</option>
                    </select>
                    <button type="submit">Update</button>
                  </form>
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- Join Requests (for Leader/Co-Leader) -->
    <c:if test="${myMember.teamRole=='Leader' || myMember.teamRole=='Co-Leader'}">
      <h3>Join Requests</h3>
      <table class="stations-table">
        <thead><tr><th>#</th><th>User</th><th>Requested</th><th>Action</th></tr></thead>
        <tbody>
          <c:forEach var="r" items="${joinRequests}" varStatus="st">
            <tr>
              <td>${st.index+1}</td>
              <td>${r.userID}</td>
              <td><fmt:formatDate value="${r.requestedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
              <td>
                <form method="post" action="${ctx}/team/joinRequest/respond" style="display:inline">
                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                  <input type="hidden" name="requestID" value="${r.requestID}"/>
                  <button name="action" value="accept">Accept</button>
                </form>
                <form method="post" action="${ctx}/team/joinRequest/respond" style="display:inline">
                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                  <input type="hidden" name="requestID" value="${r.requestID}"/>
                  <button name="action" value="reject">Reject</button>
                </form>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

  </div>
</div>
<jsp:include page="/footer.jsp"/>
