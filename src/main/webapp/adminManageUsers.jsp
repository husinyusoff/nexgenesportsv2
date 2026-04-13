<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>👤 Manage Users – NexGen Esports</title>

</head>
<body class="app-wrapper">
  <!-- global header -->
  <jsp:include page="/header.jsp"/>

  <div class="main-container">
    <jsp:include page="/sidebar.jsp"/>

    <main class="content">
      <div class="rigid-layout-container">
      
        <!-- COHESIVE PROFILE HERO -->
        <div class="profile-hero">
            <div class="profile-hero-icon">👥</div>
            <h2>Manage Users</h2>
            <p class="subtitle">Review, update roles, and deactivate users in the arena.</p>
        </div>

        <!-- ALERTS -->
        <c:if test="${not empty sessionScope.adminSuccessMsg}">
          <div class="success-msg" style="animation: modalSlideIn 0.4s ease-out;">
            ✓ ${sessionScope.adminSuccessMsg}
          </div>
          <c:remove var="adminSuccessMsg" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.adminErrorMsg}">
          <div class="success-msg" style="background: rgba(255, 0, 127, 0.1); color: var(--neon-pink); border-color: var(--neon-pink); animation: modalSlideIn 0.4s ease-out;">
            ✕ ${sessionScope.adminErrorMsg}
          </div>
          <c:remove var="adminErrorMsg" scope="session"/>
        </c:if>

        <div class="profile-panels-grid" style="grid-template-columns: 1fr;">

            <!-- FILTER PANEL -->
            <div class="profile-panel" style="padding: 18px 20px;">
                <div class="panel-header" style="margin-bottom: 14px; padding-bottom: 12px;">
                    <div class="panel-title"><span class="panel-icon">🔍</span> Search &amp; Filters</div>
                </div>
                <div class="filter-bar">
                    <div class="filter-bar-row">
                        <div class="form-group">
                            <label>Search</label>
                            <input type="text" id="searchInput" class="profile-input" placeholder="Username, name, or email...">
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <select id="roleFilter" class="profile-input">
                                <option value="ALL">All Roles</option>
                                <c:forEach var="role" items="${rolesList}">
                                    <option value="${role.role}">${role.role}<c:if test="${not empty role.position}"> - ${role.position}</c:if></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="filter-check">
                        <input type="checkbox" id="hideDisabledToggle" checked>
                        <label for="hideDisabledToggle">Hide Deactivated Users</label>
                    </div>
                </div>
            </div>

            <!-- REGISTRY PANEL -->
            <div class="profile-panel" style="padding: 18px 20px;">
                <div class="panel-header" style="margin-bottom: 0; padding-bottom: 12px;">
                    <div class="panel-title"><span class="panel-icon">📋</span> User Registry</div>
                    <span style="font-size:0.75rem; color:var(--text-muted); letter-spacing:1px;">Click a row to expand</span>
                </div>

                <div class="user-list" id="userList">
                <c:forEach var="user" items="${usersList}">
                  <c:set var="userRoleText" value=""/>
                  <c:set var="userRoleRaw" value=""/>
                  <c:forEach var="r" items="${rolesList}">
                    <c:if test="${r.id == user.rpId}">
                      <c:set var="userRoleText" value="${r.role}"/>
                      <c:set var="userRoleRaw" value="${r.role}"/>
                      <c:if test="${not empty r.position}">
                        <c:set var="userRoleText" value="${r.role} - ${r.position}"/>
                      </c:if>
                    </c:if>
                  </c:forEach>

                  <div class="user-card ${userRoleRaw == 'disabled' ? 'is-disabled' : ''}"
                       data-search="${user.userID.toLowerCase()} ${user.name.toLowerCase()} ${user.email.toLowerCase()}"
                       data-role="${userRoleRaw}">

                    <div class="user-card-summary" onclick="toggleCard(this.parentElement)">
                      <div class="user-avatar-sm">${fn:substring(user.name,0,1)}</div>
                      <div class="user-card-meta">
                        <div class="user-card-name">${user.name}</div>
                        <div class="user-card-uid">${user.userID}</div>
                      </div>
                      <div class="user-card-badges">
                        <c:choose>
                          <c:when test="${userRoleRaw == 'disabled'}">
                            <span class="badge badge-danger">Deactivated</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge" style="background:rgba(0,229,255,0.1);color:var(--neon-cyan);border:1px solid rgba(0,229,255,0.4);">${userRoleText}</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                      <span class="user-card-chevron">▼</span>
                    </div>

                    <div class="user-card-details">
                      <div class="user-card-details-inner">
                        <div class="detail-field">
                          <span class="df-label">Email</span>
                          <span class="df-value ${empty user.email ? 'empty' : ''}">${empty user.email ? '—' : user.email}</span>
                        </div>
                        <div class="detail-field">
                          <span class="df-label">Registered</span>
                          <span class="df-value">${user.registrationDate.toLocalDate()}</span>
                        </div>
                        <div class="detail-field">
                          <span class="df-label">Phone</span>
                          <span class="df-value ${empty user.phoneNumber ? 'empty' : ''}">${empty user.phoneNumber ? '—' : user.phoneNumber}</span>
                        </div>
                        <div class="detail-field">
                          <span class="df-label">Matric / Staff</span>
                          <span class="df-value ${empty user.matricNumber ? 'empty' : ''}">${empty user.matricNumber ? '—' : user.matricNumber}</span>
                        </div>
                      </div>

                      <div class="user-card-actions">
                        <button type="button" class="btn-panel-edit" onclick="openPersonalModal('${user.userID}')">🪪 Personal Info</button>
                        <button type="button" class="btn-panel-edit" style="border-color:rgba(176,38,255,0.5);color:var(--neon-purple);" onclick="openEsportsModal('${user.userID}')">🎮 Esports ID</button>
                        <c:choose>
                          <c:when test="${userRoleRaw == 'disabled'}">
                            <button type="button" class="btn-panel-edit" style="border-color:rgba(0,255,136,0.5);color:var(--neon-green);" onclick="openReactivateModal('${user.userID}','${fn:escapeXml(user.name)}')">✓ Enable</button>
                          </c:when>
                          <c:otherwise>
                            <button type="button" class="btn-panel-edit cancel" onclick="openDeactivateModal('${user.userID}','${fn:escapeXml(user.name)}')">✕ Deactivate</button>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>

                    <template id="user-data-${user.userID}">
                      <span class="d-id"><c:out value="${user.userID}"/></span>
                      <span class="d-name"><c:out value="${user.name}"/></span>
                      <span class="d-email"><c:out value="${user.email}"/></span>
                      <span class="d-phone"><c:out value="${user.phoneNumber}"/></span>
                      <span class="d-matric"><c:out value="${user.matricNumber}"/></span>
                      <span class="d-ign"><c:out value="${user.ign}"/></span>
                      <span class="d-discord"><c:out value="${user.discordID}"/></span>
                      <span class="d-bio"><c:out value="${user.bio}"/></span>
                      <span class="d-rpid"><c:out value="${user.rpId}"/></span>
                    </template>
                  </div>
                </c:forEach>

                <c:if test="${empty usersList}">
                  <div class="empty-state" style="border:none;background:transparent;">
                    <div class="empty-icon">👥</div>
                    <div class="empty-message">No users found.</div>
                  </div>
                </c:if>
                </div><%-- /user-list --%>
            </div>

        </div><%-- /.profile-panels-grid --%>

      </div><%-- /.rigid-layout-container --%>
    </main><%-- /.content --%>
  </div><%-- /.main-container --%>




  <jsp:include page="/footer.jsp"/>

  <!-- Personal Info Modal -->
  <div id="personalModal" class="modal-overlay">
      <div class="modal-content profile-panel" style="background: rgba(10, 10, 18, 0.97); margin: 20px; max-width: 500px; padding: 0; max-height: 90vh; display: flex; flex-direction: column;">
          <div class="panel-header" style="padding: 20px 28px; margin: 0; border-bottom: 1px solid rgba(0,229,255,0.12); flex-shrink: 0;">
              <div class="panel-title"><span class="panel-icon">🪪</span> Personal Info: <span id="personalModalUserName" style="color: var(--neon-cyan);"></span></div>
              <button type="button" class="btn-close" onclick="closeModals()">×</button>
          </div>
          <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: flex; flex-direction: column; overflow-y: auto; flex: 1;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="updateUser">
              <input type="hidden" name="targetUserID" id="personalUserID" value="">
              <div style="padding: 24px 28px; flex: 1;">
                  <div class="form-group">
                      <label>Full Name</label>
                      <input type="text" name="name" id="personalName" class="profile-input" required>
                  </div>
                  <div class="form-group">
                      <label>Email Address</label>
                      <input type="email" name="email" id="personalEmail" class="profile-input" required>
                  </div>
                  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                      <div class="form-group">
                          <label>Phone Number</label>
                          <input type="tel" name="phoneNumber" id="personalPhone" class="profile-input">
                      </div>
                      <div class="form-group">
                          <label>Matric / Staff No.</label>
                          <input type="text" name="matricNumber" id="personalMatric" class="profile-input">
                      </div>
                  </div>
                  <div class="form-group" style="margin-bottom: 0;">
                      <label>System Role</label>
                      <select name="rpId" id="personalRpId" class="profile-input" required>
                          <c:forEach var="role" items="${rolesList}">
                              <c:if test="${role.role != 'disabled'}">
                                  <option value="${role.id}">
                                      ${role.role}<c:if test="${not empty role.position}"> - ${role.position}</c:if>
                                  </option>
                              </c:if>
                          </c:forEach>
                      </select>
                  </div>
              </div>
              <div class="save-row visible" style="border-top: 1px solid rgba(255,255,255,0.05); padding: 14px 28px; background: rgba(10,10,18,0.97); border-radius: 0 0 16px 16px;">
                  <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex: 0.4; justify-content: center;">Cancel</button>
                  <button type="submit" class="btn-save" style="flex: 1;">💾 Save Personal Info</button>
              </div>
          </form>
      </div>
  </div>

  <!-- Esports Identity Modal -->
  <div id="esportsModal" class="modal-overlay">
      <div class="modal-content profile-panel" style="background: rgba(10, 10, 18, 0.97); margin: 20px; max-width: 500px; padding: 0; max-height: 90vh; display: flex; flex-direction: column; border-color: rgba(176,38,255,0.35);">
          <div class="panel-header" style="padding: 20px 28px; margin: 0; border-bottom: 1px solid rgba(176,38,255,0.12); flex-shrink: 0;">
              <div class="panel-title" style="color: var(--neon-purple);"><span class="panel-icon">🎮</span> Esports Identity: <span id="esportsModalUserName" style="color: var(--neon-purple);"></span></div>
              <button type="button" class="btn-close" onclick="closeModals()">×</button>
          </div>
          <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: flex; flex-direction: column; overflow-y: auto; flex: 1;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="updateUser">
              <input type="hidden" name="targetUserID" id="esportsUserID" value="">
              <div style="padding: 24px 28px; flex: 1;">
                  <div class="form-group">
                      <label>In-Game Name (IGN)</label>
                      <input type="text" name="ign" id="esportsIgn" class="profile-input" placeholder="e.g. NexG_Player1">
                  </div>
                  <div class="form-group">
                      <label>Discord ID</label>
                      <input type="text" name="discordID" id="esportsDiscord" class="profile-input" placeholder="e.g. username#1234">
                  </div>
                  <div class="form-group" style="margin-bottom: 0;">
                      <label>Bio</label>
                      <textarea name="bio" id="esportsBio" class="profile-input" rows="4" placeholder="Player bio, achievements, game preferences..."></textarea>
                  </div>
              </div>
              <div class="save-row visible" style="border-top: 1px solid rgba(255,255,255,0.05); padding: 14px 28px; background: rgba(10,10,18,0.97); border-radius: 0 0 16px 16px;">
                  <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex: 0.4; justify-content: center;">Cancel</button>
                  <button type="submit" class="btn-save" style="flex: 1; background: linear-gradient(90deg, var(--neon-purple), #8b3fc8);">💾 Save Esports Info</button>
              </div>
          </form>
      </div>
  </div>

  <!-- Deactivate Modal -->
  <div id="deactivateModal" class="modal-overlay">
      <div class="modal-content profile-panel" style="background: rgba(20, 10, 15, 0.95); border-color: var(--neon-pink); margin: 20px;">
          <div class="panel-header">
              <div class="panel-title" style="color: var(--neon-pink);"><span class="panel-icon">⚠</span> Confirm Deactivation</div>
              <button type="button" class="btn-close" onclick="closeModals()">×</button>
          </div>
          
          <p style="color: var(--text-primary); margin-bottom: 1.5rem;" id="deactivateModalInfo"></p>
          <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; line-height: 1.5;">
              This will revoke the user's access to the system immediately. Their historical data will remain intact.
          </p>
          <form action="${pageContext.request.contextPath}/admin/users" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="deactivate">
              <input type="hidden" name="targetUserID" id="deactivateUserID" value="">
              
              <div class="save-row visible" style="border-top: none;">
                  <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex: 0.5; justify-content: center;">Cancel</button>
                  <button type="submit" class="btn-save" style="background: linear-gradient(90deg, var(--neon-pink), #cc0052); flex: 1;">Deactivate</button>
              </div>
          </form>
      </div>
  </div>

  <!-- Reactivate Modal -->
  <div id="reactivateModal" class="modal-overlay">
      <div class="modal-content profile-panel" style="background: rgba(10, 20, 15, 0.97); border-color: rgba(0,255,136,0.35); margin: 20px; max-width: 480px;">
          <div class="panel-header">
              <div class="panel-title" style="color: var(--neon-green);"><span class="panel-icon">✅</span> Confirm Re-enable</div>
              <button type="button" class="btn-close" onclick="closeModals()">×</button>
          </div>
          <p style="color: var(--text-primary); margin-bottom: 1rem;" id="reactivateModalInfo"></p>
          <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; line-height: 1.5;">
              This will restore the user's access as an <strong style="color: var(--neon-green);">Athlete</strong>. You can adjust their role using the Personal Info editor after re-enabling.
          </p>
          <form action="${pageContext.request.contextPath}/admin/users" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="reactivate">
              <input type="hidden" name="targetUserID" id="reactivateUserID" value="">
              <div class="save-row visible" style="border-top: none;">
                  <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex: 0.5; justify-content: center;">Cancel</button>
                  <button type="submit" class="btn-save" style="background: linear-gradient(90deg, var(--neon-green), #00b35a); color: #000; flex: 1;">Re-enable Account</button>
              </div>
          </form>
      </div>
  </div>

  <script>
    const searchInput       = document.getElementById('searchInput');
    const roleFilter        = document.getElementById('roleFilter');
    const hideDisabledToggle = document.getElementById('hideDisabledToggle');
    const userList          = document.getElementById('userList');
    let cards = Array.from(document.querySelectorAll('.user-card'));

    // ── Accordion ──────────────────────────────────────────────
    function toggleCard(card) {
        const isOpen = card.classList.contains('is-open');
        // Close all others
        cards.forEach(c => c.classList.remove('is-open'));
        if (!isOpen) card.classList.add('is-open');
    }

    // ── Filter ─────────────────────────────────────────────────
    function filterCards() {
        const query       = searchInput.value.toLowerCase().trim();
        const role        = roleFilter.value;
        const hideDisabled = hideDisabledToggle.checked;

        cards.forEach(card => {
            const cardRole    = card.getAttribute('data-role');
            const matchSearch = card.getAttribute('data-search').includes(query);
            const matchRole   = (role === 'ALL' || cardRole === role);
            const matchActive = !(hideDisabled && cardRole === 'disabled');
            card.style.display = (matchSearch && matchRole && matchActive) ? '' : 'none';
        });
    }

    searchInput.addEventListener('input', filterCards);
    roleFilter.addEventListener('change', filterCards);
    hideDisabledToggle.addEventListener('change', filterCards);
    filterCards(); // initial pass

    // ── Modal helpers ──────────────────────────────────────────
    function getTemplateVal(userID, cls) {
        const tpl = document.getElementById('user-data-' + userID);
        if (!tpl) return '';
        const el = tpl.content.querySelector(cls);
        return el ? el.textContent.trim() : '';
    }

    function openPersonalModal(userID) {
        const name = getTemplateVal(userID, '.d-name');
        document.getElementById('personalUserID').value = userID;
        document.getElementById('personalModalUserName').textContent = name + ' (' + userID + ')';
        document.getElementById('personalName').value  = name;
        document.getElementById('personalEmail').value = getTemplateVal(userID, '.d-email');
        document.getElementById('personalPhone').value = getTemplateVal(userID, '.d-phone');
        document.getElementById('personalMatric').value = getTemplateVal(userID, '.d-matric');
        const rpId = getTemplateVal(userID, '.d-rpid');
        const select = document.getElementById('personalRpId');
        for (let i = 0; i < select.options.length; i++) {
            select.options[i].selected = (select.options[i].value === rpId);
        }
        document.getElementById('personalModal').classList.add('active');
    }

    function openEsportsModal(userID) {
        const name = getTemplateVal(userID, '.d-name');
        document.getElementById('esportsUserID').value = userID;
        document.getElementById('esportsModalUserName').textContent = name + ' (' + userID + ')';
        document.getElementById('esportsIgn').value     = getTemplateVal(userID, '.d-ign');
        document.getElementById('esportsDiscord').value = getTemplateVal(userID, '.d-discord');
        document.getElementById('esportsBio').value     = getTemplateVal(userID, '.d-bio');
        document.getElementById('esportsModal').classList.add('active');
    }

    function openDeactivateModal(userID, userName) {
        document.getElementById('deactivateUserID').value = userID;
        document.getElementById('deactivateModalInfo').innerHTML =
            'Are you sure you want to deactivate <strong>' + userName + '</strong> (' + userID + ')?';
        document.getElementById('deactivateModal').classList.add('active');
    }

    function openReactivateModal(userID, userName) {
        document.getElementById('reactivateUserID').value = userID;
        document.getElementById('reactivateModalInfo').innerHTML =
            'Re-enable account for <strong>' + userName + '</strong> (' + userID + ')?';
        document.getElementById('reactivateModal').classList.add('active');
    }

    function closeModals() {
        document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
    }
  </script>

</body>
</html>
