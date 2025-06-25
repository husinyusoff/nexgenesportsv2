<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/header.jsp"/>
<div class="container">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">
    <h2>My Join Requests</h2>
    <table class="stations-table">
      <thead><tr><th>#</th><th>Team</th><th>Requested</th><th>Status</th></tr></thead>
      <tbody>
        <c:forEach var="r" items="${myRequests}" varStatus="st">
          <tr>
            <td>${st.index+1}</td>
            <td><a href="${ctx}/team/detail?teamID=${r.teamID}">${r.teamName}</a></td>
            <td><fmt:formatDate value="${r.requestedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td>${r.status}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
