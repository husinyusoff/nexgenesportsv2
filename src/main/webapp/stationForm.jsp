<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="my.nexgenesports.model.Station" %>
<jsp:include page="header.jsp"/>
<div class="container">
  <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>
  <div class="content">
    <%
      Station s = (Station) request.getAttribute("station");
      boolean edit = s!=null;
    %>
    <h2><%= edit? "Edit Station" : "Add Station" %></h2>
    <form method="post" action="<%= edit
        ? "stations/edit"
        : "stations/add" %>">
      <div>
        <label>ID:</label>
        <input name="stationID" value="<%=edit?s.getStationID():""%>"
          <%=edit?"readonly": "required"%> />
      </div>
      <div>
        <label>Name:</label>
        <input name="stationName" value="<%=edit?s.getStationName():""%>" required/>
      </div>
      <div>
        <label>Normal Price (1P):</label>
        <input name="normalPrice1Player" type="number" step="0.01"
               value="<%=edit?s.getNormalPrice1Player():""%>" required/>
      </div>
      <div>
        <label>Normal Price (2P):</label>
        <input name="normalPrice2Player" type="number" step="0.01"
               value="<%=edit && s.getNormalPrice2Player()!=null?s.getNormalPrice2Player():""%>"/>
      </div>
      <div>
        <label>Happy Hour (1P):</label>
        <input name="happyHourPrice1Player" type="number" step="0.01"
               value="<%=edit?s.getHappyHourPrice1Player():""%>" required/>
      </div>
      <div>
        <label>Happy Hour (2P):</label>
        <input name="happyHourPrice2Player" type="number" step="0.01"
               value="<%=edit && s.getHappyHourPrice2Player()!=null?s.getHappyHourPrice2Player():""%>"/>
      </div>
      <button type="submit"><%=edit?"Update":"Create"%></button>
      <a href="manageStations">Cancel</a>
    </form>
  </div>
</div>
<jsp:include page="footer.jsp"/>
