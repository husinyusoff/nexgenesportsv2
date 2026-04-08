<%@ tag description="Shared GlassCard Component" pageEncoding="UTF-8"%>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>
<%@ attribute name="style" required="false" type="java.lang.String" %>

<div class="glass-card ${not empty cssClass ? cssClass : ''}" ${not empty style ? 'style=\"'.concat(style).concat('\"') : ''}>
    <jsp:doBody/>
</div>
