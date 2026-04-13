<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>📋 Manage All Bookings – NexGen Esports</title>
</head>
<body class="app-wrapper">
  <jsp:include page="header.jsp"/>

  <div class="main-container">
    <jsp:include page="sidebar.jsp"/>

    <main class="content">
      <div class="rigid-layout-container">

        <!-- HERO -->
        <div class="profile-hero">
          <div class="profile-hero-icon">📋</div>
          <h2>Manage All Bookings</h2>
          <p class="subtitle">Review, update status, and manage station reservations across the arena.</p>
        </div>

        <!-- ALERTS -->
        <c:if test="${not empty sessionScope.bookingSuccess}">
          <div class="success-msg" style="animation: modalSlideIn 0.4s ease-out;">✓ ${sessionScope.bookingSuccess}</div>
          <c:remove var="bookingSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.bookingError}">
          <div class="success-msg" style="background:rgba(255,0,127,0.1);color:var(--neon-pink);border-color:var(--neon-pink);">✕ ${sessionScope.bookingError}</div>
          <c:remove var="bookingError" scope="session"/>
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
                  <input type="text" id="searchInput" class="profile-input" placeholder="Booking ID, user, or station...">
                </div>
                <div class="form-group">
                  <label>Station</label>
                  <select id="stationFilter" class="profile-input">
                    <option value="ALL">All Stations</option>
                    <c:forEach var="st" items="${stations}">
                      <option value="${st.stationID}">${st.stationName} (${st.stationID})</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label>Status</label>
                  <select id="statusFilter" class="profile-input">
                    <option value="ALL">All Statuses</option>
                    <option value="Confirmed">Confirmed</option>
                    <option value="Cancelled">Cancelled</option>
                    <option value="Completed">Completed</option>
                    <option value="Blocked">Blocked</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- BOOKING CARDS PANEL -->
          <div class="profile-panel" style="padding: 18px 20px;">
            <div class="panel-header" style="margin-bottom: 0; padding-bottom: 12px;">
              <div class="panel-title"><span class="panel-icon">🗂</span> Booking Registry</div>
              <span style="font-size:0.75rem; color:var(--text-muted); letter-spacing:1px;">Click a row to expand</span>
            </div>

            <div class="user-list" id="bookingList">
              <c:forEach var="b" items="${bookings}">
                <c:set var="statusClass" value=""/>
                <c:choose>
                  <c:when test="${b.status == 'Cancelled'}"><c:set var="statusClass" value="is-disabled"/></c:when>
                  <c:when test="${b.status == 'Blocked'}"><c:set var="statusClass" value="is-disabled"/></c:when>
                </c:choose>

                <div class="user-card ${statusClass}"
                     data-search="${b.bookingID} ${fn:toLowerCase(b.userID)} ${fn:toLowerCase(b.stationID)}"
                     data-station="${b.stationID}"
                     data-status="${b.status}">

                  <div class="user-card-summary" onclick="toggleCard(this.parentElement)">
                    <div class="user-avatar-sm">${fn:substring(b.userID, 0, 1)}</div>
                    <div class="user-card-meta">
                      <div class="user-card-name">${b.userID}</div>
                      <div class="user-card-uid">#${b.bookingID} · ${b.stationID} · ${b.date}</div>
                    </div>
                    <div class="user-card-badges">
                      <span class="badge" style="background:rgba(176,38,255,0.1);color:var(--neon-purple);border:1px solid rgba(176,38,255,0.4);">${b.stationID}</span>
                      <c:choose>
                        <c:when test="${b.status == 'Confirmed'}">
                          <span class="badge badge-success">${b.status}</span>
                        </c:when>
                        <c:when test="${b.status == 'Cancelled' || b.status == 'Blocked'}">
                          <span class="badge badge-danger">${b.status}</span>
                        </c:when>
                        <c:when test="${b.status == 'Completed'}">
                          <span class="badge" style="background:rgba(0,229,255,0.1);color:var(--neon-cyan);border:1px solid rgba(0,229,255,0.4);">${b.status}</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-warning">${b.status}</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <span class="user-card-chevron">▼</span>
                  </div>

                  <div class="user-card-details">
                    <div class="user-card-details-inner">
                      <div class="detail-field">
                        <span class="df-label">Time</span>
                        <span class="df-value">${b.startTime} – ${b.endTime}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Price</span>
                        <span class="df-value">RM ${b.price}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Price Type</span>
                        <span class="df-value">${empty b.priceType ? '—' : b.priceType}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Players</span>
                        <span class="df-value">${b.playerCount}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Payment</span>
                        <span class="df-value">${empty b.paymentStatus ? '—' : b.paymentStatus}</span>
                      </div>
                      <div class="detail-field">
                        <span class="df-label">Ref</span>
                        <span class="df-value ${empty b.paymentReference ? 'empty' : ''}">${empty b.paymentReference ? '—' : b.paymentReference}</span>
                      </div>
                    </div>
                    <div class="user-card-actions">
                      <button type="button" class="btn-panel-edit" onclick="openUpdateModal('${b.bookingID}','${b.status}')">✏ Update Status</button>
                      <button type="button" class="btn-panel-edit cancel" onclick="openDeleteModal('${b.bookingID}','${b.userID}')">🗑 Delete</button>
                    </div>
                  </div>
                </div>
              </c:forEach>

              <c:if test="${empty bookings}">
                <div class="empty-state" style="border:none;background:transparent;">
                  <div class="empty-icon">📋</div>
                  <div class="empty-message">No bookings found.</div>
                </div>
              </c:if>
            </div><%-- /bookingList --%>
          </div>

        </div><%-- /.profile-panels-grid --%>
      </div><%-- /.rigid-layout-container --%>
    </main>
  </div>

  <jsp:include page="footer.jsp"/>

  <!-- ── UPDATE STATUS MODAL ────────────────────────────────── -->
  <div id="updateModal" class="modal-overlay">
    <div class="modal-content profile-panel" style="max-width:400px;padding:0;background:rgba(10,10,18,0.97);">
      <div class="panel-header" style="padding:20px 28px;margin:0;border-bottom:1px solid rgba(0,229,255,0.12);">
        <div class="panel-title"><span class="panel-icon">✏</span> Update Booking Status</div>
        <button type="button" class="btn-close" onclick="closeModals()">×</button>
      </div>
      <form action="${pageContext.request.contextPath}/booking/update" method="post" style="display:flex;flex-direction:column;">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="bookingID" id="updateBookingID">
        <div style="padding:22px 28px;">
          <p id="updateModalInfo" style="color:var(--text-muted);margin:0 0 16px;font-size:0.88rem;"></p>
          <div class="form-group" style="margin-bottom:0;">
            <label>New Status</label>
            <select name="status" id="updateStatusSelect" class="profile-input">
              <option value="Confirmed">Confirmed</option>
              <option value="Cancelled">Cancelled</option>
              <option value="Completed">Completed</option>
              <option value="Blocked">Blocked</option>
            </select>
          </div>
        </div>
        <div class="save-row visible" style="border-top:1px solid rgba(255,255,255,0.05);padding:14px 28px;border-radius:0 0 16px 16px;">
          <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex:0.4;justify-content:center;">Cancel</button>
          <button type="submit" class="btn-save" style="flex:1;">✏ Update</button>
        </div>
      </form>
    </div>
  </div>

  <!-- ── DELETE CONFIRM MODAL ───────────────────────────────── -->
  <div id="deleteModal" class="modal-overlay">
    <div class="modal-content profile-panel" style="max-width:400px;padding:0;background:rgba(10,10,18,0.97);border-color:rgba(255,0,127,0.4);">
      <div class="panel-header" style="padding:20px 28px;margin:0;border-bottom:1px solid rgba(255,0,127,0.12);">
        <div class="panel-title" style="color:var(--neon-pink);"><span class="panel-icon">⚠</span> Confirm Delete</div>
        <button type="button" class="btn-close" onclick="closeModals()">×</button>
      </div>
      <div style="padding:22px 28px;">
        <p id="deleteModalInfo" style="color:var(--text-muted);line-height:1.6;margin:0 0 20px;"></p>
        <form action="${pageContext.request.contextPath}/booking/delete" method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <input type="hidden" name="bookingID" id="deleteBookingID">
          <div class="save-row visible" style="padding:0;">
            <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex:0.5;justify-content:center;">Cancel</button>
            <button type="submit" class="btn-save" style="flex:1;background:linear-gradient(90deg,var(--neon-pink),#a0003f);color:#fff;">🗑 Delete Booking</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    const cards      = Array.from(document.querySelectorAll('.user-card'));
    const searchInput   = document.getElementById('searchInput');
    const stationFilter = document.getElementById('stationFilter');
    const statusFilter  = document.getElementById('statusFilter');

    function toggleCard(card) {
      const isOpen = card.classList.contains('is-open');
      cards.forEach(c => c.classList.remove('is-open'));
      if (!isOpen) card.classList.add('is-open');
    }

    function filterCards() {
      const q       = searchInput.value.toLowerCase().trim();
      const station = stationFilter.value;
      const status  = statusFilter.value;
      cards.forEach(c => {
        const matchQ  = c.getAttribute('data-search').includes(q);
        const matchSt = station === 'ALL' || c.getAttribute('data-station') === station;
        const matchSv = status  === 'ALL' || c.getAttribute('data-status')  === status;
        c.style.display = (matchQ && matchSt && matchSv) ? '' : 'none';
      });
    }

    searchInput.addEventListener('input', filterCards);
    stationFilter.addEventListener('change', filterCards);
    statusFilter.addEventListener('change', filterCards);

    function openUpdateModal(bookingID, currentStatus) {
      document.getElementById('updateBookingID').value = bookingID;
      document.getElementById('updateModalInfo').textContent = 'Booking #' + bookingID + ' — current status: ' + currentStatus;
      const sel = document.getElementById('updateStatusSelect');
      for (let i = 0; i < sel.options.length; i++) {
        sel.options[i].selected = (sel.options[i].value === currentStatus);
      }
      document.getElementById('updateModal').classList.add('active');
    }

    function openDeleteModal(bookingID, userID) {
      document.getElementById('deleteBookingID').value = bookingID;
      document.getElementById('deleteModalInfo').innerHTML =
        'Are you sure you want to permanently delete booking <strong>#' + bookingID + '</strong> for user <strong>' + userID + '</strong>?';
      document.getElementById('deleteModal').classList.add('active');
    }

    function closeModals() {
      document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
    }
  </script>
</body>
</html>
