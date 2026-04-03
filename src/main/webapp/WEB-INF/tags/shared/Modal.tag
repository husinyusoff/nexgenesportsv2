<%@ tag description="Shared Modal Component" pageEncoding="UTF-8"%>
<%@ attribute name="id" required="true" type="java.lang.String" %>
<%@ attribute name="title" required="true" type="java.lang.String" %>

<div id="${id}" class="modal-overlay">
    <div class="glass-card modal-content">
        <div class="modal-header">
            <h3>${title}</h3>
            <button type="button" class="btn-close" onclick="document.getElementById('${id}').classList.remove('active');">&times;</button>
        </div>
        <div class="modal-body">
            <jsp:doBody/>
        </div>
    </div>
</div>
