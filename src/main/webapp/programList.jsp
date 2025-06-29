<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="
    java.util.List,
    my.nexgenesports.model.ProgramTournament,
    my.nexgenesports.model.MeritLevel,
    my.nexgenesports.util.PermissionChecker
" %>

<%
    @SuppressWarnings("unchecked")
    List<ProgramTournament> programs =
        (List<ProgramTournament>) request.getAttribute("programs");
    @SuppressWarnings("unchecked")
    List<MeritLevel> merits =
        (List<MeritLevel>) request.getAttribute("merits");

    @SuppressWarnings("unchecked")
    List<String> roles =
        (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position   = (String) session.getAttribute("position");
    String me         = (String) session.getAttribute("username");

    String ctx       = request.getContextPath();
    String csrfToken = (String) session.getAttribute("csrfToken");
%>

<jsp:include page="/header.jsp"/>

<div class="container" style="display:flex">
  <div class="sidebar">
    <jsp:include page="/sidebar.jsp"/>
  </div>

  <div class="content">
    <h2>Manage Your Tournament / Program</h2>

    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/new")) { %>
      <button class="btn blue-btn"
              onclick="location.href='<%=ctx%>/programs/new'">
        CREATE NEW
      </button>
    <% } %>

    <table class="summary-table" style="width:100%; margin-top:1em;">
      <thead>
        <tr>
          <th>Level</th><th>Type</th><th>Name</th>
          <th>Dates</th><th>Times</th><th>Capacity</th>
          <th>Status</th><th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% for (ProgramTournament pt : programs) {
             // compute the scope string
             String scopeName = "";
             for (MeritLevel ml : merits) {
               if (ml.getMeritId() == pt.getMeritId()) {
                 scopeName = ml.getScope();
                 break;
               }
             }
        %>
        <tr>
          <td><%= scopeName %></td>
          <td>
            <%= pt.getProgramType() %>
            <% if ("TOURNAMENT".equals(pt.getProgramType())) { %>
              <br/>
              <a href="<%=ctx%>/programs/<%=pt.getProgId()%>/bracket"
                 class="btn small blue-btn">BRACKET</a>
            <% } %>
          </td>
          <td><%= pt.getProgramName() %></td>
          <td><%= pt.getStartDate() %> – <%= pt.getEndDate() %></td>
          <td>
            <% if (pt.getStartTime() != null) { %>
              <%= pt.getStartTime() %>
            <% } %>
            <% if (pt.getEndTime() != null) { %>
              – <%= pt.getEndTime() %>
            <% } %>
          </td>
          <td><%= pt.getMaxCapacity() %></td>
          <td><%= pt.getStatus() %></td>
          <td>
            <!-- DETAILS always -->
            <a href="<%=ctx%>/programs/<%=pt.getProgId()%>/detail"
               class="btn small gray-btn">DETAILS</a>

            <!-- CANCEL (creator only, while PENDING_APPROVAL) -->
            <% if ("PENDING_APPROVAL".equals(pt.getStatus())
                  && me.equals(pt.getCreatorId())
                  && PermissionChecker.hasAccess(
                       roles, chosenRole, position,
                       "/programs/cancel")) { %>
              <form method="post"
                    action="<%=ctx%>/programs/cancel"
                    style="display:inline">
                <input type="hidden" name="csrfToken"
                       value="<%=csrfToken%>"/>
                <input type="hidden" name="progId"
                       value="<%=pt.getProgId()%>"/>
                <button type="submit"
                        class="btn small red-btn">CANCEL</button>
              </form>
            <% } %>

            <!-- APPROVE (high_council/president only, while PENDING_APPROVAL) -->
            <% if ("PENDING_APPROVAL".equals(pt.getStatus())
                  && PermissionChecker.hasAccess(
                       roles, chosenRole, position,
                       "/programs/approve")) { %>
              <form method="post"
                    action="<%=ctx%>/programs/approve"
                    style="display:inline">
                <input type="hidden" name="csrfToken"
                       value="<%=csrfToken%>"/>
                <input type="hidden" name="progId"
                       value="<%=pt.getProgId()%>"/>
                <button type="submit"
                        class="btn small blue-btn">APPROVE</button>
              </form>
            <% } %>

            <!-- REJECT (high_council/president only, while PENDING_APPROVAL) -->
            <% if ("PENDING_APPROVAL".equals(pt.getStatus())
                  && PermissionChecker.hasAccess(
                       roles, chosenRole, position,
                       "/programs/reject")) { %>
              <form method="post"
                    action="<%=ctx%>/programs/reject"
                    style="display:inline">
                <input type="hidden" name="csrfToken"
                       value="<%=csrfToken%>"/>
                <input type="hidden" name="progId"
                       value="<%=pt.getProgId()%>"/>
                <button type="submit"
                        class="btn small orange-btn">REJECT</button>
              </form>
            <% } %>

            <!-- EDIT (exec_council & above, while PENDING_APPROVAL) -->
            <% if ("PENDING_APPROVAL".equals(pt.getStatus())
                  && PermissionChecker.hasAccess(
                       roles, chosenRole, position,
                       "/programs/edit")) { %>
              <a href="<%=ctx%>/programs/<%=pt.getProgId()%>/edit"
                 class="btn small green-btn">EDIT</a>
            <% } %>

            <!-- ★ STATUS DROPDOWN for Exec Council ★ -->
            <% String s = pt.getStatus();
               boolean canChange = 
                   ( "APPROVED".equals(s) || "OPEN".equals(s) || "CLOSED".equals(s) )
                   && PermissionChecker.hasAccess(
                         roles, chosenRole, position,
                         "/programs/changeStatus");
               if (canChange) { %>
              <form method="post"
                    action="<%=ctx%>/programs/changeStatus"
                    style="display:inline">
                <input type="hidden" name="csrfToken"
                       value="<%=csrfToken%>"/>
                <input type="hidden" name="progId"
                       value="<%=pt.getProgId()%>"/>
                <select name="newStatus" required>
                  <option value="OPEN"
                    <%= "OPEN".equals(s) ? "selected" : "" %>>
                    Open
                  </option>
                  <option value="CLOSED"
                    <%= "CLOSED".equals(s) ? "selected" : "" %>>
                    Closed
                  </option>
                </select>
                <button type="submit"
                        class="btn small green-btn">
                  Update Status
                </button>
              </form>
            <% } %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<jsp:include page="/footer.jsp"/>
