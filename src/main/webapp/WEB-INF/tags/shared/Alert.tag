<%@ tag description="Toast / Alert Message Component" pageEncoding="UTF-8"%>
<%@ attribute name="variant" required="true" type="java.lang.String" %> <!-- error, success -->
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>
<div class="${variant == 'error' ? 'error-msg' : 'success-msg'} ${not empty cssClass ? cssClass : ''}">
    <jsp:doBody/>
</div>
