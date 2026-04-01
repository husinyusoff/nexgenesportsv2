<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container" style="display:flex;">
  <div class="sidebar">
    <jsp:include page="/sidebar.jsp"/>
  </div>
  <div class="content">
    <h2>Edit Program/Tournament</h2>
    <c:if test="${not empty error}">
      <div class="error">${error}</div>
    </c:if>
    <form method="post" action="${ctx}/programs/edit">
      <input type="hidden" name="csrfToken"
             value="${sessionScope.csrfToken}"/>
      <input type="hidden" name="progId" value="${program.progId}"/>
      <input type="hidden" name="creatorId" value="${program.creatorId}"/>

      <!-- reuse same fields as create -->
      <label>Game:</label><br/>
      <select name="gameId">
        <c:forEach var="g" items="${games}">
          <option value="${g.gameId}"
            ${program.gameId == g.gameId ? 'selected':''}>
            ${g.gameName}
          </option>
        </c:forEach>
      </select><br/><br/>

      <!-- ... same inputs as create, prepopulated ... -->
      <!-- omit for brevity; copy the fields from programCreate.jsp, using
           value="${program.xxx}" and selected="${program.yyy==value}" ... -->

      <label>Status:</label><br/>
      <select name="status">
        <option value="PENDING_APPROVAL"
          ${program.status=='PENDING_APPROVAL'?'selected':''}>
          PENDING_APPROVAL
        </option>
        <option value="OPEN"
          ${program.status=='OPEN'?'selected':''}>
          OPEN
        </option>
        <option value="CLOSED"
          ${program.status=='CLOSED'?'selected':''}>
          CLOSED
        </option>
        <option value="COMPLETED"
          ${program.status=='COMPLETED'?'selected':''}>
          COMPLETED
        </option>
        <option value="CANCELLED"
          ${program.status=='CANCELLED'?'selected':''}>
          CANCELLED
        </option>
        <option value="REJECTED"
          ${program.status=='REJECTED'?'selected':''}>
          REJECTED
        </option>
      </select><br/><br/>

      <button type="submit" class="btn blue-btn">Save</button>
      <button type="button"
              onclick="location.href='${ctx}/programs/detail?progId=${program.progId}'">
        Cancel
      </button>
    </form>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
