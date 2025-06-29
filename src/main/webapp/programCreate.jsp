<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
    List<String> scopes = (List<String>) request.getAttribute("scopes");
    List<String> formats = (List<String>) request.getAttribute("formats");
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

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form action="${ctx}/programs/new" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" name="creatorId"  value="${sessionScope.username}"/>

                <!-- 1) Type -->
                <div class="form-group">
                    <label for="programType">Type</label>
                    <select id="programType" name="programType" required>
                        <option value="">-- select --</option>
                        <option value="PROGRAM">Program</option>
                        <option value="TOURNAMENT">Tournament</option>
                    </select>
                </div>

                <div id="levelGroup" class="form-group" style="display:none;">
                    <label for="meritScope">Level</label>
                    <select id="meritScope" name="meritScope" required>
                        <option value="">-- select level --</option>
                        <c:forEach var="sc" items="${scopes}">
                            <option value="${sc}">${sc}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 2) Game -->
                <div id="gameGroup" class="form-group" style="display:none;">
                    <label for="gameId">Game</label>
                    <select id="gameId" name="gameId">
                        <option value="">-- select game --</option>
                        <c:forEach var="g" items="${games}">
                            <option value="${g.gameID}">${g.gameName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div id="bracketFormatGroup" class="form-group" style="display:none;">
                    <label for="bracketFormat">Bracket Format</label>
                    <select id="bracketFormat" name="bracketFormat" required>
                        <option value="">-- select format --</option>
                        <c:forEach var="fmt" items="${formats}">
                            <option value="${fmt}">${fmt.replace('_',' ')}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 4) Name -->
                <div class="form-group">
                    <label for="programName">Name</label>
                    <input id="programName" name="programName" type="text" required/>
                </div>

                <!-- 5) Place -->
                <div class="form-group">
                    <label for="place">Place</label>
                    <input id="place" name="place" type="text"/>
                </div>

                <!-- 6) Description -->
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3"></textarea>
                </div>

                <!-- 7) Entry Fee -->
                <div class="form-group">
                    <label for="progFee">Entry Fee (RM)</label>
                    <input id="progFee" name="progFee" type="number" step="0.01" value="0.00"/>
                </div>

                <!-- 8) Prize Pool -->
                <div class="form-group">
                    <label for="prizePool">Prize Pool</label>
                    <input id="prizePool" name="prizePool" type="number" step="0.01"/>
                </div>

                <!-- 9) Dates -->
                <fieldset class="form-group">
                    <legend>Dates &amp; Times</legend>
                    <label for="startDate">Start Date</label>
                    <input id="startDate" name="startDate" type="date" required/>
                    <label for="startTime">Start Time</label>
                    <input id="startTime" name="startTime" type="time"/>
                    <label for="endDate">End Date</label>
                    <input id="endDate" name="endDate" type="date" required/>
                    <label for="endTime">End Time</label>
                    <input id="endTime" name="endTime" type="time"/>
                </fieldset>

                <!-- 10) Max Capacity -->
                <div class="form-group">
                    <label for="maxCapacity">Max Capacity</label>
                    <input id="maxCapacity" name="maxCapacity" type="number" value="1" required/>
                </div>

                <!-- 11) Max Team Members -->
                <div id="teamMemberGroup" class="form-group" style="display:none;">
                    <label for="maxTeamMember">Max Team Members</label>
                    <input id="maxTeamMember" name="maxTeamMember" type="number"/>
                </div>

                <button type="submit">Create</button>
                <a href="${ctx}/programs">Cancel</a>
            </form>
        </main>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const typeSel = document.getElementById('programType');
                const gameGroup = document.getElementById('gameGroup');
                const levelGroup = document.getElementById('levelGroup');
                const teamGroup = document.getElementById('teamMemberGroup');
                const fmtGroup = document.getElementById('bracketFormatGroup');

                typeSel.addEventListener('change', () => {
                    const isTour = typeSel.value === 'TOURNAMENT';
                    gameGroup.style.display = isTour ? 'block' : 'none';
                    teamGroup.style.display = isTour ? 'block' : 'none';
                    levelGroup.style.display = isTour ? 'block' : 'none';
                    fmtGroup.style.display = isTour ? 'block' : 'none';
                });
            });
        </script>
    </body>
</html>
