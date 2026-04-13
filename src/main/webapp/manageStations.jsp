<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>🖥 Manage Stations – NexGen Esports</title>
</head>
<body class="app-wrapper">
  <jsp:include page="header.jsp"/>

  <div class="main-container">
    <jsp:include page="sidebar.jsp"/>

    <main class="content">
      <div class="rigid-layout-container">

        <!-- HERO -->
        <div class="profile-hero">
          <div class="profile-hero-icon">🖥</div>
          <h2>Manage Stations</h2>
          <p class="subtitle">Configure gaming stations, pricing tiers, and availability.</p>
        </div>

        <!-- ALERTS -->
        <c:if test="${not empty sessionScope.stationSuccess}">
          <div class="success-msg" style="animation: modalSlideIn 0.4s ease-out;">✓ ${sessionScope.stationSuccess}</div>
          <c:remove var="stationSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.stationError}">
          <div class="success-msg" style="background:rgba(255,0,127,0.1);color:var(--neon-pink);border-color:var(--neon-pink);">✕ ${sessionScope.stationError}</div>
          <c:remove var="stationError" scope="session"/>
        </c:if>

        <div class="profile-panels-grid" style="grid-template-columns: 1fr;">

          <!-- FILTER PANEL -->
          <div class="profile-panel" style="padding: 18px 20px;">
            <div class="panel-header" style="margin-bottom: 14px; padding-bottom: 12px;">
              <div class="panel-title"><span class="panel-icon">🔍</span> Search Stations</div>
              <button type="button" class="btn-panel-edit"
                      style="flex-shrink:0; width:auto; background:rgba(176,38,255,0.15); border-color:rgba(176,38,255,0.5); color:var(--neon-purple); font-size:0.78rem; padding:6px 16px;"
                      onclick="openAddStationModal()">+ Add Station</button>
            </div>

            <div class="filter-bar">
              <div class="filter-bar-row">
                <div class="form-group">
                  <label>Search</label>
                  <input type="text" id="searchInput" class="profile-input" placeholder="Station ID or name...">
                </div>
              </div>
            </div>
          </div>

          <!-- REGISTRY PANEL -->
          <div class="profile-panel" style="padding: 18px 20px;">
            <div class="panel-header" style="margin-bottom: 0; padding-bottom: 12px;">
              <div class="panel-title"><span class="panel-icon">📡</span> Station Registry</div>
              <span style="font-size:0.75rem; color:var(--text-muted); letter-spacing:1px;">Click a row to expand</span>
            </div>

            <div class="user-list" id="stationList">
              <c:forEach var="s" items="${stations}">
                <div class="user-card"
                     data-search="${fn:toLowerCase(s.stationID)} ${fn:toLowerCase(s.stationName)}">

                  <div class="user-card-summary" onclick="toggleCard(this.parentElement)">
                    <div class="user-avatar-sm" style="font-size:1.1rem; background:linear-gradient(135deg,rgba(176,38,255,0.2),rgba(0,229,255,0.2)); border-color:rgba(176,38,255,0.4);">🖥</div>
                    <div class="user-card-meta">
                      <div class="user-card-name">${s.stationName}</div>
                      <div class="user-card-uid">${s.stationID}</div>
                    </div>
                    <div class="user-card-badges">
                      <span class="badge" style="background:rgba(0,229,255,0.1);color:var(--neon-cyan);border:1px solid rgba(0,229,255,0.4);">RM ${s.normalPrice1Player} / hr</span>
                    </div>
                    <span class="user-card-chevron">▼</span>
                  </div>

                  <div class="user-card-details">
                    <div class="user-card-details-inner">
                      <div class="detail-field">
                        <span class="df-label">Normal 1P</span>
                        <span class="df-value">RM ${s.normalPrice1Player}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Normal 2P</span>
                        <span class="df-value">${empty s.normalPrice2Player ? '—' : 'RM '.concat(s.normalPrice2Player)}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Happy Hour 1P</span>
                        <span class="df-value">RM ${s.happyHourPrice1Player}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Happy Hour 2P</span>
                        <span class="df-value">${empty s.happyHourPrice2Player ? '—' : 'RM '.concat(s.happyHourPrice2Player)}</span>
                      </div>
                    </div>
                    <div class="user-card-actions">
                      <button type="button" class="btn-panel-edit" onclick="openEditStationModal('${s.stationID}')">✏ Edit Station</button>
                      <button type="button" class="btn-panel-edit cancel" onclick="openDeleteStationModal('${s.stationID}','${fn:escapeXml(s.stationName)}')">🗑 Delete</button>
                    </div>
                  </div>

                  <!-- Data template for JS -->
                  <template id="st-data-${s.stationID}">
                    <span class="d-id"><c:out value="${s.stationID}"/></span>
                    <span class="d-name"><c:out value="${s.stationName}"/></span>
                    <span class="d-n1p"><c:out value="${s.normalPrice1Player}"/></span>
                    <span class="d-n2p"><c:out value="${s.normalPrice2Player}"/></span>
                    <span class="d-h1p"><c:out value="${s.happyHourPrice1Player}"/></span>
                    <span class="d-h2p"><c:out value="${s.happyHourPrice2Player}"/></span>
                  </template>
                </div>
              </c:forEach>

              <c:if test="${empty stations}">
                <div class="empty-state" style="border:none;background:transparent;">
                  <div class="empty-icon">🖥</div>
                  <div class="empty-message">No stations configured yet.</div>
                </div>
              </c:if>
            </div><%-- /stationList --%>
          </div>

        </div><%-- /.profile-panels-grid --%>
      </div><%-- /.rigid-layout-container --%>
    </main>
  </div>

  <jsp:include page="footer.jsp"/>

  <!-- ── ADD / EDIT STATION MODAL ──────────────────────────── -->
  <div id="stationModal" class="modal-overlay">
    <div class="modal-content profile-panel" style="max-width:480px;padding:0;background:rgba(10,10,18,0.97);border-color:rgba(176,38,255,0.35);">
      <div class="panel-header" style="padding:20px 28px;margin:0;border-bottom:1px solid rgba(176,38,255,0.12);flex-shrink:0;">
        <div class="panel-title" id="stationModalTitle" style="color:var(--neon-purple);"><span class="panel-icon">🖥</span> Add Station</div>
        <button type="button" class="btn-close" onclick="closeModals()">×</button>
      </div>
      <form id="stationForm" method="post" action="${pageContext.request.contextPath}/stations/add" style="display:flex;flex-direction:column;">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <div style="padding:22px 28px;display:grid;grid-template-columns:1fr 1fr;gap:14px 20px;">
          <div class="form-group" style="grid-column:1/-1;">
            <label>Station ID</label>
            <input type="text" name="stationID" id="stModalID" class="profile-input" required>
          </div>
          <div class="form-group" style="grid-column:1/-1;">
            <label>Station Name</label>
            <input type="text" name="stationName" id="stModalName" class="profile-input" required>
          </div>
          <div class="form-group">
            <label>Normal 1P (RM)</label>
            <input type="number" step="0.01" name="normalPrice1Player" id="stModalN1P" class="profile-input" required>
          </div>
          <div class="form-group">
            <label>Normal 2P (RM)</label>
            <input type="number" step="0.01" name="normalPrice2Player" id="stModalN2P" class="profile-input">
          </div>
          <div class="form-group">
            <label>Happy Hour 1P (RM)</label>
            <input type="number" step="0.01" name="happyHourPrice1Player" id="stModalH1P" class="profile-input" required>
          </div>
          <div class="form-group">
            <label>Happy Hour 2P (RM)</label>
            <input type="number" step="0.01" name="happyHourPrice2Player" id="stModalH2P" class="profile-input">
          </div>
        </div>
        <div class="save-row visible" style="border-top:1px solid rgba(255,255,255,0.05);padding:14px 28px;border-radius:0 0 16px 16px;">
          <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex:0.4;justify-content:center;">Cancel</button>
          <button type="submit" class="btn-save" style="flex:1;" id="stModalSubmitBtn">💾 Add Station</button>
        </div>
      </form>
    </div>
  </div>

  <!-- ── DELETE CONFIRM MODAL ───────────────────────────────── -->
  <div id="deleteStationModal" class="modal-overlay">
    <div class="modal-content profile-panel" style="max-width:400px;padding:0;background:rgba(10,10,18,0.97);border-color:rgba(255,0,127,0.4);">
      <div class="panel-header" style="padding:20px 28px;margin:0;border-bottom:1px solid rgba(255,0,127,0.12);">
        <div class="panel-title" style="color:var(--neon-pink);"><span class="panel-icon">⚠</span> Confirm Delete</div>
        <button type="button" class="btn-close" onclick="closeModals()">×</button>
      </div>
      <div style="padding:22px 28px;">
        <p id="deleteStationInfo" style="color:var(--text-muted);line-height:1.6;margin:0 0 20px;"></p>
        <form action="${pageContext.request.contextPath}/stations/delete" method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <input type="hidden" name="stationID" id="deleteStationID">
          <div class="save-row visible" style="padding:0;">
            <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex:0.5;justify-content:center;">Cancel</button>
            <button type="submit" class="btn-save" style="flex:1;background:linear-gradient(90deg,var(--neon-pink),#a0003f);color:#fff;">🗑 Delete Station</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    const cards = Array.from(document.querySelectorAll('.user-card'));
    const searchInput = document.getElementById('searchInput');

    function toggleCard(card) {
      const isOpen = card.classList.contains('is-open');
      cards.forEach(c => c.classList.remove('is-open'));
      if (!isOpen) card.classList.add('is-open');
    }

    searchInput.addEventListener('input', () => {
      const q = searchInput.value.toLowerCase().trim();
      cards.forEach(c => {
        c.style.display = c.getAttribute('data-search').includes(q) ? '' : 'none';
      });
    });

    function getTplVal(sid, cls) {
      const tpl = document.getElementById('st-data-' + sid);
      if (!tpl) return '';
      const el = tpl.content.querySelector(cls);
      return el ? el.textContent.trim() : '';
    }

    function openAddStationModal() {
      document.getElementById('stationModalTitle').innerHTML = '<span class="panel-icon">🖥</span> Add Station';
      document.getElementById('stationForm').action = '${pageContext.request.contextPath}/stations/add';
      document.getElementById('stModalSubmitBtn').textContent = '💾 Add Station';
      document.getElementById('stModalID').value = '';
      document.getElementById('stModalID').readOnly = false;
      document.getElementById('stModalName').value = '';
      document.getElementById('stModalN1P').value = '';
      document.getElementById('stModalN2P').value = '';
      document.getElementById('stModalH1P').value = '';
      document.getElementById('stModalH2P').value = '';
      document.getElementById('stationModal').classList.add('active');
    }

    function openEditStationModal(sid) {
      document.getElementById('stationModalTitle').innerHTML = '<span class="panel-icon">✏</span> Edit Station';
      document.getElementById('stationForm').action = '${pageContext.request.contextPath}/stations/edit';
      document.getElementById('stModalSubmitBtn').textContent = '💾 Update Station';
      document.getElementById('stModalID').value = getTplVal(sid, '.d-id');
      document.getElementById('stModalID').readOnly = true;
      document.getElementById('stModalName').value = getTplVal(sid, '.d-name');
      document.getElementById('stModalN1P').value  = getTplVal(sid, '.d-n1p');
      document.getElementById('stModalN2P').value  = getTplVal(sid, '.d-n2p');
      document.getElementById('stModalH1P').value  = getTplVal(sid, '.d-h1p');
      document.getElementById('stModalH2P').value  = getTplVal(sid, '.d-h2p');
      document.getElementById('stationModal').classList.add('active');
    }

    function openDeleteStationModal(sid, sname) {
      document.getElementById('deleteStationID').value = sid;
      document.getElementById('deleteStationInfo').innerHTML =
        'Are you sure you want to delete station <strong>' + sname + '</strong> (' + sid + ')? This cannot be undone.';
      document.getElementById('deleteStationModal').classList.add('active');
    }

    function closeModals() {
      document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
    }
  </script>
</body>
</html>
