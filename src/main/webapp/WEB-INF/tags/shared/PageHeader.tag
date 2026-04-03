<%@ tag description="Shared PageHeader Component" pageEncoding="UTF-8"%>
<%@ attribute name="title" required="true" type="java.lang.String" %>

<div class="module-header">
    <h2>${title}</h2>
    <div class="header-actions">
        <jsp:doBody/>
    </div>
</div>
