<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="my.nexgenesports.model.Booking" %>

<jsp:include page="header.jsp"/>

<div class="container">
  <div class="sidebar">
    <jsp:include page="sidebar.jsp"/>
  </div>
  <div class="content">
    <% 
      // retrieve the Booking we put into the request in BookingDetailsServlet
      Booking b = (Booking) request.getAttribute("bk"); 
      if (b == null) {
    %>
      <p style="color:red;">Booking not found.</p>
      <a href="manageBookings">Back to list</a>
    <% } else { %>
      <h2>Booking #<%= b.getBookingID() %> Details</h2>
      <p><strong>User:</strong> <%= b.getUserID() %></p>
      <p><strong>Station:</strong> <%= b.getStationID() %></p>
      <p><strong>Date:</strong> <%= b.getDate() %></p>
      <p><strong>Time:</strong> <%= b.getStartTime() %> – <%= b.getEndTime() %></p>
      <p><strong>Status:</strong> <%= b.getStatus() %></p>
      <p><strong>Players:</strong> <%= b.getPlayerCount() %></p>
      <p><strong>Price:</strong> RM<%= b.getPrice() %></p>
      <a href="manageBookings">Back to list</a>
    <% } %>
  </div>
</div>

<jsp:include page="footer.jsp"/>
