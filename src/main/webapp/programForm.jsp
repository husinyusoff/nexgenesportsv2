<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title><c:out value="${program.progID != null ? 'Edit' : 'New'}"/> Program</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
  <script>
    function toggleTournamentFields() {
      var type = document.getElementById('programType').value;
      document.getElementById('tournamentFields').style.display =
        (type==='TOURNAMENT'?'block':'none');
    }
    window.addEventListener('load', toggleTournamentFields);
  </script>
</head>
<body>
  <h1><c:out value="${program.progID != null ? 'Edit' : 'New'}"/> Program</h1>

  <form action="${pageContext.request.contextPath}/programs/${program.progID != null ? program.progID + '/save' : 'create'}"
        method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

    <!-- Core -->
    <div>
      <label>Name:</label><br/>
      <input type="text" name="programName" value="${program.programName}" required/>
    </div>
    <div>
      <label>Description:</label><br/>
      <textarea name="description" rows="3">${program.description}</textarea>
    </div>
    <div>
      <label>Type:</label><br/>
      <select id="programType" name="programType" onchange="toggleTournamentFields()">
        <option value="TOURNAMENT"
          <c:if test="${program.programType=='TOURNAMENT'}">selected</c:if>
        >Tournament</option>
        <option value="EVENT"
          <c:if test="${program.programType=='EVENT'}">selected</c:if>
        >Event</option>
      </select>
    </div>

    <!-- Tournament fields -->
    <div id="tournamentFields" style="margin-top:1em;">
      <fieldset style="border:1px solid #ccc; padding:1em;">
        <legend>Tournament Settings</legend>

        <div>
          <label>Game ID:</label><br/>
          <input type="text" name="gameID" value="${program.gameID}"/>
        </div>
        <div>
          <label>Capacity:</label><br/>
          <input type="number" name="capacity" min="1" value="${program.capacity}"/>
        </div>
        <div>
          <label>Mode:</label><br/>
          <select name="tournamentMode">
            <option value="SOLO"
              <c:if test="${program.tournamentMode=='SOLO'}">selected</c:if>
            >Solo</option>
            <option value="TEAM"
              <c:if test="${program.tournamentMode=='TEAM'}">selected</c:if>
            >Team</option>
          </select>
        </div>
        <div>
          <label>Max Team Members:</label><br/>
          <input type="number" name="maxTeamMember" min="1" value="${program.maxTeamMember}"/>
        </div>
        <div>
          <label>Fee:</label><br/>
          <input type="text" name="progFee" value="${program.progFee}"/>
        </div>
        <div>
          <label>Prize Pool:</label><br/>
          <input type="text" name="prizePool" value="${program.prizePool}"/>
        </div>
        <div>
          <label>
            <input type="checkbox" name="openSignup"
              <c:if test="${program.openSignup}">checked</c:if> />
            Open Signup
          </label>
        </div>

        <!-- Sync button only if ACTIVE -->
        <c:if test="${program.status=='ACTIVE'}">
          <div style="margin-top:0.5em;">
            <button formaction="${pageContext.request.contextPath}/programs/${program.progID}/sync"
                    formmethod="post">Sync with Challonge</button>
          </div>
        </c:if>
      </fieldset>
    </div>

    <!-- Shared schedule -->
    <fieldset style="border:1px solid #ccc; padding:1em; margin-top:1em;">
      <legend>Schedule</legend>
      <div>
        <label>Start Date:</label><br/>
        <input type="date" name="startDate" value="${program.startDate}" required/>
      </div>
      <div>
        <label>End Date:</label><br/>
        <input type="date" name="endDate" value="${program.endDate}" required/>
      </div>
      <div>
        <label>Override Start (date/time):</label><br/>
        <input type="datetime-local" name="startAt" value="${program.startAt}"/>
      </div>
      <div>
        <label>Override End (date/time):</label><br/>
        <input type="datetime-local" name="endAt" value="${program.endAt}"/>
      </div>
    </fieldset>

    <div style="margin-top:1em;">
      <button type="submit">Save</button>
      <a href="${pageContext.request.contextPath}/programs">Cancel</a>
    </div>
  </form>
</body>
</html>
