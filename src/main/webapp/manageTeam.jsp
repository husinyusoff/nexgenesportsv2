<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Team – NexGen Esports</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body class="team-page">

        <jsp:include page="/header.jsp"/>
        <button id="openToggle" class="open-toggle">☰</button>

        <div class="container">
            <div class="sidebar">
                <button id="closeToggle" class="close-toggle">×</button>
                <jsp:include page="/sidebar.jsp"/>
            </div>

            <div class="content">

                <!-- SUMMARY: list of all teams -->
                <div class="summary-table-container">
                    <h1>My Team</h1>
                    <button onclick="location.href = '${pageContext.request.contextPath}/team/join'" 
                            class="btn blue-btn join-request-btn">
                        JOIN REQUEST
                    </button>
                    <table class="summary-table">
                        <thead>
                            <tr>
                                <th>Logo</th>
                                <th>Team Name</th>
                                <th>Created By</th>
                                <th>Creation Date</th>
                                <th>Capacity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="team" items="${teams}" varStatus="st">
                                <tr>
                                    <td>
                                        <img src="${team.logoURL}" 
                                             alt="${team.teamName}" 
                                             class="logo-thumb"/>
                                    </td>
                                    <td><c:out value="${team.teamName}"/></td>
                                    <td><c:out value="${team.createdBy}"/></td>
                                    <td>
                                        ${fn:replace(team.createdAt, 'T', ' ')}
                                    </td>
                                    <td>
                                        ${membersCountMap[team.teamID]}/${team.capacity}
                                    </td>
                                    <td>
                                        <button type="button" 
                                                class="btn green-btn details-btn" 
                                                data-idx="${st.index}">
                                            DETAILS
                                        </button>
                                        <form action="${pageContext.request.contextPath}/team/manage" 
                                              method="post" class="inline-form">
                                            <input type="hidden" name="action" value="leave"/>
                                            <input type="hidden" name="teamID" value="${team.teamID}"/>
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                            <button type="submit" class="btn red-btn">LEAVE</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div> <!-- /.summary-table-container -->

                <!-- DETAIL CAROUSEL -->
                <div class="card-carousel">
                    <c:forEach var="team" items="${teams}" varStatus="st">
                        <div class="team-card" data-idx="${st.index}">

                            <!-- Card Header -->
                            <div class="card-header">
                                <img src="${team.logoURL}" 
                                     alt="${team.teamName}" 
                                     class="team-logo"/>
                                <div class="team-meta">
                                    <h2>Team Name: <c:out value="${team.teamName}"/></h2>
                                    <p>Created By: <c:out value="${team.createdBy}"/></p>
                                    <p>Created Date: 
                                        ${fn:replace(team.createdAt, 'T', ' ')}
                                    </p>
                                    <p>Capacity: 
                                        ${membersCountMap[team.teamID]}/${team.capacity}
                                    </p>
                                </div>
                            </div>

                            <!-- Prev/Next + Inner Tabs -->
                            <div class="detail-nav">
                                <button id="prevTeam" class="nav-btn">&lt;</button>
                                <div class="inner-tabs">
                                    <button type="button" 
                                            class="tab-label active" 
                                            data-tab="members">
                                        TEAM MEMBERS
                                    </button>
                                    <button type="button" 
                                            class="tab-label" 
                                            data-tab="achievement">
                                        ACHIEVEMENT
                                    </button>
                                </div>
                                <button id="nextTeam" class="nav-btn">&gt;</button>
                            </div>

                            <!-- Team Members Panel -->
                            <div class="inner-panel members-panel active">
                                <table class="members-table">
                                    <thead>
                                        <tr>
                                            <th>No.</th><th>Name</th><th>Role</th>
                                            <th>Joined Date</th><th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="member" 
                                                   items="${membersByTeam[team.teamID]}" 
                                                   varStatus="ms">
                                            <tr>
                                                <td>${ms.index + 1}</td>
                                                <td><c:out value="${member.userName}"/></td>
                                                <td><c:out value="${member.teamRole}"/></td>
                                                <td>
                                                    ${fn:replace(member.joinedAt, 'T', ' ')}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${member.teamRole == 'Leader'}">
                                                            <button class="btn red-btn" disabled>LEAVE</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="${pageContext.request.contextPath}/team/manage" 
                                                                  method="post" class="inline-form">
                                                                <input type="hidden" name="action" value="leave"/>
                                                                <input type="hidden" name="teamID"   value="${team.teamID}"/>
                                                                <input type="hidden" name="targetUserID" 
                                                                       value="${member.userID}"/>
                                                                <input type="hidden" name="csrfToken" 
                                                                       value="${sessionScope.csrfToken}"/>
                                                                <button type="submit" class="btn red-btn">LEAVE</button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${sessionScope.username == team.createdBy}">
                                                        <form action="${pageContext.request.contextPath}/team/manage" 
                                                              method="post" class="inline-form">
                                                            <input type="hidden" name="action" value="changeRole"/>
                                                            <input type="hidden" name="teamID"   value="${team.teamID}"/>
                                                            <input type="hidden" name="targetUserID" 
                                                                   value="${member.userID}"/>
                                                            <input type="hidden" name="newRole" 
                                                                   value="${member.teamRole == 'Co-Leader' ? 'Member' : 'Co-Leader'}"/>
                                                            <input type="hidden" name="csrfToken" 
                                                                   value="${sessionScope.csrfToken}"/>
                                                            <button type="submit" class="btn green-btn">
                                                                CHANGE ROLE
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/team/manage" 
                                                              method="post" class="inline-form">
                                                            <input type="hidden" name="action" value="removeMember"/>
                                                            <input type="hidden" name="teamID"   value="${team.teamID}"/>
                                                            <input type="hidden" name="targetUserID" 
                                                                   value="${member.userID}"/>
                                                            <input type="hidden" name="csrfToken" 
                                                                   value="${sessionScope.csrfToken}"/>
                                                            <button type="submit" class="btn red-btn">KICK</button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Achievement Panel -->
                            <div class="inner-panel achievement-panel">
                                <table class="achievement-table">
                                    <thead>
                                        <tr>
                                            <th>No.</th><th>Program Name</th><th>Date & Time</th>
                                            <th>Joined Date</th><th>Rank</th>
                                            <th>Score</th><th>Personal Score</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ach" 
                                                   items="${achievementsByTeam[team.teamID]}" 
                                                   varStatus="as">
                                            <tr>
                                                <td>${as.index + 1}</td>
                                                <td><c:out value="${ach.programName}"/></td>
                                                <td>
                                                    <fmt:formatDate value="${ach.eventDateTime}" 
                                                                    pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${ach.joinedDate}" 
                                                                    pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>${ach.rank != null ? ach.rank : '-'}</td>
                                                <td>${ach.score}</td>
                                                <td>${ach.personalScore}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                        </div> <!-- /.team-card -->
                    </c:forEach>
                </div> <!-- /.card-carousel -->

            </div> <!-- /.content -->
        </div> <!-- /.container -->

        <jsp:include page="/footer.jsp"/>

        <script>
            (function () {
                const cards = document.querySelectorAll('.team-card');
                const prevBtn = document.getElementById('prevTeam');
                const nextBtn = document.getElementById('nextTeam');
                let   current = 0;

                function showCard(idx) {
                    cards.forEach((c, i) => c.classList.toggle('active', i === idx));
                    prevBtn.disabled = (idx === 0);
                    nextBtn.disabled = (idx === cards.length - 1);
                    current = idx;
                }

                prevBtn.addEventListener('click', () => showCard(current - 1));
                nextBtn.addEventListener('click', () => showCard(current + 1));

                // “DETAILS” buttons jump right to that team-card
                document.querySelectorAll('.details-btn').forEach(btn =>
                    btn.addEventListener('click', () => {
                        showCard(parseInt(btn.dataset.idx, 10));
                        document.querySelector('.card-carousel')
                                .scrollIntoView({behavior: 'smooth'});
                    })
                );

                // inner‐tabs logic per card
                cards.forEach(card => {
                    const tabs = card.querySelectorAll('.tab-label');
                    const panels = [
                        card.querySelector('.members-panel'),
                        card.querySelector('.achievement-panel')
                    ];
                    tabs.forEach((tab, i) =>
                        tab.addEventListener('click', () => {
                            tabs.forEach(t => t.classList.toggle('active', t === tab));
                            panels.forEach((p, j) => p.classList.toggle('active', i === j));
                        })
                    );
                });

                // init
                showCard(0);
            })();
        </script>

    </body>
</html>
