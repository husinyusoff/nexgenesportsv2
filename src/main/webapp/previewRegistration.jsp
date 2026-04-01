<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<jsp:include page="/header.jsp"/>

<h2>Review Registration for “${program.programName}”</h2>

<c:if test="${not empty mainPlayers}">
  <p><strong>Main players:</strong></p>
  <ul>
    <c:forEach var="p" items="${mainPlayers}">
      <li>${p}</li>
    </c:forEach>
  </ul>
</c:if>

<c:if test="${not empty subPlayers}">
  <p><strong>Sub-players:</strong></p>
  <ul>
    <c:forEach var="p" items="${subPlayers}">
      <li>${p}</li>
    </c:forEach>
  </ul>
</c:if>

<form action="${ctx}/redirectToPayment" method="post">
  <input type="hidden" name="csrfToken"      value="${sessionScope.csrfToken}"/>
  <input type="hidden" name="registrationID" value="${registrationId}"/>
  <input type="hidden" name="amount"         value="${amount}"/>
  <input type="hidden" name="progId"         value="${progId}"/>
  <input type="hidden" name="teamId"         value="${teamId}"/>

  <c:choose>
    <c:when test="${not empty teamId}">
      <c:choose>
        <c:when test="${program.programType eq 'TOURNAMENT'}">
          <input type="hidden" name="module" value="tournament-team"/>
        </c:when>
        <c:otherwise>
          <input type="hidden" name="module" value="program-team"/>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <c:choose>
        <c:when test="${program.programType eq 'TOURNAMENT'}">
          <input type="hidden" name="module" value="tournament-solo"/>
        </c:when>
        <c:otherwise>
          <input type="hidden" name="module" value="program-solo"/>
        </c:otherwise>
      </c:choose>
    </c:otherwise>
  </c:choose>

  <button type="submit" class="btn">Pay &amp; Register</button>
</form>

<jsp:include page="/footer.jsp"/>
