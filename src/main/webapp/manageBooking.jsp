<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>🎮 My Bookings – NexGen Esports</title>
  <%-- Build deadlineMap server-side (scriptlet required here — non-body, pre-rendering only) --%>
  <%
    java.util.List<my.nexgenesports.model.Booking> bks =
        (java.util.List<my.nexgenesports.model.Booking>) request.getAttribute("bookings");
    java.util.Map<Integer,Long> deadlineMap = new java.util.HashMap<>();
    if (bks != null) {
        for (my.nexgenesports.model.Booking bk : bks) {
            if ("PENDING".equals(bk.getPaymentStatus()) && bk.getPaymentDeadline() != null) {
                deadlineMap.put(bk.getBookingID(),
                    bk.getPaymentDeadline()
                      .atZone(java.time.ZoneId.systemDefault())
                      .toInstant().toEpochMilli());
            }
        }
    }
    request.setAttribute("deadlineMap", deadlineMap);
  %>
</head>
<body class="app-wrapper">
  <jsp:include page="header.jsp"/>

  <div class="main-container">
    <jsp:include page="sidebar.jsp"/>

    <main class="content">
      <div class="rigid-layout-container">

        <!-- HERO -->
        <div class="profile-hero">
          <div class="profile-hero-icon">🎮</div>
          <h2>My Bookings</h2>
          <p class="subtitle">Track, pay, and review your station reservations.</p>
        </div>

        <!-- ALERTS -->
        <c:if test="${not empty sessionScope.myBookingMsg}">
          <div class="success-msg" style="animation: modalSlideIn 0.4s ease-out;">✓ ${sessionScope.myBookingMsg}</div>
          <c:remove var="myBookingMsg" scope="session"/>
        </c:if>

        <div class="profile-panels-grid" style="grid-template-columns: 1fr;">

          <!-- FILTER PANEL -->
          <div class="profile-panel" style="padding: 18px 20px;">
            <div class="panel-header" style="margin-bottom: 14px; padding-bottom: 12px;">
              <div class="panel-title"><span class="panel-icon">🔍</span> Filter Bookings</div>
              <a href="${pageContext.request.contextPath}/selectStation"
                 class="btn-panel-edit"
                 style="flex-shrink:0; width:auto; text-decoration:none; background:rgba(0,229,255,0.12); border-color:rgba(0,229,255,0.4); color:var(--neon-cyan); font-size:0.78rem; padding:6px 16px;">+ Book a Station</a>
            </div>
            <div class="filter-bar">
              <div class="filter-bar-row">
                <div class="form-group">
                  <label>Search</label>
                  <input type="text" id="searchInput" class="profile-input" placeholder="Station ID or date...">
                </div>
                <div class="form-group">
                  <label>Status</label>
                  <select id="statusFilter" class="profile-input">
                    <option value="ALL">All Statuses</option>
                    <option value="Confirmed">Confirmed</option>
                    <option value="Cancelled">Cancelled</option>
                    <option value="Completed">Completed</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Payment</label>
                  <select id="paymentFilter" class="profile-input">
                    <option value="ALL">All Payments</option>
                    <option value="PAID">Paid</option>
                    <option value="PENDING">Pending</option>
                    <option value="FAILED">Failed</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- BOOKING CARDS PANEL -->
          <div class="profile-panel" style="padding: 18px 20px;">
            <div class="panel-header" style="margin-bottom: 0; padding-bottom: 12px;">
              <div class="panel-title"><span class="panel-icon">🗂</span> My Reservations</div>
              <span style="font-size:0.75rem; color:var(--text-muted); letter-spacing:1px;">Click a row to expand</span>
            </div>

            <div class="user-list" id="bookingList">
              <c:forEach var="b" items="${bookings}">
                <c:set var="statusCls" value=""/>
                <c:if test="${b.status == 'Cancelled'}"><c:set var="statusCls" value="is-disabled"/></c:if>

                <div class="user-card ${statusCls}"
                     data-search="${fn:toLowerCase(b.stationID)} ${b.date}"
                     data-status="${b.status}"
                     data-payment="${b.paymentStatus}">

                  <div class="user-card-summary" onclick="toggleCard(this.parentElement)">
                    <div class="user-avatar-sm" style="font-size:1rem; background:linear-gradient(135deg,rgba(0,229,255,0.2),rgba(176,38,255,0.2)); border-color:rgba(0,229,255,0.35);">🖥</div>
                    <div class="user-card-meta">
                      <div class="user-card-name">${b.stationID} &nbsp;·&nbsp; ${b.date}</div>
                      <div class="user-card-uid">#${b.bookingID} &nbsp;·&nbsp; ${b.startTime} – ${b.endTime}</div>
                    </div>
                    <div class="user-card-badges">
                      <%-- Payment badge (timer or static) --%>
                      <c:choose>
                        <c:when test="${b.paymentStatus == 'PENDING'}">
                          <span class="badge badge-warning timer-pill" id="pill-${b.bookingID}" data-deadline="${deadlineMap[b.bookingID]}">...</span>
                        </c:when>
                        <c:when test="${b.paymentStatus == 'PAID'}">
                          <span class="badge badge-success">PAID</span>
                        </c:when>
                        <c:when test="${b.paymentStatus == 'FAILED'}">
                          <span class="badge badge-danger">FAILED</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge" style="background:rgba(255,255,255,0.05);color:var(--text-muted);border:1px solid rgba(255,255,255,0.1);">${b.paymentStatus}</span>
                        </c:otherwise>
                      </c:choose>
                      <%-- Booking status --%>
                      <c:choose>
                        <c:when test="${b.status == 'Confirmed'}"><span class="badge badge-success">${b.status}</span></c:when>
                        <c:when test="${b.status == 'Cancelled'}"><span class="badge badge-danger">${b.status}</span></c:when>
                        <c:when test="${b.status == 'Completed'}"><span class="badge" style="background:rgba(0,229,255,0.1);color:var(--neon-cyan);border:1px solid rgba(0,229,255,0.4);">${b.status}</span></c:when>
                        <c:otherwise><span class="badge badge-warning">${b.status}</span></c:otherwise>
                      </c:choose>
                    </div>
                    <span class="user-card-chevron">▼</span>
                  </div>

                  <div class="user-card-details">
                    <div class="user-card-details-inner">
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
                        <span class="df-label">Hours</span>
                        <span class="df-value">${b.hourCount}h</span>
                      </div>
                    </div>
                    <c:if test="${b.paymentStatus == 'PENDING'}">
                      <div style="padding: 10px 16px; border-top: 1px solid rgba(255,221,0,0.1);">
                        <p style="font-size:0.8rem; color:var(--neon-yellow); margin:0 0 10px; font-weight:600;">
                          ⏱ Time remaining: <span id="timer-${b.bookingID}">...</span>
                        </p>
                        <p id="warn-${b.bookingID}" style="display:none; font-size:0.75rem; color:var(--neon-pink); margin:0 0 8px;">Payment blocked — less than 30 seconds remaining. Slot will be released shortly.</p>
                      </div>
                    </c:if>
                    <div class="user-card-actions">
                      <button type="button" class="btn-panel-edit" onclick="openDetailsModal('${b.bookingID}')">👁 View Details</button>
                      <c:if test="${b.paymentStatus == 'PENDING'}">
                        <button type="button" class="btn-panel-edit" id="pay-btn-${b.bookingID}"
                                style="border-color:rgba(0,255,136,0.5);color:var(--neon-green);"
                                onclick="goPay('${b.bookingID}')">💳 Pay Now</button>
                      </c:if>
                    </div>
                  </div>

                  <!-- Data template -->
                  <template id="bk-data-${b.bookingID}">
                    <span class="d-id"><c:out value="${b.bookingID}"/></span>
                    <span class="d-station"><c:out value="${b.stationID}"/></span>
                    <span class="d-date"><c:out value="${b.date}"/></span>
                    <span class="d-time"><c:out value="${b.startTime}"/> – <c:out value="${b.endTime}"/></span>
                    <span class="d-price"><c:out value="${b.price}"/></span>
                    <span class="d-payment"><c:out value="${b.paymentStatus}"/></span>
                    <span class="d-pillid">pill-${b.bookingID}</span>
                  </template>
                </div>
              </c:forEach>

              <c:if test="${empty bookings}">
                <div class="empty-state" style="border:none;background:transparent;">
                  <div class="empty-icon">🎮</div>
                  <div class="empty-message">You have no bookings yet.</div>
                  <a href="${pageContext.request.contextPath}/selectStation" class="btn-save" style="text-decoration:none;">Book a Station</a>
                </div>
              </c:if>
            </div><%-- /bookingList --%>
          </div>

        </div><%-- /.profile-panels-grid --%>
      </div><%-- /.rigid-layout-container --%>
    </main>
  </div>

  <jsp:include page="footer.jsp"/>

  <!-- ── BOOKING DETAILS MODAL ──────────────────────────────── -->
  <div id="detailsModal" class="modal-overlay">
    <div class="modal-content profile-panel" style="max-width:440px;padding:0;background:rgba(10,10,18,0.97);">
      <div class="panel-header" style="padding:20px 28px;margin:0;border-bottom:1px solid rgba(0,229,255,0.12);">
        <div class="panel-title"><span class="panel-icon">🎮</span> Booking Details</div>
        <button type="button" class="btn-close" onclick="closeModals()">×</button>
      </div>
      <div style="padding:22px 28px;display:grid;grid-template-columns:1fr 1fr;gap:14px 20px;">
        <div class="detail-field" style="grid-column:1/-1;">
          <span class="df-label">Booking ID</span>
          <span class="df-value" id="m-bid" style="font-size:1rem;color:var(--neon-cyan);"></span>
        </div>
        <div class="detail-field">
          <span class="df-label">Station</span>
          <span class="df-value" id="m-station"></span>
        </div>
        <div class="detail-field">
          <span class="df-label">Date &amp; Time</span>
          <span class="df-value" id="m-datetime"></span>
        </div>
        <div class="detail-field">
          <span class="df-label">Price</span>
          <span class="df-value" id="m-price"></span>
        </div>
        <div class="detail-field">
          <span class="df-label">Payment Status</span>
          <span class="df-value" id="m-payment"></span>
        </div>
      </div>
      <div id="m-pending-section" style="display:none; padding:0 28px 22px;">
        <div style="background:rgba(255,221,0,0.05);border:1px solid rgba(255,221,0,0.2);border-radius:10px;padding:14px;">
          <p style="color:var(--neon-yellow);font-weight:700;font-size:0.85rem;margin:0 0 8px;">⏱ Time Remaining: <span id="m-timer">–</span></p>
          <p id="m-pay-warning" style="display:none;color:var(--neon-pink);font-size:0.75rem;margin:0 0 10px;">Payment blocked — less than 30 seconds remaining.</p>
          <form action="${pageContext.request.contextPath}/checkout.jsp" method="get">
            <input type="hidden" name="bookingID" id="m-bid-input">
            <button type="submit" id="m-pay-btn" class="btn-save" style="width:100%;">💳 Pay Now</button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <script>
    // ── Accordion ────────────────────────────────────────────
    const cards         = Array.from(document.querySelectorAll('.user-card'));
    const searchInput   = document.getElementById('searchInput');
    const statusFilter  = document.getElementById('statusFilter');
    const paymentFilter = document.getElementById('paymentFilter');

    function toggleCard(card) {
      const isOpen = card.classList.contains('is-open');
      cards.forEach(c => c.classList.remove('is-open'));
      if (!isOpen) card.classList.add('is-open');
    }

    function filterCards() {
      const q  = searchInput.value.toLowerCase().trim();
      const st = statusFilter.value;
      const py = paymentFilter.value;
      cards.forEach(c => {
        const mQ  = c.getAttribute('data-search').includes(q);
        const mSt = st === 'ALL' || c.getAttribute('data-status')  === st;
        const mPy = py === 'ALL' || c.getAttribute('data-payment') === py;
        c.style.display = (mQ && mSt && mPy) ? '' : 'none';
      });
    }
    searchInput.addEventListener('input', filterCards);
    statusFilter.addEventListener('change', filterCards);
    paymentFilter.addEventListener('change', filterCards);

    // ── Countdown timers ─────────────────────────────────────
    var intervals = {};
    document.querySelectorAll('.timer-pill').forEach(function(pill) {
      var dl = parseInt(pill.getAttribute('data-deadline'), 10);
      if (isNaN(dl) || dl <= 0) return;
      var bid = pill.id.replace('pill-', '');

      function updatePill() {
        var remaining = dl - Date.now();
        if (remaining <= 0) {
          pill.textContent = 'EXPIRED';
          pill.style.color = 'var(--neon-pink)';
          clearInterval(intervals[pill.id]);
          var payBtn = document.getElementById('pay-btn-' + bid);
          if (payBtn) { payBtn.disabled = true; payBtn.style.opacity = '0.4'; }
          return;
        }
        var s = Math.floor((remaining / 1000) % 60);
        var m = Math.floor(remaining / 60000);
        pill.textContent = m + 'm ' + s + 's';
        pill.setAttribute('data-remaining', remaining);
        var timerEl = document.getElementById('timer-' + bid);
        if (timerEl) timerEl.textContent = m + 'm ' + s + 's';
        var warnEl = document.getElementById('warn-' + bid);
        var payBtn = document.getElementById('pay-btn-' + bid);
        if (remaining < 30000) {
          if (warnEl) warnEl.style.display = 'block';
          if (payBtn) { payBtn.disabled = true; payBtn.style.opacity = '0.4'; }
        }
      }
      updatePill();
      intervals[pill.id] = setInterval(updatePill, 1000);
    });

    // ── Modal helpers ────────────────────────────────────────
    var activePillId = null;
    var modalInterval = null;

    function getTplVal(bid, cls) {
      var tpl = document.getElementById('bk-data-' + bid);
      if (!tpl) return '';
      var el = tpl.content.querySelector(cls);
      return el ? el.textContent.trim() : '';
    }

    function openDetailsModal(bid) {
      document.getElementById('m-bid').textContent      = getTplVal(bid, '.d-id');
      document.getElementById('m-station').textContent  = getTplVal(bid, '.d-station');
      document.getElementById('m-datetime').textContent = getTplVal(bid, '.d-date') + ' ' + getTplVal(bid, '.d-time');
      document.getElementById('m-price').textContent    = 'RM ' + getTplVal(bid, '.d-price');
      document.getElementById('m-payment').textContent  = getTplVal(bid, '.d-payment');

      var payment = getTplVal(bid, '.d-payment');
      var pendingSec = document.getElementById('m-pending-section');
      if (payment === 'PENDING') {
        pendingSec.style.display = 'block';
        document.getElementById('m-bid-input').value = bid;
        activePillId = 'pill-' + bid;
        if (modalInterval) clearInterval(modalInterval);
        modalInterval = setInterval(function() {
          var pill = document.getElementById(activePillId);
          if (!pill) return;
          var remaining = parseInt(pill.getAttribute('data-remaining'), 10);
          document.getElementById('m-timer').textContent = pill.textContent;
          var pbtn = document.getElementById('m-pay-btn');
          var warn = document.getElementById('m-pay-warning');
          if (remaining < 30000) {
            pbtn.disabled = true; pbtn.style.opacity = '0.5';
            warn.style.display = 'block';
          } else {
            pbtn.disabled = false; pbtn.style.opacity = '1';
            warn.style.display = 'none';
          }
        }, 500);
      } else {
        pendingSec.style.display = 'none';
      }
      document.getElementById('detailsModal').classList.add('active');
    }

    function goPay(bid) {
      var pill = document.getElementById('pill-' + bid);
      if (pill) {
        var remaining = parseInt(pill.getAttribute('data-remaining'), 10);
        if (remaining < 30000) { alert('Payment blocked — less than 30 seconds remaining.'); return; }
      }
      window.location.href = '${pageContext.request.contextPath}/checkout.jsp?bookingID=' + bid;
    }

    function closeModals() {
      document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
      if (modalInterval) { clearInterval(modalInterval); modalInterval = null; }
    }
  </script>
</body>
</html>
