<%@ tag description="Shared GlassCard Component" pageEncoding="UTF-8"%>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>

<div class="glass-card ${not empty cssClass ? cssClass : ''}">
    <jsp:doBody/>
</div>
