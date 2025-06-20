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
    <body>
        <%@ include file="header.jsp" %>

        <div class="container">
            <div class="sidebar">
                <%@ include file="sidebar.jsp" %>
                <button class="close-toggle">×</button>
            </div>

            <div class="content">
                <div class="select-station-box">
                    <a href="javascript:history.back()" class="back-link" aria-label="Go Back">
                        <!-- your SVG arrow here -->
                    </a>
                    <h2>SELECT SESSION</h2>

                    <form method="get" action="${pageContext.request.contextPath}/bookStation">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        <table class="select-station-table">
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
                                        <td>
                                            <input type="radio" name="stationID"
                                                   value="${s.stationID}"
                                                   required onchange="onStationChange(this)" />
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

                        <div class="player-count-wrapper">
                            <label for="playerCount">Number of Players:</label>
                            <select name="playerCount" id="playerCount" required>
                                <option value="1">1 Player</option>
                                <option value="2" id="opt-2-players">2 Players</option>
                            </select>
                        </div>

                        <div class="buttons">
                            <button type="submit" class="button green-button">Next</button>
                            <button type="button"
                                    onclick="window.location = '${pageContext.request.contextPath}/dashboard.jsp';"
                                    class="button blue-button cancel-btn">
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
        <button class="open-toggle">☰</button>
    </body>
</html>
