<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Create Program / Tournament</title>
    <link rel="stylesheet" href="${ctx}/static/css/main.css" />
</head>
<body>
<jsp:include page="/sidebar.jsp" />

<main>
    <h1>Create Program / Tournament</h1>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form action="${ctx}/programs/new" method="post">
        <!-- CSRF token, if you use one -->
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

        <div class="form-group">
            <label for="progId">Program ID</label>
            <input type="text" id="progId" name="progId" value="${param.progId}" required />
        </div>

        <div class="form-group">
            <label for="creatorId">Creator ID</label>
            <input type="text" id="creatorId" name="creatorId" value="${param.creatorId}" required />
        </div>

        <div class="form-group">
            <label for="gameId">Game</label>
            <select id="gameId" name="gameId" required>
                <option value="">-- select game --</option>
                <c:forEach var="g" items="${games}">
                    <option value="${g.gameID}">${g.gameName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="programName">Name</label>
            <input type="text" id="programName" name="programName" required />
        </div>

        <div class="form-group">
            <label for="programType">Type</label>
            <input type="text" id="programType" name="programType" required />
        </div>

        <div class="form-group">
            <label for="meritId">Merit Level</label>
            <select id="meritId" name="meritId">
                <option value="">-- none --</option>
                <c:forEach var="m" items="${merits}">
                    <option value="${m.meritID}">${m.levelName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="place">Place</label>
            <input type="text" id="place" name="place" />
        </div>

        <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description" name="description" rows="4"></textarea>
        </div>

        <div class="form-group">
            <label for="progFee">Entry Fee</label>
            <input type="number" step="0.01" id="progFee" name="progFee" />
        </div>

        <fieldset>
            <legend>Dates &amp; Times</legend>
            <div class="form-group">
                <label for="startDate">Start Date</label>
                <input type="date" id="startDate" name="startDate" required />
            </div>
            <div class="form-group">
                <label for="startTime">Start Time</label>
                <input type="time" id="startTime" name="startTime" />
            </div>
            <div class="form-group">
                <label for="endDate">End Date</label>
                <input type="date" id="endDate" name="endDate" required />
            </div>
            <div class="form-group">
                <label for="endTime">End Time</label>
                <input type="time" id="endTime" name="endTime" />
            </div>
        </fieldset>

        <div class="form-group">
            <label for="prizePool">Prize Pool</label>
            <input type="number" step="0.01" id="prizePool" name="prizePool" />
        </div>

        <div class="form-group">
            <label for="maxCapacity">Max Capacity</label>
            <input type="number" id="maxCapacity" name="maxCapacity" required />
        </div>

        <div class="form-group">
            <label for="maxTeamMember">Max Team Members</label>
            <input type="number" id="maxTeamMember" name="maxTeamMember" />
        </div>

        <button type="submit">Create</button>
        <a href="${ctx}/programs">Cancel</a>
    </form>
</main>
</body>
</html>
