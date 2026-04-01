<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container" style="display:flex;">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">
    <h2>Create Bracket for ${param.progId}</h2>
    <form method="post" action="${ctx}/brackets/create">
      <input type="hidden" name="csrfToken"
             value="${sessionScope.csrfToken}"/>
      <input type="hidden" name="progId" value="${param.progId}"/>

      <label>Name:</label><br/>
      <input type="text" name="name" required/><br/><br/>

      <label>Format:</label><br/>
      <select name="format">
        <option value="SINGLE_ELIM">Single Elimination</option>
        <option value="DOUBLE_ELIM">Double Elimination</option>
        <option value="ROUND_ROBIN">Round Robin</option>
        <option value="LEADERBOARD">Leaderboard</option>
      </select><br/><br/>

      <button type="submit" class="btn blue-btn">Create</button>
      <button type="button"
              onclick="location.href='${ctx}/programs/detail?progId=${param.progId}'">
        Cancel
      </button>
    </form>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
