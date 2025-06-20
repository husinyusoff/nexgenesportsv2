<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout – NexGen Esports</title>
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
      <!-- this wrapper hooks into your .checkout-page CSS -->
      <div class="checkout-page">
        <div class="checkout-box">
          <h2>Checkout</h2>
          <p><strong>Station:</strong> ${booking.stationID}</p>
          <p><strong>Date:</strong> ${booking.date}</p>
          <p><strong>Time:</strong> ${booking.startTime} – ${booking.endTime}</p>
          <p><strong>Players:</strong> ${booking.playerCount}</p>
          <p><strong>Total:</strong> RM${booking.price}</p>

          <form action="${pageContext.request.contextPath}/redirectToPayment" method="post">
            <input type="hidden" name="csrfToken"   value="${sessionScope.csrfToken}" />
            <input type="hidden" name="stationID"    value="${booking.stationID}"   />
            <input type="hidden" name="date"         value="${booking.date}"        />
            <input type="hidden" name="startTime"    value="${booking.startTime}"   />
            <input type="hidden" name="endTime"      value="${booking.endTime}"     />
            <input type="hidden" name="playerCount"  value="${booking.playerCount}" />
            <input type="hidden" name="price"        value="${booking.price}"       />

            <button type="submit" class="btn-submit">Pay Now</button>
            <a href="${pageContext.request.contextPath}/manageBooking"
               class="btn-back">Cancel</a>
          </form>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="footer.jsp"/>
</body>
</html>
