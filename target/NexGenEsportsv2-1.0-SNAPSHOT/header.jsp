<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!— shared top bar —>
<div class="header">
  <img src="${pageContext.request.contextPath}/images/umt-logo.png"
       alt="UMT Logo" class="logo umt-logo">
  <img src="${pageContext.request.contextPath}/images/esports-logo.png"
       alt="Esports Logo" class="logo esports-logo">
  <h1>NEXGEN ESPORTS</h1>
  <c:if test="${not empty sessionScope.username}">
    <div class="user-avatar">
      <span>${sessionScope.username}</span>
    </div>
  </c:if>
</div>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!— shared top bar —>
<div class="header">
  <img src="${pageContext.request.contextPath}/images/umt-logo.png"
       alt="UMT Logo" class="logo umt-logo">
  <img src="${pageContext.request.contextPath}/images/esports-logo.png"
       alt="Esports Logo" class="logo esports-logo">
  <h1>NEXGEN ESPORTS</h1>
  <c:if test="${not empty sessionScope.username}">
    <div class="user-avatar">
      <span>${sessionScope.username}</span>
    </div>
  </c:if>
</div>
