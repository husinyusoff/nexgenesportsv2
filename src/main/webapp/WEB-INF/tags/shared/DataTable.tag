<%@ tag description="Data Table Wrapper" pageEncoding="UTF-8"%>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>
<div style="overflow-x: auto;">
    <table class="data-table ${not empty cssClass ? cssClass : ''}">
        <jsp:doBody/>
    </table>
</div>
