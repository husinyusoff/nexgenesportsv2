<%@ tag description="Shared Field Component" pageEncoding="UTF-8"%>
<%@ attribute name="id" required="true" type="java.lang.String" %>
<%@ attribute name="label" required="true" type="java.lang.String" %>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>
<%@ attribute name="required" required="false" type="java.lang.Boolean" %>

<div class="field-container ${not empty cssClass ? cssClass : ''}">
    <label class="label" for="${id}">${label}</label>
    <jsp:doBody/>
</div>
