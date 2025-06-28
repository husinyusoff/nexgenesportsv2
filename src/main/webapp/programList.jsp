<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container" style="display:flex">
  <div class="sidebar">
    <jsp:include page="/sidebar.jsp"/>
  </div>
  <div class="content">
    <h2>Programs &amp; Tournaments</h2>
    <button class="btn blue-btn"
            onclick="location.href='${ctx}/programs/new'">
      CREATE NEW
    </button>
    <table class="summary-table" style="margin-top:1em;">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Type</th>
          <th>Status</th>
          <th>Dates</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="pt" items="${programs}">
          <tr>
            <td>${pt.progId}</td>
            <td>${pt.programName}</td>
            <td>${pt.programType}</td>
            <td>${pt.status}</td>
            <td>
              <fmt:formatDate value="${pt.startDate}" pattern="yyyy-MM-dd"/>
              –
              <fmt:formatDate value="${pt.endDate}"   pattern="yyyy-MM-dd"/>
            </td>
            <td>
              <a href="${ctx}/programs/detail?progId=${pt.progId}"
                 class="btn green-btn">DETAILS</a>
              <c:if test="${pt.status == 'PENDING_APPROVAL'}">
                <form class="inline-form"
                      action="${ctx}/programs/approve"
                      method="post" style="display:inline">
                  <input type="hidden" name="progId" value="${pt.progId}"/>
                  <input type="hidden" name="csrfToken"
                         value="${sessionScope.csrfToken}"/>
                  <button type="submit" class="btn blue-btn">
                    APPROVE
                  </button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
