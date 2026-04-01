<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<c:set    var="ctx"     value="${pageContext.request.contextPath}"/>

<jsp:include page="/header.jsp"/>
<div class="container">
  <h2>Challonge Bracket</h2>

  <c:choose>
    <c:when test="${mapping == null}">
      <p>No bracket has been generated yet for program ${progId}.</p>
      <form method="post" action="${ctx}/programs/challonge">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="progId"   value="${progId}"/>
        <button class="btn blue-btn">Generate Bracket</button>
      </form>
    </c:when>

    <c:otherwise>
      <p>
        <strong>Public URL:</strong>
        <a href="https://challonge.com/${mapping.challongeUrl}" target="_blank">
          challonge.com/${mapping.challongeUrl}
        </a>
      </p>

      <iframe
        src="https://challonge.com/${mapping.challongeUrl}/module"
        style="width:100%; height:600px; border:none;"
        title="Tournament bracket">
      </iframe>

      <br/><br/>
      <a href="${ctx}/programs/challonge/edit?progId=${progId}"
         class="btn small green-btn">Edit Info</a>

      <form method="post"
            action="${ctx}/programs/challonge/delete"
            style="display:inline"
            onsubmit="return confirm('Really delete this bracket?')">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="progId"   value="${progId}"/>
        <button class="btn small red-btn">Delete</button>
      </form>
    </c:otherwise>
  </c:choose>

</div>
<jsp:include page="/footer.jsp"/>
