<%@ tag description="Empty State Table Fallback" pageEncoding="UTF-8"%>
<%@ attribute name="icon" required="false" type="java.lang.String" %>
<%@ attribute name="message" required="true" type="java.lang.String" %>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>

<div class="empty-state ${not empty cssClass ? cssClass : ''}">
    <div class="empty-icon">${not empty icon ? icon : '∅'}</div>
    <p class="empty-message">${message}</p>
    <jsp:doBody/>
</div>
