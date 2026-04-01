<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="
    java.time.format.DateTimeFormatter,
    java.util.List,
    my.nexgenesports.model.ProgramTournament,
    my.nexgenesports.model.TournamentParticipant,
    my.nexgenesports.model.Bracket
" %>
<%
    String ctx = request.getContextPath();
    ProgramTournament program = (ProgramTournament) request.getAttribute("program");
    @SuppressWarnings("unchecked")
    List<TournamentParticipant> participants =
        (List<TournamentParticipant>) request.getAttribute("participants");
    @SuppressWarnings("unchecked")
    List<Bracket> brackets =
        (List<Bracket>) request.getAttribute("brackets");

    DateTimeFormatter DF_DATE     = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter DF_DATETIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>

<jsp:include page="/header.jsp"/>

<div class="container" style="display:flex;">
  <div class="sidebar">
    <jsp:include page="/sidebar.jsp"/>
  </div>
  <div class="content">
    <h2>Details: <%= program.getProgramName() %></h2>

    <table class="summary-table">
      <tr><th>Type:</th><td><%= program.getProgramType() %></td></tr>
      <tr><th>Status:</th><td><%= program.getStatus() %></td></tr>
      <tr>
        <th>Dates:</th>
        <td>
          <%= program.getStartDate().format(DF_DATE) %> –
          <%= program.getEndDate().format(DF_DATE) %>
        </td>
      </tr>
      <tr>
        <th>Time:</th>
        <td><%= program.getStartTime() %> – <%= program.getEndTime() %></td>
      </tr>
      <tr><th>Place:</th>      <td><%= program.getPlace() %></td></tr>
      <tr><th>Fee:</th>        <td><%= program.getProgFee() %></td></tr>
      <tr><th>Prize:</th>      <td><%= program.getPrizePool() %></td></tr>
      <tr><th>Capacity:</th>   <td><%= program.getMaxCapacity() %></td></tr>
      <tr><th>Description:</th><td><%= program.getDescription() %></td></tr>
    </table>

    <h3>Participants</h3>
    <table class="summary-table">
      <thead>
        <tr><th>#</th><th>User/Team</th><th>Status</th><th>Joined</th></tr>
      </thead>
      <tbody>
        <% for (int i = 0; i < participants.size(); i++) {
             TournamentParticipant p = participants.get(i);
        %>
        <tr>
          <td><%= i+1 %></td>
          <td>
            <%= (p.getTeamId() != null
                 ? "Team " + p.getTeamId()
                 : p.getUserId()) %>
          </td>
          <td><%= p.getStatus() %></td>
          <td><%= p.getJoinedAt().format(DF_DATETIME) %></td>
        </tr>
        <% } %>
      </tbody>
    </table>

    <% if ("TOURNAMENT".equals(program.getProgramType())) { %>
      <h3>Brackets</h3>
      <a href="<%= ctx %>/brackets/create?progId=<%= program.getProgId() %>"
         class="btn blue-btn">New Bracket</a>
      <table class="summary-table">
        <thead>
          <tr><th>#</th><th>Name</th><th>Format</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <% for (int i = 0; i < brackets.size(); i++) {
               Bracket b = brackets.get(i);
          %>
          <tr>
            <td><%= i+1 %></td>
            <td><%= b.getName() %></td>
            <td><%= b.getFormat() %></td>
            <td>
              <a href="<%= ctx %>/brackets/view?bracketId=<%= b.getBracketId() %>"
                 class="btn green-btn">View</a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    <% } %>

    <% if ("OPEN".equals(program.getStatus())) { %>
      <form action="<%= ctx %>/programs/join" method="post">
        <input type="hidden" name="progId"    value="<%= program.getProgId() %>"/>
        <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>"/>
        <% if ("TOURNAMENT".equals(program.getProgramType())) { %>
          Team ID: <input type="text" name="teamId"/>
        <% } %>
        <button type="submit" class="btn green-btn">REGISTER</button>
      </form>
    <% } %>

    <br/>
    <a href="<%= ctx %>/programs/edit?progId=<%= program.getProgId() %>"
       class="btn blue-btn">EDIT</a>
    <form action="<%= ctx %>/programs/delete" method="post" style="display:inline">
      <input type="hidden" name="progId"    value="<%= program.getProgId() %>"/>
      <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>"/>
      <button type="submit" class="btn red-btn"
              onclick="return confirm('Delete this item?')">DELETE</button>
    </form>
  </div>
</div>

<jsp:include page="/footer.jsp"/>
