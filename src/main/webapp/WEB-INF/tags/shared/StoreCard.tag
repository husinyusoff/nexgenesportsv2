<%@ tag description="Store/Pricing Card Component" pageEncoding="UTF-8"%>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" type="java.lang.String" %>
<%@ attribute name="price" required="true" type="java.lang.String" %>
<%@ attribute name="isPremium" required="false" type="java.lang.Boolean" %>
<%@ attribute name="actionLabel" required="false" type="java.lang.String" %>
<%@ attribute name="actionVariant" required="false" type="java.lang.String" %>

<div class="store-card ${isPremium != null && isPremium ? 'premium' : ''}">
    <div class="store-card-header">
        <h3>${title}</h3>
    </div>
    <div class="store-card-price">
        ${price}
    </div>
    <div class="store-card-body">
        <jsp:doBody/>
    </div>
    <c:if test="${not empty actionLabel}">
        <div class="store-card-actions">
            <t:Button variant="${empty actionVariant ? 'primary' : actionVariant}">${actionLabel}</t:Button>
        </div>
    </c:if>
</div>
