<%@ tag description="Tab Switcher Navigation Wrapper" pageEncoding="UTF-8"%>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>

<div class="tab-switcher ${not empty cssClass ? cssClass : ''}">
    <jsp:doBody/>
</div>
