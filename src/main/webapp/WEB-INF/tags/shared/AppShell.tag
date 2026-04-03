<%@ tag description="AppShell Layout Wrapping Component" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>
<%@ attribute name="hideSidebar" required="false" type="java.lang.Boolean" %>

<div class="app-wrapper ${not empty cssClass ? cssClass : ''}">
    <jsp:include page="/header.jsp"/>
    <div class="main-container">
        <c:if test="${empty hideSidebar or not hideSidebar}">
            <jsp:include page="/sidebar.jsp"/>
        </c:if>
        <div class="content">
            <jsp:doBody/>
        </div>
    </div>
    <jsp:include page="/footer.jsp"/>
</div>
