<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container" style="display:flex;">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">
    <h2>Edit Bracket</h2>
    <form method="post" action="${ctx}/brackets/edit">
      <input type="hidden" name="csrfToken"
             value="${sessionScope.csrfToken}"/>
      <input type="hidden" name="bracketId"
             value="${bracket.bracketId}"/>

      <label>Name:</label><br/>
      <input type="text" name="name"
             value="${bracket.name}" required/><br/><br/>

      <label>Format:</label><br/>
      <select name="format">
        <option value="SINGLE_ELIM"
          ${bracket.format=='SINGLE_ELIM'?'selected':''}>
          Single Elimination
        </option>
        <option value="DOUBLE_ELIM"
          ${bracket.format=='DOUBLE_ELIM'?'selected':''}>
          Double Elimination
        </option>
        <option value="ROUND_ROBIN"
          ${bracket.format=='ROUND_ROBIN'?'selected':''}>
          Round Robin
        </option>
        <option value="LEADERBOARD"
          ${bracket.format=='LEADERBOARD'?'selected':''}>
          Leaderboard
        </option>
      </select><br/><br/>

      <button type="submit" class="btn blue-btn">Save</button>
      <button type="button"
              onclick="location.href='${ctx}/brackets/view?bracketId=${bracket.bracketId}'">
        Cancel
      </button>
    </form>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
