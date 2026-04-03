<%@ tag description="Shared Button Component" pageEncoding="UTF-8"%>
<%@ attribute name="type" required="false" type="java.lang.String" %>
<%@ attribute name="variant" required="false" type="java.lang.String" %>
<%@ attribute name="cssClass" required="false" type="java.lang.String" %>
<%@ attribute name="id" required="false" type="java.lang.String" %>
<%@ attribute name="onClick" required="false" type="java.lang.String" %>

<button 
    type="${empty type ? 'button' : type}" 
    class="btn ${empty variant ? 'btn-primary' : 'btn-'.concat(variant)} ${not empty cssClass ? cssClass : ''}"
    ${not empty id ? 'id=\"'.concat(id).concat('\"') : ''}
    ${not empty onClick ? 'onclick=\"'.concat(onClick).concat('\"') : ''}>
    <jsp:doBody/>
</button>
