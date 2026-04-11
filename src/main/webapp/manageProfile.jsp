<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - NexGen Esports</title>
    <meta name="description" content="Manage your NexGen Esports player profile, esports identity and account settings.">

</head>
<body class="app-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <jsp:include page="sidebar.jsp"/>

        <main class="content">
            <div class="rigid-layout-container">

                <!-- PAGE HERO -->
                <div class="profile-hero">
                    <div class="profile-hero-icon">👤</div>
                    <h2>My Profile</h2>
                    <p class="subtitle">Your identity in the NexGen arena. Keep it sharp.</p>
                </div>

                <!-- TOAST MESSAGES -->
                <c:if test="${not empty successMsg}">
                    <div class="profile-toast success" id="profile-toast">
                        ✓ &nbsp;${successMsg}
                    </div>
                </c:if>
                <c:if test="${not empty errorMsg}">
                    <div class="profile-toast error" id="profile-toast">
                        ✕ &nbsp;${errorMsg}
                    </div>
                </c:if>

                <!-- IDENTITY BANNER -->
                <div class="profile-identity-card">
                    <div class="profile-avatar-wrap">
                        <div class="profile-avatar-ring"></div>
                        <div class="profile-avatar" id="profile-avatar">?</div>
                    </div>
                    <div class="profile-identity-info">
                        <div class="profile-identity-name">
                            <c:out value="${not empty user.name ? user.name : user.userID}"/>
                        </div>
                        <div class="profile-identity-uid">
                            @ <span><c:out value="${user.userID}"/></span>
                        </div>
                        <div class="profile-identity-badges">
                            <span class="identity-badge role">⚡ Athlete</span>
                            <c:if test="${not empty user.position}">
                                <span class="identity-badge position">🎯 <c:out value="${user.position}"/></span>
                            </c:if>
                            <span class="identity-badge since">📅 Since <c:out value="${user.formattedRegistrationDate}"/></span>
                        </div>
                    </div>
                </div>

                <!-- PANELS GRID -->
                <div class="profile-panels-grid">

                    <!-- PANEL 1: PERSONAL INFORMATION -->
                    <div class="profile-panel">
                        <div class="panel-header">
                            <div class="panel-title">
                                <span class="panel-icon">🪪</span> Personal Info
                            </div>
                            <button type="button" class="btn-panel-edit" id="edit-personal-btn" onclick="toggleEdit('personal')">
                                ✎ Edit
                            </button>
                        </div>

                        <form id="form-personal" action="${pageContext.request.contextPath}/manageProfile" method="post">
                            <input type="hidden" name="formType" value="personal">

                            <div class="form-group">
                                <label>Full Name</label>
                                <div class="field-value" id="view-name"><c:out value="${user.name}"/></div>
                                <input type="text" id="input-name" name="name" class="profile-input"
                                       value="<c:out value='${user.name}'/>" required readonly>
                            </div>

                            <div class="form-group">
                                <label>Email Address</label>
                                <div class="field-value" id="view-email"><c:out value="${user.email}"/></div>
                                <input type="email" id="input-email" name="email" class="profile-input"
                                       value="<c:out value='${user.email}'/>" required readonly>
                            </div>

                            <div class="form-group">
                                <label>Phone Number</label>
                                <div class="field-value ${empty user.phoneNumber ? 'empty' : ''}" id="view-phone">
                                    <c:choose>
                                        <c:when test="${not empty user.phoneNumber}"><c:out value="${user.phoneNumber}"/></c:when>
                                        <c:otherwise>Not set</c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="tel" id="input-phone" name="phoneNumber" class="profile-input"
                                       value="<c:out value='${user.phoneNumber}'/>" readonly>
                            </div>

                            <div class="form-group">
                                <label>Matric / Staff Number</label>
                                <div class="field-value ${empty user.matricNumber ? 'empty' : ''}" id="view-matric">
                                    <c:choose>
                                        <c:when test="${not empty user.matricNumber}"><c:out value="${user.matricNumber}"/></c:when>
                                        <c:otherwise>Not set</c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="text" id="input-matric" name="matricNumber" class="profile-input"
                                       value="<c:out value='${user.matricNumber}'/>"
                                       placeholder="e.g. S12345, A12345, UMT02848" readonly>
                            </div>

                            <!-- Hidden fields required by servlet -->
                            <input type="hidden" name="userID" value="<c:out value='${user.userID}'/>">
                            <input type="hidden" name="ign" value="<c:out value='${user.ign}'/>">
                            <input type="hidden" name="bio" value="<c:out value='${user.bio}'/>">
                            <input type="hidden" name="discordID" value="<c:out value='${user.discordID}'/>">

                            <div class="save-row" id="save-personal">
                                <button type="submit" class="btn-save">💾 Save Changes</button>
                            </div>
                        </form>
                    </div>

                    <!-- PANEL 2: ESPORTS IDENTITY -->
                    <div class="profile-panel">
                        <div class="panel-header">
                            <div class="panel-title">
                                <span class="panel-icon">🎮</span> Esports Identity
                            </div>
                            <button type="button" class="btn-panel-edit" id="edit-esports-btn" onclick="toggleEdit('esports')">
                                ✎ Edit
                            </button>
                        </div>

                        <form id="form-esports" action="${pageContext.request.contextPath}/manageProfile" method="post">
                            <input type="hidden" name="formType" value="esports">

                            <div class="form-group">
                                <label>In-Game Name (IGN)</label>
                                <div class="field-value ${empty user.ign ? 'empty' : ''}" id="view-ign">
                                    <c:choose>
                                        <c:when test="${not empty user.ign}"><c:out value="${user.ign}"/></c:when>
                                        <c:otherwise>Not set</c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="text" id="input-ign" name="ign" class="profile-input"
                                       value="<c:out value='${user.ign}'/>"
                                       placeholder="Your gaming alias..." readonly>
                            </div>

                            <div class="form-group">
                                <label>Discord ID</label>
                                <div class="field-value ${empty user.discordID ? 'empty' : ''}" id="view-discord">
                                    <c:choose>
                                        <c:when test="${not empty user.discordID}"><c:out value="${user.discordID}"/></c:when>
                                        <c:otherwise>Not set</c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="text" id="input-discord" name="discordID" class="profile-input"
                                       value="<c:out value='${user.discordID}'/>"
                                       placeholder="username#0000" readonly>
                            </div>

                            <div class="form-group">
                                <label>Bio</label>
                                <div class="field-value ${empty user.bio ? 'empty' : ''}" id="view-bio"
                                     style="white-space: pre-line; line-height: 1.6;">
                                    <c:choose>
                                        <c:when test="${not empty user.bio}"><c:out value="${user.bio}"/></c:when>
                                        <c:otherwise>Tell the arena who you are...</c:otherwise>
                                    </c:choose>
                                </div>
                                <textarea id="input-bio" name="bio" class="profile-input"
                                          placeholder="Tell the arena who you are..." readonly><c:out value="${user.bio}"/></textarea>
                            </div>

                            <div class="save-row" id="save-esports">
                                <button type="submit" class="btn-save">💾 Save Identity</button>
                            </div>
                        </form>
                    </div>

                </div><!-- /.profile-panels-grid -->

            </div><!-- /.rigid-layout-container -->
        </main>
    </div>

    <jsp:include page="footer.jsp"/>

    <script>
        /* --- Toast auto-dismiss --- */
        const toast = document.getElementById('profile-toast');
        if (toast) {
            setTimeout(() => {
                toast.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                toast.style.opacity = '0';
                toast.style.transform = 'translateX(40px)';
                setTimeout(() => toast.remove(), 500);
            }, 4000);
        }

        /* --- Panel edit toggle --- */
        function toggleEdit(panel) {
            const btn = document.getElementById('edit-' + panel + '-btn');
            const saveRow = document.getElementById('save-' + panel);
            const inputs = document.querySelectorAll('#form-' + panel + ' .profile-input:not([type="hidden"])');
            const views  = document.querySelectorAll('#form-' + panel + ' .field-value');

            const isEditing = btn.classList.contains('cancel');

            if (isEditing) {
                /* Cancel — restore read view */
                inputs.forEach(inp => { inp.readOnly = true; inp.style.display = 'none'; });
                views.forEach(v => v.style.display = '');
                saveRow.classList.remove('visible');
                btn.classList.remove('cancel');
                btn.innerHTML = '✎ Edit';
            } else {
                /* Enter edit mode */
                inputs.forEach(inp => { inp.readOnly = false; inp.style.display = ''; });
                views.forEach(v => v.style.display = 'none');
                saveRow.classList.add('visible');
                btn.classList.add('cancel');
                btn.innerHTML = '✕ Cancel';
                /* Focus first unlocked input */
                if (inputs[0]) inputs[0].focus();
            }
        }

        /* --- Avatar initial from name --- */
        (function() {
            const nameEl = document.getElementById('view-name');
            const avatarEl = document.querySelector('.profile-avatar');
            if (nameEl && avatarEl) {
                const name = nameEl.textContent.trim();
                if (name.length > 0) {
                    avatarEl.textContent = name.charAt(0).toUpperCase();
                }
            }
        })();
    </script>
</body>
</html>
