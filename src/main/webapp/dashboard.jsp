<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Command Center — NexGen Esports</title>
    <meta name="description" content="Your personal NexGen Esports Player Command Center. Track bookings, memberships, tournaments, and more.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/utilities.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="app-wrapper">
<canvas id="esports-bg-canvas"></canvas>
<jsp:include page="header.jsp"/>

<div class="main-container">
    <jsp:include page="sidebar.jsp"/>

    <main class="content">
        <div class="rigid-layout-container">

            <%-- ═══════════════════════════ HERO IDENTITY BLOCK ════════════════════════════ --%>
            <section class="dash-hero">
                <div class="dash-hero-scanline"></div>
                <div class="dash-hero-inner">
                    <div class="dash-hero-left">
                        <div class="dash-profile-pic">
                            <span class="dash-profile-initial">${not empty sessionScope.username ? fn:substring(sessionScope.username, 0, 1) : 'O'}</span>
                        </div>
                        <div class="dash-profile-info">
                            <p class="dash-hero-eyebrow">⚡ OPERATOR AUTHENTICATED — ALL SYSTEMS NOMINAL</p>
                            <div class="dash-hero-callsign-label">CALLSIGN</div>
                            <h1 class="dash-hero-username"><c:out value="${sessionScope.username}"/></h1>
                            <div class="dash-hero-badges">
                                <c:choose>
                                    <c:when test="${sessionScope.role == 'high_council'}">
                                        <span class="dash-role-badge dash-role-admin">⚠ HIGH COUNCIL</span>
                                    </c:when>
                                    <c:when test="${sessionScope.role == 'executive_council'}">
                                        <span class="dash-role-badge dash-role-staff">🛠 EXCO</span>
                                    </c:when>
                                    <c:when test="${sessionScope.role == 'referee'}">
                                        <span class="dash-role-badge dash-role-staff">⚖ REFEREE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="dash-role-badge dash-role-athlete">🎮 ATHLETE</span>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${not empty sessionScope.position}">
                                    <span class="dash-role-badge dash-role-position"><c:out value="${sessionScope.position}"/></span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="dash-hero-right">
                        <div class="dash-hero-clock-label">SYSTEM TIME</div>
                        <div class="dash-hero-clock" id="dashClock">--:--:--</div>
                        <div class="dash-hero-date" id="dashDate">--- -- ----</div>
                        <div class="dash-hero-last-login">LAST LOGIN: NOT RECORDED</div>
                    </div>
                </div>
            </section>

            <%-- ═══════════════════════════ STAT COMMAND STRIP ════════════════════════════ --%>
            <section class="dash-stat-strip">
                <div class="glass-card dash-stat-card">
                    <div class="dash-stat-icon">🎮</div>
                    <div class="dash-stat-content">
                        <div class="dash-stat-value"><c:out value="${dashTotalBookings}"/></div>
                        <div class="dash-stat-label">SESSIONS LOGGED</div>
                    </div>
                </div>
                <div class="glass-card dash-stat-card">
                    <div class="dash-stat-icon">⏱️</div>
                    <div class="dash-stat-content">
                        <div class="dash-stat-value"><c:out value="${dashTotalHours}"/></div>
                        <div class="dash-stat-label">HOURS ON STATION</div>
                    </div>
                </div>
                <div class="glass-card dash-stat-card">
                    <div class="dash-stat-icon">📅</div>
                    <div class="dash-stat-content">
                        <div class="dash-stat-value"><c:out value="${dashUpcomingCount}"/></div>
                        <div class="dash-stat-label">UPCOMING</div>
                    </div>
                </div>
                <div class="glass-card dash-stat-card">
                    <div class="dash-stat-icon">🏆</div>
                    <div class="dash-stat-content">
                        <div class="dash-stat-value"><c:out value="${fn:length(dashOpenTourneys)}"/></div>
                        <div class="dash-stat-label">OPEN ARENAS</div>
                    </div>
                </div>
            </section>

            <%-- ═══════════════════════════ IDENTITY CARDS ════════════════════════════════ --%>
            <section class="dash-identity-grid">

                <%-- Club Membership Card --%>
                <div class="glass-card dash-id-card dash-id-card--membership">
                    <div class="dash-id-card__header">
                        <span class="dash-id-card__icon">🛡️</span>
                        <span class="dash-id-card__title">CLUB MEMBERSHIP</span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty dashMembership and dashMembership.status == 'ACTIVE'}">
                            <div class="dash-id-active-split">
                                <div class="dash-id-split-left">
                                    <div class="dash-id-card__name"><c:out value="${dashMembership.session.sessionName}"/></div>
                                    <div class="dash-id-card__discount">
                                        <span class="dash-id-discount-badge"><c:out value="${dashMembership.session.discountRate}"/>% OFF</span>
                                    </div>
                                </div>
                                <div class="dash-id-split-right">
                                    <div class="dash-ring-labels">
                                        <span class="badge badge-success">ACTIVE</span>
                                        <div class="dash-id-expiry">
                                            <span>EXPIRES:</span><br/>
                                            <strong>${fn:substring(dashMembership.expiryDate, 0, 10)}</strong>
                                        </div>
                                    </div>
                                    <div class="dash-ring-container">
                                        <svg class="dash-ring" viewBox="0 0 80 80">
                                            <circle class="dash-ring__bg" cx="40" cy="40" r="32"/>
                                            <circle class="dash-ring__fill ${dashMemDaysLeft <= 7 ? 'dash-ring__fill--urgent' : ''}"
                                                    cx="40" cy="40" r="32"
                                                    style="stroke-dasharray: ${(dashMemDaysLeft / dashMemTotalDays) * 201} 201"/>
                                        </svg>
                                        <div class="dash-ring-inner">
                                            <span class="dash-ring-days"><c:out value="${dashMemDaysLeft}"/></span>
                                            <span class="dash-ring-unit">DAYS</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${not empty dashMembership and dashMembership.status != 'ACTIVE'}">
                            <div class="dash-id-card__name">MEMBERSHIP EXPIRED</div>
                            <div class="dash-id-card__empty">
                                <span class="badge badge-danger"><c:out value="${dashMembership.status}"/></span>
                                <p>Subscribe to unlock exclusive discounts</p>
                                <a href="${pageContext.request.contextPath}/manageMembership" class="btn btn-outline-primary">RENEW NOW</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="dash-id-card__empty">
                                <div class="dash-id-card__empty-icon">🔒</div>
                                <p>No active membership</p>
                                <a href="${pageContext.request.contextPath}/manageMembership" class="btn btn-outline-primary">JOIN NOW</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Gaming Pass Card --%>
                <div class="glass-card dash-id-card dash-id-card--pass">
                    <div class="dash-id-card__header">
                        <span class="dash-id-card__icon">⚡</span>
                        <span class="dash-id-card__title">GAMING PASS</span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty dashGamingPass and dashGamingPass.status == 'ACTIVE'}">
                            <div class="dash-id-active-split">
                                <div class="dash-id-split-left">
                                    <div class="dash-id-card__name"><c:out value="${dashGamingPass.tier.tierName}"/></div>
                                    <div class="dash-id-card__discount">
                                        <span class="dash-id-discount-badge dash-id-discount-badge--pass"><c:out value="${dashGamingPass.tier.discountRate}"/>% OFF</span>
                                    </div>
                                </div>
                                <div class="dash-id-split-right">
                                    <div class="dash-ring-labels">
                                        <span class="badge badge-premium">ACTIVE</span>
                                        <div class="dash-id-expiry">
                                            <span>EXPIRES:</span><br/>
                                            <strong>${fn:substring(dashGamingPass.expiryDate, 0, 10)}</strong>
                                        </div>
                                    </div>
                                    <div class="dash-ring-container">
                                        <svg class="dash-ring dash-ring--pass" viewBox="0 0 80 80">
                                            <circle class="dash-ring__bg" cx="40" cy="40" r="32"/>
                                            <circle class="dash-ring__fill--pass ${dashPassDaysLeft <= 7 ? 'dash-ring__fill--urgent' : ''}"
                                                    cx="40" cy="40" r="32"
                                                    style="stroke-dasharray: ${(dashPassDaysLeft / dashPassTotalDays) * 201} 201"/>
                                        </svg>
                                        <div class="dash-ring-inner">
                                            <span class="dash-ring-days"><c:out value="${dashPassDaysLeft}"/></span>
                                            <span class="dash-ring-unit">DAYS</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${not empty dashGamingPass and dashGamingPass.status != 'ACTIVE'}">
                            <div class="dash-id-card__name">PASS EXPIRED</div>
                            <div class="dash-id-card__empty">
                                <span class="badge badge-danger"><c:out value="${dashGamingPass.status}"/></span>
                                <p>Renew your gaming pass for station discounts</p>
                                <a href="${pageContext.request.contextPath}/manageMembership" class="btn btn-outline-primary">RENEW PASS</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="dash-id-card__empty">
                                <div class="dash-id-card__empty-icon">⚡</div>
                                <p>No active gaming pass</p>
                                <a href="${pageContext.request.contextPath}/manageMembership" class="btn btn-outline-primary">GET A PASS</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </section>

            <%-- ═══════════════════════════ UPCOMING BOOKING + TOURNAMENTS ════════════════ --%>
            <section class="dash-two-col">

                <%-- Upcoming Booking Panel --%>
                <div class="glass-card dash-booking-panel">
                    <h2 class="dash-panel-heading">📅 NEXT SESSION</h2>
                    <c:choose>
                        <c:when test="${not empty dashNextBooking}">
                            <div class="dash-booking-station">STATION <c:out value="${dashNextBooking.stationID}"/></div>
                            <div class="dash-booking-flex">
                                <div class="dash-booking-left">
                                    <div class="dash-booking-time">
                                        ${fn:substring(dashNextBooking.startTime, 0, 5)} — ${fn:substring(dashNextBooking.endTime, 0, 5)}
                                    </div>
                                    <div class="dash-booking-date">
                                        ${dashNextBooking.date}
                                    </div>
                                    <div class="dash-booking-meta">
                                        <span class="dash-booking-meta-chip">⏱ <c:out value="${dashNextBooking.hourCount}"/>h</span>
                                        <span class="dash-booking-meta-chip">👥 <c:out value="${dashNextBooking.playerCount}"/> players</span>
                                        <span class="dash-booking-meta-chip dash-priceType-${fn:toLowerCase(dashNextBooking.priceType)}">
                                            <c:out value="${dashNextBooking.priceType}"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="dash-booking-right">
                                    <div class="dash-booking-price">RM ${dashNextBooking.price}</div>
                                    <c:choose>
                                        <c:when test="${dashNextBooking.paymentStatus == 'PAID'}">
                                            <span class="badge badge-success">PAID</span>
                                        </c:when>
                                        <c:when test="${dashNextBooking.paymentStatus == 'PENDING'}">
                                            <span class="badge badge-warning">PENDING</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger"><c:out value="${dashNextBooking.paymentStatus}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="dash-empty-state">
                                <span class="dash-empty-icon">🎮</span>
                                <p>No upcoming sessions booked</p>
                                <a href="${pageContext.request.contextPath}/selectStation" class="btn btn-outline-primary">BOOK A STATION</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Open Tournaments Feed --%>
                <div class="glass-card dash-tourney-panel">
                    <h2 class="dash-panel-heading">🏆 OPEN ARENA EVENTS</h2>
                    <c:choose>
                        <c:when test="${not empty dashOpenTourneys}">
                            <ul class="dash-tourney-list">
                                <c:forEach var="t" items="${dashOpenTourneys}" varStatus="loop">
                                    <li class="dash-tourney-item">
                                        <div class="dash-tourney-split-left">
                                            <div class="dash-tourney-name"><c:out value="${t.programName}"/></div>
                                            <div class="dash-tourney-item-meta">
                                                <c:if test="${not empty t.prizePool}">
                                                    <span class="dash-tourney-prize">🏆 RM <fmt:formatNumber value="${t.prizePool}" pattern="#,##0"/></span>
                                                </c:if>
                                                <c:if test="${not empty t.progFee}">
                                                    <span class="dash-tourney-fee">Entry: RM <fmt:formatNumber value="${t.progFee}" pattern="#,##0.00"/></span>
                                                </c:if>
                                            </div>
                                            <div class="dash-tourney-countdown" data-start="${t.startDate}">
                                                <span class="dash-countdown-label">STARTS IN</span>
                                                <span class="dash-countdown-timer" id="countdown-${loop.index}">-- D : -- H : -- M</span>
                                            </div>
                                        </div>
                                        <div class="dash-tourney-split-right">
                                            <span class="dash-tourney-type-badge"><c:out value="${t.programType}"/></span>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                            <a href="${pageContext.request.contextPath}/programTournament" class="dash-view-all-link">VIEW ALL PROGRAMS →</a>
                        </c:when>
                        <c:otherwise>
                            <div class="dash-empty-state">
                                <span class="dash-empty-icon">🏆</span>
                                <p>No open tournaments right now</p>
                                <a href="${pageContext.request.contextPath}/programTournament" class="btn btn-outline-primary">BROWSE EVENTS</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </section>

            <%-- ═══════════════════════════ RECENT ACTIVITY LOG ══════════════════════════ --%>
            <c:if test="${not empty dashRecentBookings}">
                <section class="glass-card dash-activity-section">
                    <h2 class="dash-panel-heading">📋 RECENT ACTIVITY</h2>
                    <ul class="dash-activity-log">
                        <c:forEach var="b" items="${dashRecentBookings}">
                            <li class="dash-activity-item">
                                <span class="dash-activity-dot dash-activity-dot--${fn:toLowerCase(b.paymentStatus)}"></span>
                                <div class="dash-activity-info">
                                    <span class="dash-activity-station">Station <c:out value="${b.stationID}"/></span>
                                    <span class="dash-activity-date">
                                        ${b.date} &nbsp; ${fn:substring(b.startTime, 0, 5)} — ${fn:substring(b.endTime, 0, 5)}
                                    </span>
                                </div>
                                <div class="dash-activity-right">
                                    <span class="dash-activity-price">RM ${b.price}</span>
                                    <c:choose>
                                        <c:when test="${b.paymentStatus == 'PAID'}">
                                            <span class="badge badge-success">PAID</span>
                                        </c:when>
                                        <c:when test="${b.paymentStatus == 'PENDING'}">
                                            <span class="badge badge-warning">PENDING</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger"><c:out value="${b.paymentStatus}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </section>
            </c:if>

            <%-- ═══════════════════════════ QUICK LAUNCH GRID ════════════════════════════ --%>
            <section class="dash-quicklaunch-grid">
                <a href="${pageContext.request.contextPath}/selectStation" class="dash-tile" id="tile-book">
                    <span class="dash-tile-icon">🎮</span>
                    <span class="dash-tile-title">BOOK STATION</span>
                    <span class="dash-tile-sub">Reserve your gaming seat</span>
                </a>
                <a href="${pageContext.request.contextPath}/programTournament" class="dash-tile" id="tile-programs">
                    <span class="dash-tile-icon">🏆</span>
                    <span class="dash-tile-title">BROWSE PROGRAMS</span>
                    <span class="dash-tile-sub">Tournaments &amp; events</span>
                </a>
                <a href="${pageContext.request.contextPath}/manageTeam" class="dash-tile" id="tile-team">
                    <span class="dash-tile-icon">👥</span>
                    <span class="dash-tile-title">MY TEAM</span>
                    <span class="dash-tile-sub">Manage your squad</span>
                </a>
                <a href="${pageContext.request.contextPath}/manageMembership" class="dash-tile" id="tile-membership">
                    <span class="dash-tile-icon">🛡️</span>
                    <span class="dash-tile-title">MEMBERSHIPS</span>
                    <span class="dash-tile-sub">Passes &amp; subscriptions</span>
                </a>
            </section>

            <%-- ═══════════════════════════ ADMIN OPS BANNER ═════════════════════════════ --%>
            <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'STAFF'}">
                <section class="dash-ops-banner glass-card">
                    <div class="dash-ops-banner__header">
                        <span class="dash-ops-banner__icon">⚙️</span>
                        <span class="dash-ops-banner__title">OPS CENTER</span>
                        <span class="dash-ops-banner__badge">RESTRICTED ACCESS</span>
                    </div>
                    <div class="dash-ops-links">
                        <a href="${pageContext.request.contextPath}/adminDashboard" class="dash-ops-link">🖥 Admin Panel</a>
                        <a href="${pageContext.request.contextPath}/programTournament" class="dash-ops-link">🏆 Manage Programs</a>
                        <a href="${pageContext.request.contextPath}/manageMembership" class="dash-ops-link">🛡 Manage Members</a>
                    </div>
                </section>
            </c:if>

        </div><%-- /rigid-layout-container --%>
    </main>
</div>

<jsp:include page="footer.jsp"/>

<script>
    /* ── Live Clock ──────────────────────────────────────────── */
    (function() {
        const clockEl = document.getElementById('dashClock');
        const dateEl  = document.getElementById('dashDate');
        const days    = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
        const months  = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];

        function pad(n) { return String(n).padStart(2, '0'); }

        function tick() {
            const now = new Date();
            clockEl.textContent = pad(now.getHours()) + ':' + pad(now.getMinutes()) + ':' + pad(now.getSeconds());
            dateEl.textContent  = days[now.getDay()] + ' ' + pad(now.getDate()) + ' ' + months[now.getMonth()] + ' ' + now.getFullYear();
        }
        tick();
        setInterval(tick, 1000);
    })();

    /* ── Tournament Countdown Timers ─────────────────────────── */
    (function() {
        const items = document.querySelectorAll('.dash-tourney-countdown');
        items.forEach(function(el, idx) {
            const raw   = el.getAttribute('data-start');
            if (!raw) return;
            // raw is yyyy-MM-dd from LocalDate.toString()
            const target = new Date(raw + 'T00:00:00');
            const timerEl = document.getElementById('countdown-' + idx);
            if (!timerEl) return;

            function updateTimer() {
                const diff = target - new Date();
                if (diff <= 0) {
                    timerEl.textContent = 'LIVE NOW';
                    return;
                }
                const d = Math.floor(diff / 86400000);
                const h = Math.floor((diff % 86400000) / 3600000);
                const m = Math.floor((diff % 3600000) / 60000);
                timerEl.textContent = d + ' D : ' + String(h).padStart(2,'0') + ' H : ' + String(m).padStart(2,'0') + ' M';
            }
            updateTimer();
            setInterval(updateTimer, 60000);
        });
    })();
</script>
</body>
</html>
