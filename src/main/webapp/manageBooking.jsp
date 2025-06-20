<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bookings – NexGen Esports</title>
  <link
    rel="stylesheet"
    href="styles.css" />
</head>
<body>
  <jsp:include page="header.jsp"/>

  <div class="container">
    <div class="sidebar">
      <jsp:include page="sidebar.jsp"/>
    </div>
    <div class="content">
      <div class="select-station-box">
        <h2>My Bookings</h2>
        <table class="stations-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Station</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
              <th>Payment</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="b" items="${bookings}">
              <tr>
                <td>${b.bookingID}</td>
                <td>${b.stationID}</td>
                <td>${b.date}</td>
                <td>${b.startTime} – ${b.endTime}</td>
                <td>${b.status}</td>
                <td>${b.paymentStatus}</td>
                <td>
                  <a href="${pageContext.request.contextPath}/bookingDetails?bookingID=${b.bookingID}">
                    View
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <jsp:include page="footer.jsp"/>
</body>
</html>
