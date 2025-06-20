<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="my.nexgenesports.model.Station" %>
<jsp:include page="header.jsp"/>
<div class="container">
  <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>
  <div class="content">
    <h2>Manage Stations</h2>
    <a href="${pageContext.request.contextPath}/stations/add" class="button green-button">Add Station</a>
    <table class="stations-table">
      <tr>
        <th>ID</th><th>Name</th>
        <th>Normal(1P)</th><th>Normal(2P)</th>
        <th>Happy(1P)</th><th>Happy(2P)</th>
        <th>Actions</th>
      </tr>
      <%
        List<Station> list = (List<Station>) request.getAttribute("stations");
        for (Station s: list) {
      %>
      <tr>
        <td><%=s.getStationID()%></td>
        <td><%=s.getStationName()%></td>
        <td>RM<%=s.getNormalPrice1Player()%></td>
        <td><%= s.getNormalPrice2Player()!=null ? "RM"+s.getNormalPrice2Player() : "—" %></td>
        <td>RM<%=s.getHappyHourPrice1Player()%></td>
        <td><%= s.getHappyHourPrice2Player()!=null ? "RM"+s.getHappyHourPrice2Player() : "—" %></td>
        <td>
          <a href="${pageContext.request.contextPath}/stations/edit?stationID=<%=s.getStationID()%>">Edit</a>
          <form action="${pageContext.request.contextPath}/stations/delete" method="post" style="display:inline">
            <input type="hidden" name="stationID" value="<%=s.getStationID()%>"/>
            <button type="submit">Delete</button>
          </form>
        </td>
      </tr>
      <% } %>
    </table>
  </div>
</div>
<jsp:include page="footer.jsp"/>
