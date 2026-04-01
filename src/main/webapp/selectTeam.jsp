<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Select Your Team – NexGen Esports</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    </head>
    <body class="team-page select-team-page">
        <%@ include file="header.jsp" %>
        <button id="openToggle" class="open-toggle">☰</button>

        <div class="container">
            <div class="sidebar">
                <%@ include file="sidebar.jsp" %>
                <button id="closeToggle" class="close-toggle">×</button>
            </div>

            <div class="content">
                <div class="card">
                    <a href="javascript:history.back()" class="back-link" aria-label="Go Back">
                        <!-- SVG back arrow here -->
                    </a>
                    <h2>Select Team for ${program.programName}”</h2>

                    <form id="selectTeamForm"
                          method="post"
                          action="${pageContext.request.contextPath}/programs/previewRegistration">
                        <input type="hidden" name="csrfToken"
                               value="${sessionScope.csrfToken}"/>
                        <input type="hidden" name="progId"
                               value="${program.progId}"/>
                        <input type="hidden" name="teamId"
                               value="${selectedTeamId}"/>

                        <label for="teamSelect">Choose team:</label>
                        <select id="teamSelect" name="teamId" required
                                onchange="location.href = '${pageContext.request.contextPath}/programs/selectTeam?progId=${program.progId}&teamId=' + this.value">
                            <option value="">-- pick a team --</option>
                            <c:forEach var="t" items="${teams}">
                                <option value="${t.teamID}"
                                        <c:if test="${t.teamID == selectedTeamId}">selected</c:if>>
                                    ${t.teamName}
                                </option>
                            </c:forEach>
                        </select>

                        <c:if test="${not empty selectedTeamId}">
                            <p>
                                Main player quota:
                                <span id="mainCount">0</span> /
                                <span id="mainMax">${minQuota}</span>
                            </p>


                            <table class="summary-table" id="mainTable">
                                <thead>
                                    <tr><th>Select</th><th>User ID</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${members}">
                                        <c:if test="${m.status == 'Active'}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox"
                                                           class="mainBox"
                                                           name="mainPlayers"
                                                           value="${m.userID}"/>
                                                </td>
                                                <td>${m.userID}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>


                            <p>
                                Sub-player quota:
                                <span id="subCount">0</span> /
                                <span id="subMax">${subQuota}</span>
                                <label style="margin-left:1em">
                                    <input type="checkbox" id="noSub"/> No sub-player
                                </label>
                            </p>

                            <table class="summary-table" id="subTable">
                                <thead>
                                    <tr><th>Select</th><th>User ID</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${members}">
                                        <c:if test="${m.status == 'Active'}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox"
                                                           class="subBox"
                                                           name="subPlayers"
                                                           value="${m.userID}"/>
                                                </td>
                                                <td>${m.userID}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <button type="submit" id="nextBtn" class="button green-button" disabled>
                                Next → Preview &amp; Checkout
                            </button>
                        </c:if>
                    </form>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>

        <script>
            (function () {
                const mainBoxes = Array.from(document.querySelectorAll('.mainBox'));
                const subBoxes = Array.from(document.querySelectorAll('.subBox'));
                const mainCount = document.getElementById('mainCount');
                const subCount = document.getElementById('subCount');
                const mainMax = parseInt(document.getElementById('mainMax').textContent, 10);
                const subMax = parseInt(document.getElementById('subMax').textContent, 10);
                const noSub = document.getElementById('noSub');
                const nextBtn = document.getElementById('nextBtn');

                function updateUI() {
                    const mainsSelected = mainBoxes.filter(b => b.checked).map(b => b.value);
                    const mainSelCount = mainsSelected.length;
                    mainCount.textContent = mainSelCount;

                    mainBoxes.forEach(box => {
                        const row = box.closest('tr');
                        row.style.display = (!box.checked && mainSelCount >= mainMax) ? 'none' : '';
                    });

                    if (noSub.checked) {
                        document.getElementById('subTable').style.display = 'none';
                        subBoxes.forEach(b => b.checked = false);
                    } else {
                        document.getElementById('subTable').style.display = '';
                    }

                    subBoxes.forEach(box => {
                        const row = box.closest('tr');
                        if (mainsSelected.includes(box.value)) {
                            row.style.display = 'none';
                            box.checked = false;
                        } else {
                            row.style.display = '';
                        }
                        const subChecked = subBoxes.filter(x => x.checked).length;
                        box.disabled = (!box.checked && subChecked >= subMax);
                    });

                    const subSelCount = noSub.checked
                            ? 0
                            : subBoxes.filter(b => b.checked).length;
                    subCount.textContent = subSelCount;

                    const mainsOk = mainSelCount === mainMax;
                    const subsOk = noSub.checked || subSelCount >= 1;
                    nextBtn.disabled = !(mainsOk && subsOk);
                }

                mainBoxes.forEach(b => b.addEventListener('change', updateUI));
                subBoxes.forEach(b => b.addEventListener('change', updateUI));
                noSub.addEventListener('change', updateUI);

                updateUI();
            })();
        </script>
    </body>
</html>
