<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, my.nexgenesports.model.Booking, my.nexgenesports.model.Station" %>
<jsp:include page="header.jsp"/>
<div class="container">
    <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>
    <div class="content">
        <h2>Manage Bookings</h2>

        <!-- filter dropdown -->
        <form method="get" action="manageBookings">
            <label>Filter by Station:</label>
            <select name="stationID" onchange="this.form.submit()">
                <option value="">All</option>
                <%
                    List<Station> sts = (List<Station>) request.getAttribute("stations");
                    String sel = request.getParameter("stationID");
                    for (Station st : sts) {
                %>
                <option value="<%=st.getStationID()%>"
                        <%= st.getStationID().equals(sel) ? "selected" : ""%>>
                    <%=st.getStationName()%>
                </option>
                <% } %>
            </select>
        </form>

        <table class="stations-table">
            <tr>
                <th>ID</th><th>User</th><th>Station</th><th>Date</th>
                <th>Time</th><th>Status</th><th>Actions</th>
            </tr>
            <%
                List<Booking> bks = (List<Booking>) request.getAttribute("bookings");
                for (Booking b : bks) {
            %>
            <tr>
                <td><%=b.getBookingID()%></td>
                <td><%=b.getUserID()%></td>
                <td><%=b.getStationID()%></td>
                <td><%=b.getDate()%></td>
                <td><%=b.getStartTime()%>–<%=b.getEndTime()%></td>
                <td><%=b.getStatus()%></td>
                <td>
                    <a href="bookingDetails?bookingID=<%=b.getBookingID()%>">View</a>
                    <form action="booking/update" method="post" style="display:inline">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        <input type="hidden" name="bookingID" value="<%=b.getBookingID()%>"/>
                        <select name="status">
                            <option<%=b.getStatus().equals("Confirmed") ? " selected" : ""%>>Confirmed</option>
                            <option<%=b.getStatus().equals("Cancelled") ? " selected" : ""%>>Cancelled</option>
                            <option<%=b.getStatus().equals("Completed") ? " selected" : ""%>>Completed</option>
                            <option<%=b.getStatus().equals("Blocked") ? " selected" : ""%>>Blocked</option>
                        </select>
                        <button type="submit">Update</button>
                    </form>
                    <form action="booking/delete" method="post" style="display:inline">
                        <input type="hidden" name="bookingID" value="<%=b.getBookingID()%>"/>
                        <button type="submit">Delete</button>
                    </form>
                </td>
            </tr>
            <% }%>
        </table>
    </div>
</div>
<jsp:include page="footer.jsp"/>
