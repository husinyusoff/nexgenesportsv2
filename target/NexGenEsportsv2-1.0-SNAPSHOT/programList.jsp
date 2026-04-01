<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="
         java.util.List,
         my.nexgenesports.model.ProgramTournament,
         my.nexgenesports.model.MeritLevel,
         my.nexgenesports.util.PermissionChecker,
         my.nexgenesports.dao.programTournament.TournamentParticipantDaoImpl
         " %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctx = request.getContextPath();
    @SuppressWarnings(
            
    
    "unchecked")
    List<ProgramTournament> programs = (List<ProgramTournament>) request.getAttribute("programs");
    @SuppressWarnings(
            
    
    "unchecked")
    List<MeritLevel> merits = (List<MeritLevel>) request.getAttribute("merits");
    @SuppressWarnings(
            
    
    "unchecked")
    List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position = (String) session.getAttribute("position");
    String me = (String) session.getAttribute("username");
    TournamentParticipantDaoImpl tpDao = new TournamentParticipantDaoImpl();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <title>Manage All Program – NexGen Esports</title>
        <link rel="stylesheet" href="styles.css"/>
    </head>

    <body class="tournament-page">
        <!-- Header -->
        <jsp:include page="/header.jsp"/>

        <!-- Sidebar toggle -->
        <button id="openToggle" class="open-toggle">☰</button>

        <div class="container">
            <!-- Sidebar -->
            <div class="sidebar">
                <button id="closeToggle" class="close-toggle">×</button>
                <jsp:include page="/sidebar.jsp"/>
            </div>

            <!-- Main area -->
            <div class="main">
                <div class="content">
                    <div class="table-card">
                        <h2>MANAGE ALL PROGRAM</h2>

                        <div class="controls">
                            <div class="search">
                                <input type="text" id="searchInput" placeholder="Search..."/>
                                <i class="fa fa-search"></i>
                            </div>
                            <div class="sort-by">
                                <select id="sortSelect">
                                    <option value="">Sort By</option>
                                    <option value="date-asc">Date ▲</option>
                                    <option value="date-desc">Date ▼</option>
                                    <option value="status">Status</option>
                                </select>
                            </div>
                            <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/new")) { %>
                            <button class="btn btn-create-new blue-btn"
                                    onclick="location.href = '${ctx}/programs/new'">
                                CREATE NEW
                            </button>
                            <% } %>
                        </div>

                        <table class="summary-table" id="programsTable">
                            <thead>
                                <tr>
                                    <th>POSTER</th><th>MERIT</th><th>PROGRAM TYPE</th>
                                    <th>PROGRAM NAME</th><th>DATE</th><th>TIME</th>
                                    <th>PARTICIPANT</th><th>STATUS</th><th>ACTION</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ProgramTournament pt : programs) {
                                        String scope = "";
                                        for (MeritLevel ml : merits) {
                                            if (ml.getMeritId() == pt.getMeritId()) {
                                                scope = ml.getScope();
                                                break;
                                            }
                                        }
                                        long count = tpDao.countByProgId(pt.getProgId());
                                        boolean isTourn = "TOURNAMENT".equals(pt.getProgramType());
                                        int max = isTourn ? pt.getMaxTeamMember() : pt.getMaxCapacity();  // <-- fixed
                                        String unit = isTourn ? "TEAMS" : "PLAYERS";
                                        boolean pending = "PENDING_APPROVAL".equals(pt.getStatus());
                                        boolean approved = "APPROVED".equals(pt.getStatus());
                                %>
                                <tr>
                                    <td>
                                        <img src="${ctx}/images/${pt.getPosterFilename()}"
                                             alt="poster" style="width:60px;height:auto"/>
                                    </td>
                                    <td><%= scope%></td>
                                    <td>
                                        <% if (isTourn) {%>
                                        TOURNAMENT – <%= pt.getBracketFormat()%><br/>
                                        <a href="${ctx}/programs/challonge?progId=<%=pt.getProgId()%>"
                                           class="btn small blue-btn">BRACKET</a>
                                        <% } else { %>
                                        GENERAL
                                        <% }%>
                                    </td>
                                    <td><%= pt.getProgramName()%></td>
                                    <td><%= pt.getStartDate()%> – <%= pt.getEndDate()%></td>
                                    <td><%= pt.getStartTime()%> – <%= pt.getEndTime()%></td>
                                    <td><%= count%>/<%= max%> <%= unit%></td>
                                    <td><%= pt.getStatus()%></td>
                                    <td>
                                        <a href="${ctx}/programs/detail?progId=<%=pt.getProgId()%>"
                                           class="btn small gray-btn">DETAILS</a>
                                        <% if ((pending && me.equals(pt.getCreatorId()))
                                                    || (approved && "president".equals(position))) {%>
                                        <a href="${ctx}/programs/edit?progId=<%=pt.getProgId()%>"
                                           class="btn small green-btn">EDIT</a>
                                        <form action="${ctx}/programs/delete" method="post">
                                            method="post" style="display:inline">
                                            <input type="hidden" name="csrfToken"
                                                   value="${sessionScope.csrfToken}"/>
                                            <input type="hidden" name="progId" value="<%=pt.getProgId()%>"/>
                                            <button type="submit" class="btn small red-btn">DELETE</button>
                                        </form>
                                        <% } %>

                                        <% if (pending && "president".equals(position)) {%>
                                        <form action="${ctx}/programs/approve" method="post">
                                            <input type="hidden" name="csrfToken"
                                                   value="${sessionScope.csrfToken}"/>
                                            <input type="hidden" name="progId" value="<%=pt.getProgId()%>"/>
                                            <button type="submit" class="btn small btn-approve">
                                                APPROVE
                                            </button>
                                        </form>
                                        <form action="${ctx}/programs/reject" method="post">
                                            <input type="hidden" name="csrfToken"
                                                   value="${sessionScope.csrfToken}"/>
                                            <input type="hidden" name="progId" value="<%=pt.getProgId()%>"/>
                                            <button type="submit" class="btn small btn-reject">
                                                REJECT
                                            </button>
                                        </form>
                                        <% } %>
                                    </td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/footer.jsp"/>

        <script>
            (function () {
                const rows = Array.from(document.querySelectorAll('#programsTable tbody tr'));
                const searchInput = document.getElementById('searchInput');
                const sortSelect = document.getElementById('sortSelect');

                searchInput.addEventListener('input', () => {
                    const q = searchInput.value.toLowerCase();
                    rows.forEach(r => {
                        r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
                    });
                });

                sortSelect.addEventListener('change', () => {
                    const tbody = document.querySelector('#programsTable tbody');
                    const val = sortSelect.value;
                    const sorted = rows.slice().sort((a, b) => {
                        if (val.startsWith('date')) {
                            const aD = new Date(a.cells[4].textContent.split('–')[0].trim());
                            const bD = new Date(b.cells[4].textContent.split('–')[0].trim());
                            return val === 'date-asc' ? aD - bD : bD - aD;
                        }
                        if (val === 'status') {
                            return a.cells[7].textContent.localeCompare(b.cells[7].textContent);
                        }
                        return 0;
                    });
                    tbody.innerHTML = '';
                    sorted.forEach(r => tbody.appendChild(r));
                });
            })();
        </script>
    </body>
</html>
