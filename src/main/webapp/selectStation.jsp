<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Select Station &amp; Players – NexGen Esports</title>
        <link rel="stylesheet" href="styles.css">
        <script>
            function onStationChange(radio) {
                var twoOpt = document.getElementById('opt-2-players');
                if (radio.value === 'RSM') {
                    twoOpt.disabled = true;
                    twoOpt.text = '2 Players (Not Available)';
                } else {
                    twoOpt.disabled = false;
                    twoOpt.text = '2 Players';
                }
            }
        </script>
    </head>
    <body class="app-wrapper">
        <%@ include file="header.jsp" %>

        <div class="main-container">
            <%@ include file="sidebar.jsp" %>
            
            <main class="content">
                <div class="glass-card" style="width: 100%; max-width: 900px; margin: 0 auto; position: relative;">
                    <a href="javascript:history.back()" class="back-link" aria-label="Go Back" style="color: var(--neon-cyan); text-decoration: none; margin-bottom: 20px; display: inline-block;">
                        &larr; Back
                    </a>
                    
                    <div class="module-header">
                        <h2>SELECT SESSION</h2>
                    </div>

                    <form method="get" action="${pageContext.request.contextPath}/bookStation">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        
                        <div style="overflow-x: auto; margin-bottom: 20px;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Select</th><th>Station ID</th><th>Name</th>
                                        <th>Normal (1P)</th><th>Normal (2P)</th>
                                        <th>Happy (1P)</th><th>Happy (2P)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${stations}">
                                        <tr>
                                            <td style="text-align: center;">
                                                <input type="radio" name="stationID"
                                                       value="${s.stationID}"
                                                       required onchange="onStationChange(this)" style="transform: scale(1.5); accent-color: var(--neon-cyan);" />
                                            </td>
                                            <td>${s.stationID}</td>
                                            <td>${s.stationName}</td>
                                            <td>RM${s.normalPrice1Player}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty s.normalPrice2Player}">
                                                        RM${s.normalPrice2Player}
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>RM${s.happyHourPrice1Player}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty s.happyHourPrice2Player}">
                                                        RM${s.happyHourPrice2Player}
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="player-count-wrapper" style="margin-bottom: 25px;">
                            <label for="playerCount" class="label">Number of Players:</label>
                            <select name="playerCount" id="playerCount" class="input-field" required style="width: auto; min-width: 200px;">
                                <option value="1">1 Player</option>
                                <option value="2" id="opt-2-players">2 Players</option>
                            </select>
                        </div>

                        <div class="buttons" style="display: flex; gap: 15px;">
                            <button type="submit" class="btn btn-primary" style="flex: 1; max-width: 200px;">Next</button>
                            <button type="button"
                                    onclick="window.location = '${pageContext.request.contextPath}/dashboard.jsp';"
                                    class="btn btn-danger" style="flex: 1; max-width: 200px;">
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <%@ include file="footer.jsp" %>
    </body>
</html>
