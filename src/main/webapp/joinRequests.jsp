<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Join Requests – NexGen Esports</title>
  <link rel="stylesheet" href="${ctx}/styles.css">
</head>
<body>
  <jsp:include page="/header.jsp"/>

  <h1>JOIN REQUESTS</h1>

  <c:if test="${empty requests}">
    <p>No pending requests.</p>
  </c:if>

  <c:if test="${not empty requests}">
    <table border="1" cellpadding="5" cellspacing="0" width="100%">
      <thead style="background:#76c7ff;">
        <tr>
          <th>No.</th>
          <th>Name</th>
          <th>Team</th>
          <th>Requested At</th>
          <th>Personal Score</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="jr" items="${requests}" varStatus="st">
          <tr>
            <td>${st.index + 1}</td>
            <td><c:out value="${jr.userID}"/></td>
            <td><c:out value="${teamNameMap[jr.teamID]}"/></td>
            <td>${fn:replace(jr.requestedAt,'T',' ')}</td>
            <td>-- placeholder --</td>
            <td>
              <form action="${ctx}/team/joinRequests" method="post" style="display:inline">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" name="teamID"     value="${jr.teamID}"/>
                <input type="hidden" name="requestID"  value="${jr.requestID}"/>
                <input type="hidden" name="decision"   value="accept"/>
                <button type="submit">ACCEPT</button>
              </form>
              <form action="${ctx}/team/joinRequests" method="post" style="display:inline">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" name="teamID"     value="${jr.teamID}"/>
                <input type="hidden" name="requestID"  value="${jr.requestID}"/>
                <input type="hidden" name="decision"   value="reject"/>
                <button type="submit">REJECT</button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>

  <jsp:include page="/footer.jsp"/>
</body>
</html>
