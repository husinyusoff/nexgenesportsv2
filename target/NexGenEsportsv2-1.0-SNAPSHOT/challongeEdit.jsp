<!-- src/main/webapp/WEB-INF/jsp/challongeEdit.jsp -->
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<jsp:include page="/header.jsp"/>

<div class="container">
    <h2>Edit Challonge Bracket</h2>
    <form method="post" action="${ctx}/programs/challonge/edit">
        <input type="hidden" name="csrfToken"   value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="progId" value="${mapping.progId}"/>

        <label>Name:</label><br/>
        <input type="text" name="name"
               value="${mapping.metadata}"
               required style="width:100%"/><br/><br/>

        <label>Description:</label><br/>
        <textarea name="description" rows="4" style="width:100%">
            ${mapping.metadata}
        </textarea><br/><br/>

        <button class="btn blue-btn">Save</button>
        <button type="button"
                onclick="location.href = '${ctx}/programs/challonge?progId=${mapping.progId}'">
            Cancel
        </button>
    </form>
</div>

<jsp:include page="/footer.jsp"/>
