<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Membership Manager – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <style>
    *, *::before, *::after { box-sizing: border-box; }

    /* ── PAGE LAYOUT ── */
    .amm-wrapper { width: 100%; max-width: 100%; padding: 0; }

    /* ── TAB NAV ── */
    .amm-tabs { display: flex; align-items: center; gap: 0; border-bottom: 1px solid var(--glass-border); margin-bottom: 28px; flex-wrap: wrap; }
    .amm-tab-btn { background: none; border: none; color: var(--text-muted); font-family: var(--font-heading); font-size: 1rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; padding: 14px 28px; cursor: pointer; border-bottom: 2px solid transparent; transition: var(--transition); white-space: nowrap; }
    .amm-tab-btn.active { color: var(--neon-cyan); border-bottom-color: var(--neon-cyan); text-shadow: 0 0 8px var(--neon-cyan-glow); }
    .amm-tab-btn:hover:not(.active) { color: var(--text-primary); }

    /* ── PANEL ── */
    .amm-panel { display: none; }
    .amm-panel.active { display: block; }

    /* ── SECTION HEADER ── */
    .amm-section-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; flex-wrap: wrap; gap: 10px; }
    .amm-section-title { font-family: var(--font-heading); font-weight: 700; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1px; color: var(--neon-cyan); margin: 0; }
    .amm-section-title.pink { color: var(--neon-pink); }

    /* ── SESSION LIST ── */
    .session-list { display: flex; flex-direction: column; gap: 10px; }
    .session-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; background: rgba(0,0,0,0.35); border: 1px solid var(--glass-border); border-radius: 10px; padding: 12px 16px; flex-wrap: wrap; transition: var(--transition); }
    .session-row:hover { border-color: rgba(0,229,255,0.25); background: rgba(0,229,255,0.04); }
    .session-row-info { flex: 1; min-width: 160px; }
    .session-row-name { font-family: var(--font-heading); font-weight: 700; font-size: 1rem; color: var(--text-primary); }
    .session-row-meta { font-size: 0.78rem; color: var(--text-muted); margin-top: 2px; }
    .session-row-actions { display: flex; gap: 8px; flex-shrink: 0; }

    /* ── BUTTONS ── */
    .btn { display: inline-flex; align-items: center; gap: 6px; border: none; border-radius: 6px; font-family: var(--font-main); font-weight: 600; font-size: 0.83rem; cursor: pointer; padding: 7px 14px; transition: var(--transition); white-space: nowrap; }
    .btn-cyan { background: linear-gradient(135deg, var(--neon-cyan), #0077ff); color: #000; box-shadow: 0 0 10px var(--neon-cyan-glow); }
    .btn-cyan:hover { transform: translateY(-2px); box-shadow: 0 0 20px var(--neon-cyan); }
    .btn-outline { background: transparent; border: 1px solid rgba(0,229,255,0.4); color: var(--neon-cyan); }
    .btn-outline:hover { background: rgba(0,229,255,0.1); border-color: var(--neon-cyan); }
    .btn-danger { background: transparent; border: 1px solid var(--neon-pink); color: var(--neon-pink); }
    .btn-danger:hover { background: rgba(255,0,127,0.12); box-shadow: 0 0 10px rgba(255,0,127,0.3); }
    .btn-sm { padding: 5px 10px; font-size: 0.78rem; }
    .btn-icon { padding: 5px 8px; }

    /* ── BADGE ── */
    .badge { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; }
    .badge-active { color: var(--neon-green); border: 1px solid var(--neon-green); background: rgba(0,255,136,0.08); }
    .badge-inactive { color: var(--text-muted); border: 1px solid var(--glass-border); background: rgba(255,255,255,0.04); }
    .badge-status-active { color: var(--neon-green); border: 1px solid var(--neon-green); background: rgba(0,255,136,0.08); }
    .badge-status-expired { color: var(--neon-pink); border: 1px solid var(--neon-pink); background: rgba(255,0,127,0.08); }
    .badge-status-pending { color: var(--neon-yellow); border: 1px solid var(--neon-yellow); background: rgba(255,221,0,0.08); }

    /* ── MODAL ── */
    .amm-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.75); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); z-index: 9000; align-items: center; justify-content: center; padding: 16px; }
    .amm-modal-overlay.open { display: flex; }
    .amm-modal { background: rgba(12,12,16,0.95); border: 1px solid var(--glass-border); border-radius: 16px; padding: 28px; width: 100%; max-width: 600px; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.8), 0 0 0 1px rgba(0,229,255,0.08); position: relative; }
    .amm-modal-title { font-family: var(--font-heading); font-weight: 700; font-size: 1.3rem; color: var(--neon-cyan); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid var(--glass-border); }
    .amm-modal-close { position: absolute; top: 18px; right: 18px; background: none; border: none; color: var(--text-muted); font-size: 1.3rem; cursor: pointer; line-height: 1; padding: 4px; transition: var(--transition); }
    .amm-modal-close:hover { color: var(--neon-pink); }

    /* ── FORM ELEMENTS ── */
    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .form-grid.single { grid-template-columns: 1fr; }
    @media (max-width: 520px) { .form-grid { grid-template-columns: 1fr; } }
    .form-group { display: flex; flex-direction: column; gap: 5px; }
    .form-group.span2 { grid-column: span 2; }
    @media (max-width: 520px) { .form-group.span2 { grid-column: span 1; } }
    .form-label { font-size: 0.78rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
    .form-control { background: rgba(0,0,0,0.5); color: var(--text-primary); border: 1px solid rgba(0,229,255,0.2); border-radius: 6px; padding: 9px 12px; font-family: var(--font-main); font-size: 0.9rem; width: 100%; transition: var(--transition); }
    .form-control:focus { border-color: var(--neon-cyan); box-shadow: 0 0 0 2px var(--neon-cyan-glow); outline: none; }
    input[type="date"].form-control, input[type="datetime-local"].form-control { color-scheme: dark; }
    .form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; flex-wrap: wrap; }

    /* ── BENEFITS IN MODAL ── */
    .benefit-list-modal { display: flex; flex-direction: column; gap: 6px; margin-bottom: 12px; max-height: 220px; overflow-y: auto; padding-right: 4px; }
    .benefit-item-modal { display: flex; align-items: center; gap: 8px; background: rgba(0,0,0,0.3); border: 1px solid var(--glass-border); border-radius: 6px; padding: 7px 10px; }
    .benefit-item-modal span { flex: 1; font-size: 0.85rem; color: var(--text-primary); }
    .benefit-add-row { display: flex; gap: 8px; margin-top: 8px; }
    .benefit-add-row .form-control { flex: 1; }

    /* ── DIVIDER ── */
    .amm-divider { border: none; border-top: 1px dashed var(--glass-border); margin: 28px 0; }

    /* ── USER TABLE ── */
    .amm-table-wrap { overflow-x: auto; border-radius: 10px; background: var(--glass-bg); border: 1px solid var(--glass-border); }
    .amm-table { width: 100%; border-collapse: collapse; font-family: var(--font-main); font-size: 0.85rem; color: var(--text-primary); min-width: 600px; }
    .amm-table th { padding: 10px 14px; background: rgba(255,255,255,0.04); color: var(--text-muted); font-weight: 600; text-transform: uppercase; font-size: 0.72rem; letter-spacing: 0.8px; text-align: left; border-bottom: 1px solid var(--glass-border); white-space: nowrap; }
    .amm-table td { padding: 9px 14px; border-bottom: 1px solid rgba(255,255,255,0.04); vertical-align: middle; }
    .amm-table tr:last-child td { border-bottom: none; }
    .amm-table tr:hover td { background: rgba(255,255,255,0.03); }
    .amm-table .action-cell { display: flex; gap: 6px; }

    /* ── GRANT FORM ── */
    .grant-form { background: rgba(0,0,0,0.25); border: 1px solid var(--glass-border); border-radius: 10px; padding: 16px; margin-top: 16px; }
    .grant-form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 10px; align-items: end; }
    .grant-form-grid .btn { height: 38px; }

    /* ── GAMING PASS CARDS ── */
    .pass-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 18px; }
    .pass-card { background: rgba(12,12,16,0.7); border: 1px solid var(--glass-border); border-radius: 14px; padding: 20px; transition: var(--transition); }
    .pass-card:hover { border-color: rgba(0,229,255,0.2); }
    .pass-card-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; margin-bottom: 14px; }
    .pass-card-title { font-family: var(--font-heading); font-weight: 700; font-size: 1.3rem; color: var(--text-primary); }
    .pass-card-price { font-family: var(--font-heading); font-weight: 700; font-size: 1.1rem; color: var(--neon-cyan); }
    .pass-card-actions { display: flex; gap: 6px; flex-shrink: 0; }

    /* pass edit mode */
    .pass-card .pass-view { }
    .pass-card .pass-edit-form { display: none; }
    .pass-card.editing .pass-view { display: none; }
    .pass-card.editing .pass-edit-form { display: block; }

    /* ── BENEFIT ROWS IN PASS CARD ── */
    .pass-benefit-list { display: flex; flex-direction: column; gap: 6px; margin: 14px 0; }
    .pass-benefit-row { display: flex; align-items: center; gap: 8px; padding: 7px 10px; border-radius: 6px; background: rgba(255,255,255,0.03); border: 1px solid var(--glass-border); font-size: 0.83rem; }
    .pass-benefit-row .benefit-avail { flex-shrink: 0; font-size: 1rem; cursor: pointer; padding: 0 4px; }
    .benefit-avail.yes { color: var(--neon-green); }
    .benefit-avail.no { color: var(--neon-pink); }
    .pass-benefit-row .benefit-name { font-weight: 600; color: var(--text-primary); flex: 1; }
    .pass-benefit-row .benefit-val { color: var(--text-muted); font-size: 0.78rem; }
    .pass-benefit-row .drop-benefit-btn { margin-left: auto; flex-shrink: 0; }
    .add-benefit-section { border-top: 1px solid var(--glass-border); padding-top: 12px; margin-top: 6px; }
    .add-benefit-row { display: flex; gap: 8px; flex-wrap: wrap; }
    .add-benefit-row .form-control { flex: 1; min-width: 100px; }

    /* ── ADD TIER CARD ── */
    .pass-card-new { border-style: dashed; border-color: rgba(0,229,255,0.3); background: rgba(0,229,255,0.02); display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 14px; min-height: 200px; cursor: pointer; }
    .pass-card-new:hover { border-color: var(--neon-cyan); background: rgba(0,229,255,0.06); }
    .pass-card-new-icon { font-size: 2rem; color: var(--neon-cyan); opacity: 0.6; }
    .pass-card-new-label { font-family: var(--font-heading); font-weight: 700; font-size: 1rem; color: var(--neon-cyan); text-transform: uppercase; letter-spacing: 1px; }
    .pass-card-new-form { display: none; width: 100%; }
    .pass-card-new.open { cursor: default; }
    .pass-card-new.open .pass-card-new-icon, .pass-card-new.open .pass-card-new-label { display: none; }
    .pass-card-new.open .pass-card-new-form { display: block; }

    /* ── EMPTY STATE ── */
    .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); }
    .empty-state-icon { font-size: 2.5rem; margin-bottom: 10px; opacity: 0.5; }
    .empty-state-text { font-size: 0.9rem; }

    /* ── TOAST ── */
    #amm-toast { position: fixed; top: 20px; right: 20px; z-index: 9999; display: flex; flex-direction: column; gap: 8px; pointer-events: none; }
    .toast-item { background: rgba(12,12,16,0.95); border-radius: 8px; padding: 12px 18px; font-size: 0.85rem; border-left: 3px solid var(--neon-green); color: var(--text-primary); box-shadow: 0 4px 20px rgba(0,0,0,0.6); animation: toastIn 0.3s ease; min-width: 240px; max-width: 320px; pointer-events: auto; }
    .toast-item.error { border-left-color: var(--neon-pink); }
    @keyframes toastIn { from { opacity: 0; transform: translateX(30px); } to { opacity: 1; transform: translateX(0); } }

    /* ── RESPONSIVE OVERRIDES ── */
    @media (max-width: 768px) {
      .amm-tab-btn { padding: 10px 16px; font-size: 0.85rem; }
      .pass-grid { grid-template-columns: 1fr; }
      .form-grid { grid-template-columns: 1fr; }
      .form-group.span2 { grid-column: span 1; }
      .grant-form-grid { grid-template-columns: 1fr; }
      .amm-table { min-width: 500px; }
    }
    @media (max-width: 480px) {
      .session-row { flex-direction: column; align-items: flex-start; }
      .session-row-actions { width: 100%; }
      .session-row-actions .btn { flex: 1; justify-content: center; }
    }
  </style>
</head>
<body class="app-wrapper">

  <div id="amm-toast"></div>

  <jsp:include page="/header.jsp"/>
  <div class="main-container">
    <jsp:include page="/sidebar.jsp"/>
    <main class="content">
      <div class="module-header">
        <h2 style="font-family:var(--font-heading);font-weight:700;text-transform:uppercase;text-shadow:0 0 10px rgba(255,255,255,0.2);">Admin Membership &amp; Pass Manager</h2>
      </div>

      <div class="glass-card amm-wrapper">

        <%-- ── FLASH MESSAGES ── --%>
        <c:if test="${not empty sessionScope.successMsg}">
          <script>window.__flashSuccess = '<c:out value="${sessionScope.successMsg}"/>';</script>
          <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
          <script>window.__flashError = '<c:out value="${sessionScope.errorMsg}"/>';</script>
          <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <%-- ── TABS ── --%>
        <div class="amm-tabs">
          <button class="amm-tab-btn active" data-target="panel-club">Club Membership</button>
          <button class="amm-tab-btn" data-target="panel-pass">Gaming Pass</button>
        </div>

        <%-- ══════════════════════════════════════════════════════ --%>
        <%-- PANEL: CLUB MEMBERSHIP                                 --%>
        <%-- ══════════════════════════════════════════════════════ --%>
        <div id="panel-club" class="amm-panel active">

          <div class="amm-section-header">
            <span class="amm-section-title">Membership Sessions</span>
            <button class="btn btn-cyan btn-sm" id="btn-open-create-session">+ New Session</button>
          </div>

          <div class="session-list">
            <c:forEach var="sess" items="${sessions}">
              <div class="session-row">
                <div class="session-row-info">
                  <div class="session-row-name">${sess.sessionName}</div>
                  <div class="session-row-meta">
                    ID: ${sess.sessionId} &nbsp;·&nbsp;
                    <fmt:formatNumber value="${sess.fee}" minFractionDigits="2"/> RM &nbsp;·&nbsp;
                    ${fn:substring(sess.startMembershipDate,0,10)} → ${fn:substring(sess.endMembershipDate,0,10)}
                    &nbsp;·&nbsp;
                    <c:choose>
                      <c:when test="${sess.active}"><span class="badge badge-active">Active</span></c:when>
                      <c:otherwise><span class="badge badge-inactive">Inactive</span></c:otherwise>
                    </c:choose>
                    &nbsp;·&nbsp; <small>${fn:length(sessionBenefitsMap[sess.sessionId])} benefits</small>
                  </div>
                </div>
                <div class="session-row-actions">
                  <button class="btn btn-outline btn-sm btn-edit-session"
                    data-id="${sess.sessionId}"
                    data-name="${sess.sessionName}"
                    data-fee="${sess.fee}"
                    data-start="${fn:substring(sess.startMembershipDate,0,10)}"
                    data-end="${fn:substring(sess.endMembershipDate,0,10)}"
                    data-active="${sess.active}">Edit</button>
                  <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;" onsubmit="return confirm('Delete session ${sess.sessionId}?')">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="action" value="delete_session"/>
                    <input type="hidden" name="sessionId" value="${sess.sessionId}"/>
                    <button type="submit" class="btn btn-danger btn-sm">Del</button>
                  </form>
                </div>
              </div>
            </c:forEach>
            <c:if test="${empty sessions}">
              <div class="empty-state"><div class="empty-state-icon">🗂️</div><div class="empty-state-text">No sessions yet.</div></div>
            </c:if>
          </div>

          <hr class="amm-divider">

          <%-- ── USER MEMBERSHIPS ── --%>
          <div class="amm-section-header">
            <span class="amm-section-title pink">User Memberships</span>
          </div>
          <div class="amm-table-wrap">
            <table class="amm-table">
              <thead><tr>
                <th>ID</th><th>User</th><th>Session</th><th>Expiry</th><th>Status</th><th>Actions</th>
              </tr></thead>
              <tbody>
                <c:forEach var="um" items="${userMemberships}">
                  <tr>
                    <td>${um.id}</td>
                    <td>${um.userId}</td>
                    <td>${um.session.sessionId}</td>
                    <td>${fn:substring(um.expiryDate,0,10)}</td>
                    <td>
                      <c:choose>
                        <c:when test="${um.status == 'ACTIVE'}"><span class="badge badge-status-active">Active</span></c:when>
                        <c:when test="${um.status == 'EXPIRED'}"><span class="badge badge-status-expired">Expired</span></c:when>
                        <c:otherwise><span class="badge badge-status-pending">${um.status}</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="action-cell">
                        <button class="btn btn-outline btn-sm btn-edit-um"
                          data-id="${um.id}"
                          data-userid="${um.userId}"
                          data-sessionid="${um.session.sessionId}"
                          data-purchase="${fn:replace(um.purchaseDate,' ','T')}"
                          data-expiry="${fn:replace(um.expiryDate,' ','T')}"
                          data-status="${um.status}"
                          data-ref="${um.paymentReference}">Edit</button>
                        <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;" onsubmit="return confirm('Delete?')">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                          <input type="hidden" name="action" value="delete_user_membership"/>
                          <input type="hidden" name="id" value="${um.id}"/>
                          <button type="submit" class="btn btn-danger btn-sm">Del</button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty userMemberships}">
                  <tr><td colspan="6"><div class="empty-state"><div class="empty-state-icon">🛡️</div><div class="empty-state-text">No user memberships found.</div></div></td></tr>
                </c:if>
              </tbody>
            </table>
          </div>

          <%-- Grant UM --%>
          <div class="grant-form">
            <div style="font-family:var(--font-heading);font-weight:700;font-size:0.9rem;color:var(--neon-cyan);margin-bottom:12px;text-transform:uppercase;">Grant Membership</div>
            <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <input type="hidden" name="action" value="add_user_membership"/>
              <div class="grant-form-grid">
                <div class="form-group">
                  <label class="form-label">User ID</label>
                  <input type="text" name="userId" class="form-control" required placeholder="e.g. husinyusoff"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Session</label>
                  <select name="sessionId" class="form-control" required>
                    <c:forEach var="s" items="${sessions}"><option value="${s.sessionId}">${s.sessionName}</option></c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-label">Expiry Date</label>
                  <input type="date" name="expiryDate" class="form-control" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">Payment Ref (optional)</label>
                  <input type="text" name="paymentReference" class="form-control" placeholder="REF-001"/>
                </div>
                <div class="form-group">
                  <label class="form-label">&nbsp;</label>
                  <button type="submit" class="btn btn-cyan" style="height:38px;">Grant</button>
                </div>
              </div>
            </form>
          </div>

        </div><%-- /panel-club --%>

        <%-- ══════════════════════════════════════════════════════ --%>
        <%-- PANEL: GAMING PASS                                      --%>
        <%-- ══════════════════════════════════════════════════════ --%>
        <div id="panel-pass" class="amm-panel">

          <div class="amm-section-header">
            <span class="amm-section-title">Gaming Pass Tiers</span>
          </div>

          <div class="pass-grid">
            <c:forEach var="tier" items="${passTiers}">
              <div class="pass-card" id="pass-card-${tier.tierId}">

                <%-- VIEW MODE --%>
                <div class="pass-view">
                  <div class="pass-card-header">
                    <div>
                      <div class="pass-card-title">${tier.tierName}</div>
                      <div class="pass-card-price">RM <fmt:formatNumber value="${tier.price}" minFractionDigits="2"/></div>
                    </div>
                    <div class="pass-card-actions">
                      <button class="btn btn-outline btn-sm btn-edit-pass"
                        data-id="${tier.tierId}"
                        data-name="${tier.tierName}"
                        data-price="${tier.price}">Edit</button>
                      <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;" onsubmit="return confirm('Delete tier ${tier.tierName}?')">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        <input type="hidden" name="action" value="delete_tier"/>
                        <input type="hidden" name="tierId" value="${tier.tierId}"/>
                        <button type="submit" class="btn btn-danger btn-sm">Del</button>
                      </form>
                    </div>
                  </div>
                  <div class="pass-benefit-list">
                    <c:forEach var="benefit" items="${passBenefitsMap[tier.tierId]}">
                      <div class="pass-benefit-row">
                        <span class="benefit-name">${benefit.benefitName}</span>
                        <span class="benefit-val">${benefit.benefitText}</span>
                        <%-- avail toggle: treat non-"X"/"x"/"No"/"no" as available --%>
                        <c:set var="bval" value="${fn:toLowerCase(benefit.benefitText)}"/>
                        <c:choose>
                          <c:when test="${bval == 'x' || bval == 'no' || bval == 'false'}">
                            <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;">
                              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                              <input type="hidden" name="action" value="toggle_pass_benefit_avail"/>
                              <input type="hidden" name="id" value="${benefit.id}"/>
                              <input type="hidden" name="newVal" value="✓"/>
                              <button type="submit" class="benefit-avail no" title="Mark as available">✗</button>
                            </form>
                          </c:when>
                          <c:otherwise>
                            <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;">
                              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                              <input type="hidden" name="action" value="toggle_pass_benefit_avail"/>
                              <input type="hidden" name="id" value="${benefit.id}"/>
                              <input type="hidden" name="newVal" value="X"/>
                              <button type="submit" class="benefit-avail yes" title="Mark as unavailable">✓</button>
                            </form>
                          </c:otherwise>
                        </c:choose>
                        <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;" onsubmit="return confirm('Drop benefit?')">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                          <input type="hidden" name="action" value="delete_pass_benefit"/>
                          <input type="hidden" name="id" value="${benefit.id}"/>
                          <button type="submit" class="btn btn-danger btn-icon btn-sm drop-benefit-btn">×</button>
                        </form>
                      </div>
                    </c:forEach>
                    <c:if test="${empty passBenefitsMap[tier.tierId]}">
                      <div style="color:var(--text-muted);font-size:0.82rem;text-align:center;padding:10px 0;">No benefits yet.</div>
                    </c:if>
                  </div>
                  <%-- Add benefit inline --%>
                  <div class="add-benefit-section">
                    <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
                      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                      <input type="hidden" name="action" value="add_pass_benefit"/>
                      <input type="hidden" name="tierId" value="${tier.tierId}"/>
                      <div class="add-benefit-row">
                        <input type="text" name="benefitName" placeholder="Benefit name" class="form-control" required style="font-size:0.8rem;padding:6px 10px;"/>
                        <input type="text" name="benefitText" placeholder="Value" class="form-control" required style="font-size:0.8rem;padding:6px 10px;max-width:90px;"/>
                        <button type="submit" class="btn btn-outline btn-sm">+</button>
                      </div>
                    </form>
                  </div>
                </div>

                <%-- EDIT MODE (shown as inline edit, not popup, per user preference) --%>
                <div class="pass-edit-form">
                  <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                    <input type="hidden" name="action" value="update_tier"/>
                    <input type="hidden" name="tierId" value="${tier.tierId}"/>
                    <div class="form-group" style="margin-bottom:10px;">
                      <label class="form-label">Tier Name</label>
                      <input type="text" name="tierName" value="${tier.tierName}" class="form-control" required/>
                    </div>
                    <div class="form-group" style="margin-bottom:14px;">
                      <label class="form-label">Price (RM)</label>
                      <input type="number" step="0.01" name="price" value="${tier.price}" class="form-control" required/>
                    </div>
                    <div style="display:flex;gap:8px;">
                      <button type="submit" class="btn btn-cyan btn-sm" style="flex:1;">Save</button>
                      <button type="button" class="btn btn-outline btn-sm btn-cancel-pass-edit" data-id="${tier.tierId}" style="flex:1;">Cancel</button>
                    </div>
                  </form>
                </div>

              </div>
            </c:forEach>

            <%-- ADD NEW TIER CARD --%>
            <div class="pass-card pass-card-new" id="pass-card-new" onclick="openNewTier()">
              <div class="pass-card-new-icon">＋</div>
              <div class="pass-card-new-label">New Tier</div>
              <div class="pass-card-new-form">
                <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                  <input type="hidden" name="action" value="add_tier"/>
                  <div class="form-group" style="margin-bottom:10px;">
                    <label class="form-label">Tier Name</label>
                    <input type="text" name="tierName" placeholder="e.g. Premium" class="form-control" required/>
                  </div>
                  <div class="form-group" style="margin-bottom:14px;">
                    <label class="form-label">Price (RM)</label>
                    <input type="number" step="0.01" name="price" placeholder="0.00" class="form-control" required/>
                  </div>
                  <div style="display:flex;gap:8px;">
                    <button type="submit" class="btn btn-cyan btn-sm" style="flex:1;">Create</button>
                    <button type="button" class="btn btn-outline btn-sm" onclick="event.stopPropagation();closeNewTier()" style="flex:1;">Cancel</button>
                  </div>
                </form>
              </div>
            </div>
          </div>

          <hr class="amm-divider">

          <%-- USER PASSES TABLE --%>
          <div class="amm-section-header">
            <span class="amm-section-title pink">User Gaming Passes</span>
          </div>
          <div class="amm-table-wrap">
            <table class="amm-table">
              <thead><tr>
                <th>ID</th><th>User</th><th>Tier</th><th>Expiry</th><th>Status</th><th>Actions</th>
              </tr></thead>
              <tbody>
                <c:forEach var="up" items="${userPasses}">
                  <tr>
                    <td>${up.id}</td>
                    <td>${up.userId}</td>
                    <td>${up.tier.tierName}</td>
                    <td>${fn:substring(up.expiryDate,0,10)}</td>
                    <td>
                      <c:choose>
                        <c:when test="${up.status == 'ACTIVE'}"><span class="badge badge-status-active">Active</span></c:when>
                        <c:when test="${up.status == 'EXPIRED'}"><span class="badge badge-status-expired">Expired</span></c:when>
                        <c:otherwise><span class="badge badge-status-pending">${up.status}</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="action-cell">
                        <button class="btn btn-outline btn-sm btn-edit-up"
                          data-id="${up.id}"
                          data-userid="${up.userId}"
                          data-tierid="${up.tier.tierId}"
                          data-purchase="${fn:replace(up.purchaseDate,' ','T')}"
                          data-expiry="${fn:replace(up.expiryDate,' ','T')}"
                          data-status="${up.status}"
                          data-ref="${up.paymentReference}">Edit</button>
                        <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;" onsubmit="return confirm('Delete?')">
                          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                          <input type="hidden" name="action" value="delete_user_pass"/>
                          <input type="hidden" name="id" value="${up.id}"/>
                          <button type="submit" class="btn btn-danger btn-sm">Del</button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty userPasses}">
                  <tr><td colspan="6"><div class="empty-state"><div class="empty-state-icon">🎮</div><div class="empty-state-text">No user gaming passes found.</div></div></td></tr>
                </c:if>
              </tbody>
            </table>
          </div>

          <%-- Grant PASS --%>
          <div class="grant-form">
            <div style="font-family:var(--font-heading);font-weight:700;font-size:0.9rem;color:var(--neon-cyan);margin-bottom:12px;text-transform:uppercase;">Grant Gaming Pass</div>
            <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <input type="hidden" name="action" value="add_user_pass"/>
              <div class="grant-form-grid">
                <div class="form-group">
                  <label class="form-label">User ID</label>
                  <input type="text" name="userId" class="form-control" required placeholder="e.g. husinyusoff"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Tier</label>
                  <select name="tierId" class="form-control" required>
                    <c:forEach var="t" items="${passTiers}"><option value="${t.tierId}">${t.tierName}</option></c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-label">Expiry Date</label>
                  <input type="date" name="expiryDate" class="form-control" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">Payment Ref (optional)</label>
                  <input type="text" name="paymentReference" class="form-control" placeholder="REF-001"/>
                </div>
                <div class="form-group">
                  <label class="form-label">&nbsp;</label>
                  <button type="submit" class="btn btn-cyan" style="height:38px;">Grant</button>
                </div>
              </div>
            </form>
          </div>

        </div><%-- /panel-pass --%>

      </div><%-- /glass-card --%>
    </main>
  </div>

  <%-- ══════════════════════════════════════ --%>
  <%-- MODAL: EDIT SESSION                    --%>
  <%-- ══════════════════════════════════════ --%>
  <div class="amm-modal-overlay" id="modal-session">
    <div class="amm-modal" style="max-width:640px;">
      <div class="amm-modal-title" id="modal-session-title">Edit Session</div>
      <button class="amm-modal-close" onclick="closeModal('modal-session')">✕</button>
      <form action="${pageContext.request.contextPath}/admin/memberships" method="post" id="form-session">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="action" id="session-action" value="update_session"/>
        <input type="hidden" name="sessionId" id="session-id-hidden"/>
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Session ID</label>
            <input type="text" name="sessionId" id="session-id-field" class="form-control" required placeholder="e.g. 2026_1"/>
          </div>
          <div class="form-group">
            <label class="form-label">Session Name</label>
            <input type="text" name="sessionName" id="session-name" class="form-control" required/>
          </div>
          <div class="form-group">
            <label class="form-label">Start Date</label>
            <input type="date" name="startDate" id="session-start" class="form-control" required/>
          </div>
          <div class="form-group">
            <label class="form-label">End Date</label>
            <input type="date" name="endDate" id="session-end" class="form-control" required/>
          </div>
          <div class="form-group">
            <label class="form-label">Fee (RM)</label>
            <input type="number" step="0.01" name="fee" id="session-fee" class="form-control" required/>
          </div>
          <div class="form-group">
            <label class="form-label">Is Active</label>
            <select name="isActive" id="session-active" class="form-control">
              <option value="true">Yes</option>
              <option value="false">No</option>
            </select>
          </div>
        </div>
        <div class="form-actions" style="margin-top:20px;">
          <button type="button" class="btn btn-outline" onclick="closeModal('modal-session')">Cancel</button>
          <button type="submit" class="btn btn-cyan">Save Session</button>
        </div>
      </form>

      <%-- Benefits section (edit only) --%>
      <div id="session-benefits-section" style="margin-top:20px; display:none; border-top:1px solid var(--glass-border); padding-top:20px;">
        <div style="font-family:var(--font-heading);font-weight:700;font-size:0.85rem;color:var(--text-muted);text-transform:uppercase;margin-bottom:10px;">Benefits</div>
        <div class="benefit-list-modal" id="modal-benefit-list">
          <c:forEach var="sess" items="${sessions}">
            <c:forEach var="b" items="${sessionBenefitsMap[sess.sessionId]}">
              <div class="benefit-item-modal" data-session="${sess.sessionId}">
                <span>${b.benefitText}</span>
                <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:inline;" onsubmit="return confirm('Drop?')">
                  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                  <input type="hidden" name="action" value="delete_club_benefit"/>
                  <input type="hidden" name="id" value="${b.id}"/>
                  <button type="submit" class="btn btn-danger btn-icon btn-sm">×</button>
                </form>
              </div>
            </c:forEach>
          </c:forEach>
        </div>
        <div class="benefit-add-row">
          <form action="${pageContext.request.contextPath}/admin/memberships" method="post" style="display:flex;gap:8px;width:100%;" id="form-add-benefit">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
            <input type="hidden" name="action" value="add_club_benefit"/>
            <input type="hidden" name="sessionId" id="benefit-session-id"/>
            <input type="text" name="benefitText" placeholder="New benefit..." class="form-control" required/>
            <button type="submit" class="btn btn-outline btn-sm" style="white-space:nowrap;">+ Add</button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <%-- ══════════════════════════════════════ --%>
  <%-- MODAL: EDIT USER MEMBERSHIP            --%>
  <%-- ══════════════════════════════════════ --%>
  <div class="amm-modal-overlay" id="modal-um">
    <div class="amm-modal" style="max-width:520px;">
      <div class="amm-modal-title">Edit User Membership</div>
      <button class="amm-modal-close" onclick="closeModal('modal-um')">✕</button>
      <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="action" value="update_user_membership"/>
        <input type="hidden" name="id" id="um-id"/>
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">User ID</label>
            <input type="text" id="um-userid" class="form-control" disabled style="opacity:0.6;"/>
          </div>
          <div class="form-group">
            <label class="form-label">Status</label>
            <select name="status" id="um-status" class="form-control">
              <option value="ACTIVE">ACTIVE</option>
              <option value="EXPIRED">EXPIRED</option>
              <option value="PENDING">PENDING</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Purchase Date</label>
            <input type="datetime-local" name="purchaseDate" id="um-purchase" class="form-control"/>
          </div>
          <div class="form-group">
            <label class="form-label">Expiry Date</label>
            <input type="datetime-local" name="expiryDate" id="um-expiry" class="form-control"/>
          </div>
          <div class="form-group span2">
            <label class="form-label">Payment Reference</label>
            <input type="text" name="paymentReference" id="um-ref" class="form-control"/>
          </div>
        </div>
        <div class="form-actions">
          <button type="button" class="btn btn-outline" onclick="closeModal('modal-um')">Cancel</button>
          <button type="submit" class="btn btn-cyan">Save</button>
        </div>
      </form>
    </div>
  </div>

  <%-- ══════════════════════════════════════ --%>
  <%-- MODAL: EDIT USER PASS                  --%>
  <%-- ══════════════════════════════════════ --%>
  <div class="amm-modal-overlay" id="modal-up">
    <div class="amm-modal" style="max-width:520px;">
      <div class="amm-modal-title">Edit User Gaming Pass</div>
      <button class="amm-modal-close" onclick="closeModal('modal-up')">✕</button>
      <form action="${pageContext.request.contextPath}/admin/memberships" method="post">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
        <input type="hidden" name="action" value="update_user_pass"/>
        <input type="hidden" name="id" id="up-id"/>
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">User ID</label>
            <input type="text" id="up-userid" class="form-control" disabled style="opacity:0.6;"/>
          </div>
          <div class="form-group">
            <label class="form-label">Tier</label>
            <select name="tierId" id="up-tierid" class="form-control">
              <c:forEach var="t" items="${passTiers}">
                <option value="${t.tierId}">${t.tierName}</option>
              </c:forEach>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Status</label>
            <select name="status" id="up-status" class="form-control">
              <option value="ACTIVE">ACTIVE</option>
              <option value="EXPIRED">EXPIRED</option>
              <option value="PENDING">PENDING</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Purchase Date</label>
            <input type="datetime-local" name="purchaseDate" id="up-purchase" class="form-control"/>
          </div>
          <div class="form-group">
            <label class="form-label">Expiry Date</label>
            <input type="datetime-local" name="expiryDate" id="up-expiry" class="form-control"/>
          </div>
          <div class="form-group span2">
            <label class="form-label">Payment Reference</label>
            <input type="text" name="paymentReference" id="up-ref" class="form-control"/>
          </div>
        </div>
        <div class="form-actions">
          <button type="button" class="btn btn-outline" onclick="closeModal('modal-up')">Cancel</button>
          <button type="submit" class="btn btn-cyan">Save</button>
        </div>
      </form>
    </div>
  </div>

  <jsp:include page="/footer.jsp"/>

  <script>
  (function(){
    /* ── TABS ── */
    document.querySelectorAll('.amm-tab-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.amm-tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.amm-panel').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById(btn.dataset.target).classList.add('active');
      });
    });

    /* ── MODAL HELPERS ── */
    window.closeModal = function(id) { document.getElementById(id).classList.remove('open'); }
    window.openModal  = function(id) { document.getElementById(id).classList.add('open'); }

    document.querySelectorAll('.amm-modal-overlay').forEach(ov => {
      ov.addEventListener('click', e => { if(e.target === ov) ov.classList.remove('open'); });
    });
    document.addEventListener('keydown', e => {
      if(e.key === 'Escape') document.querySelectorAll('.amm-modal-overlay.open').forEach(o => o.classList.remove('open'));
    });

    /* ── CREATE SESSION MODAL ── */
    document.getElementById('btn-open-create-session').addEventListener('click', () => {
      document.getElementById('modal-session-title').textContent = 'Create New Session';
      document.getElementById('session-action').value = 'add_session';
      document.getElementById('session-id-hidden').value = '';
      document.getElementById('session-id-field').value = '';
      document.getElementById('session-id-field').removeAttribute('readonly');
      document.getElementById('session-name').value = '';
      document.getElementById('session-start').value = '';
      document.getElementById('session-end').value = '';
      document.getElementById('session-fee').value = '';
      document.getElementById('session-active').value = 'true';
      document.getElementById('session-benefits-section').style.display = 'none';
      openModal('modal-session');
    });

    /* ── EDIT SESSION MODAL ── */
    document.querySelectorAll('.btn-edit-session').forEach(btn => {
      btn.addEventListener('click', () => {
        const d = btn.dataset;
        document.getElementById('modal-session-title').textContent = 'Edit Session';
        document.getElementById('session-action').value = 'update_session';
        document.getElementById('session-id-hidden').value = d.id;
        document.getElementById('session-id-field').value = d.id;
        document.getElementById('session-id-field').setAttribute('readonly', true);
        document.getElementById('session-name').value = d.name;
        document.getElementById('session-start').value = d.start;
        document.getElementById('session-end').value = d.end;
        document.getElementById('session-fee').value = d.fee;
        document.getElementById('session-active').value = d.active;
        document.getElementById('benefit-session-id').value = d.id;
        /* show only benefits for this session */
        document.querySelectorAll('#modal-benefit-list .benefit-item-modal').forEach(item => {
          item.style.display = item.dataset.session === d.id ? 'flex' : 'none';
        });
        document.getElementById('session-benefits-section').style.display = 'block';
        openModal('modal-session');
      });
    });

    /* ── EDIT USER MEMBERSHIP MODAL ── */
    document.querySelectorAll('.btn-edit-um').forEach(btn => {
      btn.addEventListener('click', () => {
        const d = btn.dataset;
        document.getElementById('um-id').value = d.id;
        document.getElementById('um-userid').value = d.userid;
        document.getElementById('um-status').value = d.status;
        const p = d.purchase || ''; document.getElementById('um-purchase').value = p.length === 16 ? p+':00' : p;
        const ex = d.expiry || ''; document.getElementById('um-expiry').value = ex.length === 16 ? ex+':00' : ex;
        document.getElementById('um-ref').value = d.ref || '';
        openModal('modal-um');
      });
    });

    /* ── EDIT USER PASS MODAL ── */
    document.querySelectorAll('.btn-edit-up').forEach(btn => {
      btn.addEventListener('click', () => {
        const d = btn.dataset;
        document.getElementById('up-id').value = d.id;
        document.getElementById('up-userid').value = d.userid;
        document.getElementById('up-tierid').value = d.tierid;
        document.getElementById('up-status').value = d.status;
        const p = d.purchase || ''; document.getElementById('up-purchase').value = p.length === 16 ? p+':00' : p;
        const ex = d.expiry || ''; document.getElementById('up-expiry').value = ex.length === 16 ? ex+':00' : ex;
        document.getElementById('up-ref').value = d.ref || '';
        openModal('modal-up');
      });
    });

    /* ── GAMING PASS EDIT TOGGLE ── */
    document.querySelectorAll('.btn-edit-pass').forEach(btn => {
      btn.addEventListener('click', () => {
        const card = document.getElementById('pass-card-' + btn.dataset.id);
        card.classList.add('editing');
      });
    });
    document.querySelectorAll('.btn-cancel-pass-edit').forEach(btn => {
      btn.addEventListener('click', () => {
        const card = document.getElementById('pass-card-' + btn.dataset.id);
        card.classList.remove('editing');
      });
    });

    /* ── NEW TIER CARD ── */
    window.openNewTier = function() {
      const card = document.getElementById('pass-card-new');
      card.classList.add('open');
    };
    window.closeNewTier = function() {
      document.getElementById('pass-card-new').classList.remove('open');
    };

    /* ── TOAST ── */
    function showToast(msg, isError) {
      const t = document.getElementById('amm-toast');
      const el = document.createElement('div');
      el.className = 'toast-item' + (isError ? ' error' : '');
      el.textContent = msg;
      t.appendChild(el);
      setTimeout(() => el.remove(), 4000);
    }
    if(window.__flashSuccess) showToast(window.__flashSuccess, false);
    if(window.__flashError)   showToast(window.__flashError, true);
  })();
  </script>
</body>
</html>
