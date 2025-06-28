<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container" style="display:flex;">
  <div class="sidebar">
    <jsp:include page="/sidebar.jsp"/>
  </div>
  <div class="content">
    <h2>Details: ${program.programName}</h2>

    <table>
      <tr><th>Type:</th><td>${program.programType}</td></tr>
      <tr><th>Status:</th><td>${program.status}</td></tr>
      <tr>
        <th>Dates:</th>
        <td>
          <fmt:formatDate value="${program.startDate}" pattern="yyyy-MM-dd"/> –
          <fmt:formatDate value="${program.endDate}"   pattern="yyyy-MM-dd"/>
        </td>
      </tr>
      <tr><th>Time:</th>
        <td>${program.startTime} – ${program.endTime}</td></tr>
      <tr><th>Place:</th><td>${program.place}</td></tr>
      <tr><th>Fee:</th>  <td>${program.progFee}</td></tr>
      <tr><th>Prize:</th><td>${program.prizePool}</td></tr>
      <tr><th>Capacity:</th>
        <td>${program.maxCapacity}</td></tr>
      <tr><th>Description:</th>
        <td>${program.description}</td></tr>
    </table>
    <br/>

    <h3>Participants</h3>
    <table class="summary-table">
      <thead><tr>
        <th>#</th><th>User/Team</th><th>Status</th><th>Joined</th>
      </tr></thead>
      <tbody>
        <c:forEach var="p" items="${participants}" varStatus="st">
          <tr>
            <td>${st.index + 1}</td>
            <td>
              <c:choose>
                <c:when test="${not empty p.teamId}">
                  Team ${p.teamId}
                </c:when>
                <c:otherwise>
                  ${p.userId}
                </c:otherwise>
              </c:choose>
            </td>
            <td>${p.status}</td>
            <td><fmt:formatDate value="${p.joinedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <c:if test="${program.programType == 'TOURNAMENT'}">
      <h3>Brackets</h3>
      <a href="${ctx}/brackets/create?progId=${program.progId}"
         class="btn blue-btn">New Bracket</a>
      <table class="summary-table">
        <thead><tr>
          <th>#</th><th>Name</th><th>Format</th><th>Actions</th>
        </tr></thead>
        <tbody>
          <c:forEach var="b" items="${brackets}" varStatus="bst">
            <tr>
              <td>${bst.index + 1}</td>
              <td>${b.name}</td>
              <td>${b.format}</td>
              <td>
                <a href="${ctx}/brackets/view?bracketId=${b.bracketId}"
                   class="btn green-btn">View</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

    <br/>
    <c:if test="${program.status == 'OPEN'}">
      <form action="${ctx}/programs/join" method="post">
        <input type="hidden" name="progId" value="${program.progId}"/>
        <input type="hidden" name="csrfToken"
               value="${sessionScope.csrfToken}"/>
        <c:if test="${program.programType=='TOURNAMENT'}">
          Team ID:
          <input type="text" name="teamId"/>
        </c:if>
        <button type="submit" class="btn green-btn">REGISTER</button>
      </form>
    </c:if>

    <br/>
    <a href="${ctx}/programs/edit?progId=${program.progId}"
       class="btn blue-btn">EDIT</a>
    <form action="${ctx}/programs/delete" method="post" style="display:inline">
      <input type="hidden" name="progId" value="${program.progId}"/>
      <input type="hidden" name="csrfToken"
             value="${sessionScope.csrfToken}"/>
      <button type="submit" class="btn red-btn"
              onclick="return confirm('Delete this item?')">
        DELETE
      </button>
    </form>

  </div>
</div>
<jsp:include page="/footer.jsp"/>
