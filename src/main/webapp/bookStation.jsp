<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Book Gaming Station – NexGen Esports</title>
        <link rel="stylesheet" href="styles.css" />
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container">
            <div class="sidebar"><%@ include file="sidebar.jsp" %></div>
            <div class="content">
                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>

                <div class="book-station-container">
                    <h2>Book Gaming Station</h2>
                    <p><strong>Station:</strong> ${stationName}</p>
                    <p><strong>Players:</strong> ${playerCount}</p>
                    <!-- show chosen date once slots are displayed -->
                    <c:if test="${showSlots}">
                        <p><strong>Date:</strong> ${selectedDate}</p>
                    </c:if>

                    <c:choose>
                        <c:when test="${not showSlots}">
                            <form method="get" action="${pageContext.request.contextPath}/bookStation">
                                <input type="hidden" name="csrfToken"  value="${sessionScope.csrfToken}"/>
                                <input type="hidden" name="stationID"  value="${stationID}" />
                                <input type="hidden" name="playerCount" value="${playerCount}" />

                                <label for="date">Select Date:</label>
                                <input type="date"
                                       id="date"
                                       name="date"
                                       min="${minDate}"
                                       required />

                                <button type="submit" class="button blue-button">
                                    View Slots
                                </button>
                            </form>
                        </c:when>

                        <c:otherwise>
                            <form method="post" action="${pageContext.request.contextPath}/bookStation"
                                  onsubmit="return validateSelection()">
                                <input type="hidden" name="csrfToken"   value="${sessionScope.csrfToken}"/>
                                <input type="hidden" name="stationID"    value="${stationID}" />
                                <input type="hidden" name="playerCount"  value="${playerCount}" />
                                <input type="hidden" name="date"         value="${selectedDate}" />

                                <table class="slot-table">
                                    <thead>
                                        <tr><th>Time Slot</th><th>Availability</th></tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="hr" begin="${openingHour}" end="22">
                                            <tr>
                                                <td>${hr}:00 – ${hr}:59</td>
                                                <td>
                                                    <!-- now hr <= currentHour is also unavailable -->
                                                    <c:choose>
                                                        <c:when test="${bookedHours.contains(hr) or (isToday and hr <= currentHour)}">
                                                            <span class="unavailable">Unavailable</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="checkbox" name="timeSlots" value="${hr}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <div class="buttons">
                                    <button type="submit" class="button green-button">Next</button>
                                    <a href="${pageContext.request.contextPath}/selectStation"
                                       class="button blue-button">Back</a>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <%@ include file="footer.jsp" %>

        <script>
            function validateSelection() {
                const checked = document.querySelectorAll('input[name="timeSlots"]:checked');
                if (!checked.length) {
                    alert("Select at least one slot.");
                    return false;
                }
                const hrs = Array.from(checked)
                        .map(cb => +cb.value)
                        .sort((a, b) => a - b);
                for (let i = 1; i < hrs.length; i++) {
                    if (hrs[i] !== hrs[i - 1] + 1) {
                        alert("Please select consecutive slots.");
                        return false;
                    }
                }
                return true;
            }
        </script>
    </body>
</html>
