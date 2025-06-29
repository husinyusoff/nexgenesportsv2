<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Create Program / Tournament</title>
        <link rel="stylesheet" href="${ctx}/static/css/main.css"/>
    </head>
    <body>
        <jsp:include page="/sidebar.jsp"/>

        <main>
            <h1>Create Program / Tournament</h1>

            <!-- Error display -->
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form action="${ctx}/programs/new" method="post">
                <!-- hidden fields -->
                <input type="hidden" name="creatorId" value="${sessionScope.username}"/>
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <!-- Program vs Tournament -->
                <div class="form-group">
                    <label for="programType">Type</label>
                    <select id="programType" name="programType" required>
                        <option value="">-- select --</option>
                        <option value="PROGRAM">Program</option>
                        <option value="TOURNAMENT">Tournament</option>
                    </select>
                </div>

                <!-- Game (only for tournaments) -->
                <div class="form-group" id="gameGroup" style="display:none;">
                    <label for="gameId">Game</label>
                    <select id="gameId" name="gameId">
                        <option value="">-- select game --</option>
                        <c:forEach var="g" items="${games}">
                            <option value="${g.gameID}">${g.gameName}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Merit level -->
                <div class="form-group">
                    <label for="meritScope">Level</label>
                    <select id="meritScope" name="meritScope" required>
                        <option value="">-- select level --</option>
                        <c:forEach var="scope" items="${scopes}">
                            <option value="${scope}">${scope}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Name -->
                <div class="form-group">
                    <label for="programName">Name</label>
                    <input id="programName" name="programName" type="text" required/>
                </div>

                <!-- Place -->
                <div class="form-group">
                    <label for="place">Place</label>
                    <input id="place" name="place" type="text"/>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3"></textarea>
                </div>

                <!-- Entry Fee -->
                <div class="form-group">
                    <label for="progFee">Entry Fee (RM)</label>
                    <input id="progFee" name="progFee" type="number" step="0.01" value="0.00"/>
                </div>

                <!-- Prize Pool -->
                <div class="form-group">
                    <label for="prizePool">Prize Pool (RM)</label>
                    <input id="prizePool" name="prizePool" type="number" step="0.01"/>
                </div>

                <!-- Dates & Times -->
                <fieldset>
                    <legend>Dates &amp; Times</legend>
                    <div class="form-group">
                        <label for="startDate">Start Date</label>
                        <input id="startDate" name="startDate" type="date" required/>
                    </div>
                    <div class="form-group">
                        <label for="startTime">Start Time</label>
                        <input id="startTime" name="startTime" type="time"/>
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date</label>
                        <input id="endDate" name="endDate" type="date" required/>
                    </div>
                    <div class="form-group">
                        <label for="endTime">End Time</label>
                        <input id="endTime" name="endTime" type="time"/>
                    </div>
                </fieldset>

                <!-- Max Capacity -->
                <div class="form-group">
                    <label for="maxCapacity">Max Capacity</label>
                    <input id="maxCapacity" name="maxCapacity" type="number" value="1" required/>
                </div>

                <!-- Max Team Members (only for tournaments) -->
                <div class="form-group" id="teamMemberGroup" style="display:none;">
                    <label for="maxTeamMember">Max Team Members</label>
                    <input id="maxTeamMember" name="maxTeamMember" type="number" value="1"/>
                </div>

                <button type="submit">Create</button>
                <a href="${ctx}/programs">Cancel</a>
            </form>
        </main>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const typeSel = document.getElementById('programType');
                const gameGrp = document.getElementById('gameGroup');
                const teamGrp = document.getElementById('teamMemberGroup');

                typeSel.addEventListener('change', () => {
                    const isTour = typeSel.value === 'TOURNAMENT';
                    gameGrp.style.display = isTour ? 'block' : 'none';
                    teamGrp.style.display = isTour ? 'block' : 'none';
                });
            });
        </script>
    </body>
</html>
