<%@ tag description="Status Badge Component" pageEncoding="UTF-8"%>
<%@ attribute name="variant" required="true" type="java.lang.String" %> <!-- success, warning, premium -->
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>

<span class="badge badge-${variant} ${not empty cssClass ? cssClass : ''}">
    <jsp:doBody/>
</span>
