<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/header.jsp"/>
<div class="container">
  <div class="sidebar"><jsp:include page="/sidebar.jsp"/></div>
  <div class="content">
    <h2>Create New Team</h2>
    <c:if test="${not empty error}"><div class="error">${error}</div></c:if>

    <form action="${ctx}/team/create" method="post" enctype="multipart/form-data">
      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

      <label for="teamName">Team Name:</label><br/>
      <input type="text" id="teamName" name="teamName" value="${fn:escapeXml(teamName)}" required/><br/><br/>

      <label for="description">Description:</label><br/>
      <textarea id="description" name="description" rows="4" cols="50">${fn:escapeXml(description)}</textarea><br/><br/>

      <label for="capacity">Capacity (≥2):</label><br/>
      <input type="number" id="capacity" name="capacity" min="2" value="${capacity != null ? capacity : 2}" required/><br/><br/>

      <label for="logoFile">Logo (optional):</label><br/>
      <input type="file" id="logoFile" name="logoFile" accept="image/*"/><br/><br/>

      <button type="submit">Create</button>
      <a href="${ctx}/team/list"><button type="button">Cancel</button></a>
    </form>
  </div>
</div>
<jsp:include page="/footer.jsp"/>
