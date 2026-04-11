<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Book Gaming Session – NexGen Esports</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css?v=7">

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const carousel = document.querySelector('.station-carousel');
                const cards = document.querySelectorAll('.station-card');
                const dotsContainer = document.getElementById('carousel-dots');
                const counterEl = document.getElementById('carousel-counter');

                if (cards.length === 0) return;

                const total = cards.length;
                let currentIndex = 0;

                // ── Build Dot Indicators ──────────────────────────────────────────
                function buildDots() {
                    dotsContainer.innerHTML = '';
                    if (total <= 1) return;

                    const MAX_DOTS = 7;        // maximum dots visible at once
                    const EDGE_SHRINK = 5;     // how many from each end to show as small when > MAX_DOTS

                    if (total <= MAX_DOTS) {
                        // Show all dots, no miniaturisation needed
                        for (let i = 0; i < total; i++) {
                            const dot = document.createElement('span');
                            dot.className = 'carousel-dot' + (i === currentIndex ? ' active' : '');
                            dot.setAttribute('data-index', i);
                            dot.addEventListener('click', () => goToIndex(i));
                            dotsContainer.appendChild(dot);
                        }
                    } else {
                        // Instagram window: always show MAX_DOTS (7)
                        // Window: center the active index inside [start, start+6]
                        let windowStart = Math.max(0, Math.min(currentIndex - 3, total - MAX_DOTS));
                        let windowEnd = windowStart + MAX_DOTS - 1;

                        for (let i = windowStart; i <= windowEnd; i++) {
                            const dot = document.createElement('span');
                            const posInWindow = i - windowStart; // 0..6
                            let sizeClass = '';
                            // Edge dots (position 0 or 6 in window) are small
                            if (posInWindow === 0 || posInWindow === MAX_DOTS - 1) {
                                sizeClass = ' small';
                            }
                            dot.className = 'carousel-dot' + sizeClass + (i === currentIndex ? ' active' : '');
                            dot.setAttribute('data-index', i);
                            dot.addEventListener('click', () => goToIndex(i));
                            dotsContainer.appendChild(dot);
                        }
                    }
                }

                function updateCounter() {
                    if (counterEl) counterEl.textContent = (currentIndex + 1) + '/' + total;
                }

                function updateActiveCard() {
                    let minDx = Infinity;
                    let activeIndex = 0;
                    const cRect = carousel.getBoundingClientRect();
                    const center = cRect.left + cRect.width / 2;

                    cards.forEach((card, i) => {
                        const rect = card.getBoundingClientRect();
                        const cardCenter = rect.left + rect.width / 2;
                        const dx = Math.abs(center - cardCenter);
                        if (dx < minDx) {
                            minDx = dx;
                            activeIndex = i;
                        }
                    });

                    cards.forEach((card, i) => {
                        card.classList.toggle('active-card', i === activeIndex);
                    });

                    if (activeIndex !== currentIndex) {
                        currentIndex = activeIndex;
                        buildDots();
                        updateCounter();
                    }
                }

                function goToIndex(idx) {
                    if (idx < 0) idx = 0;
                    if (idx >= total) idx = total - 1;
                    cards.forEach(c => c.classList.remove('flipped', 'selected'));

                    // Calculate the exact scroll position to center this card.
                    // Using scrollTo() instead of scrollIntoView() prevents the
                    // double-animation bug where scrollIntoView animates first,
                    // then scroll-snap fires a second micro-correction = stutter.
                    const card = cards[idx];
                    const carouselCenter = carousel.offsetWidth / 2;
                    const cardCenter = card.offsetLeft + card.offsetWidth / 2;
                    const targetScrollLeft = cardCenter - carouselCenter;

                    carousel.scrollTo({ left: targetScrollLeft, behavior: 'smooth' });
                }

                // Initial build
                updateActiveCard();
                buildDots();
                updateCounter();

                // ── Scroll event strategy: update ONLY after scroll settles ──────
                // Root cause of stutter: toggling .active-card class mid-scroll
                // triggers a 0.5s CSS transition that fights scroll-snap momentum.
                // Fix: suppress transitions while scrolling (.is-scrolling), then
                // update the active card only once the scroll has fully settled.

                let scrollSettleTimer = null;

                function onScrollStart() {
                    carousel.classList.add('is-scrolling');
                }

                function onScrollEnd() {
                    carousel.classList.remove('is-scrolling');
                    updateActiveCard();
                }

                // Use the native scrollend event if the browser supports it (Chrome 114+, FF 109+, iOS 16.4+)
                // Detection: check both window and element prototype for broadest mobile support
                const hasNativeScrollEnd = typeof window.onscrollend !== 'undefined'
                                        || 'onscrollend' in document.createElement('div');
                if (hasNativeScrollEnd) {
                    carousel.addEventListener('scroll', onScrollStart, { passive: true });
                    carousel.addEventListener('scrollend', onScrollEnd, { passive: true });
                } else {
                    // Fallback debounce for older iOS Safari & Android WebView.
                    // 200ms gives enough buffer for momentum scroll to fully settle.
                    carousel.addEventListener('scroll', () => {
                        onScrollStart();
                        clearTimeout(scrollSettleTimer);
                        scrollSettleTimer = setTimeout(onScrollEnd, 200);
                    }, { passive: true });
                }

                // ── Touch / Swipe note ────────────────────────────────────────────
                // Native browser scroll-snap handles all touch swipe gestures.
                // DO NOT add touchstart/touchend handlers here — they fight scroll-snap
                // momentum and cause double-jumps (e.g. swipe card 1→2 but land on 3).
                // The scrollend listener above already updates currentIndex after each snap.


                // ── Arrow navigation ─────────────────────────────────────────────
                window.scrollCarousel = function(dir) {
                    goToIndex(currentIndex + dir);
                };

                window.flipCard = function(stationId) {
                    const card = document.getElementById('card-' + stationId);
                    if (!card.classList.contains('active-card')) {
                        cards.forEach(c => c.classList.remove('flipped', 'selected'));
                        card.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
                        return;
                    }
                    const wasFlipped = card.classList.contains('flipped');
                    document.querySelectorAll('.station-card').forEach(c => {
                        if (c.id !== 'card-' + stationId) c.classList.remove('flipped', 'selected');
                    });
                    if (!wasFlipped) {
                        card.classList.add('flipped', 'selected');
                    } else {
                        card.classList.remove('flipped', 'selected');
                    }
                };
            });

            function preventPropagation(event) {
                event.stopPropagation();
            }

            function loadSlots(stationId, event) {
                if(event) {
                    event.stopPropagation();
                    event.preventDefault(); 
                }
                
                var dateItem = document.getElementById('date-' + stationId);
                if(!dateItem || !dateItem.value) {
                    alert('Please select a valid date first.');
                    return;
                }
                var selectedDate = dateItem.value;

                var playerRadios = document.getElementsByName('pc-' + stationId);
                var playerCount = 1;
                for (var i = 0; i < playerRadios.length; i++) {
                    if (playerRadios[i].checked) {
                        playerCount = playerRadios[i].value;
                        break;
                    }
                }

                var container = document.getElementById('slot-table-container');
                container.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--neon-cyan);">Loading slots...</div>';
                
                var url = '${pageContext.request.contextPath}/bookStation?stationID=' + encodeURIComponent(stationId) 
                          + '&playerCount=' + encodeURIComponent(playerCount) 
                          + '&date=' + encodeURIComponent(selectedDate);
                
                fetch(url)
                    .then(response => response.text())
                    .then(html => {
                        container.innerHTML = html;
                        setTimeout(function(){
                            var headerHeight = document.querySelector('.header') ? document.querySelector('.header').offsetHeight : 0;
                            var containerTop = container.getBoundingClientRect().top + window.scrollY;
                            // Stops exactly 20px under the header's bottom border on any device
                            window.scrollTo({ top: containerTop - headerHeight - 20, behavior: 'smooth' });
                        }, 100);
                    })
                    .catch(e => {
                        container.innerHTML = '<div class="glass-card error-card">Failed to fetch slots.</div>';
                    });
            }
        </script>
    </head>
    <body class="app-wrapper">
        <%@ include file="header.jsp" %>

        <div class="main-container">
            <%@ include file="sidebar.jsp" %>
            
            <main class="content">
                <div class="rigid-layout-container">

                    <!-- Page Hero -->
                    <div class="profile-hero" style="margin-bottom: 20px;">
                        <div class="profile-hero-icon">🎮</div>
                        <h2>BOOK GAMING SESSION</h2>
                        <p class="subtitle">Choose your battleground and session configuration.</p>
                        <div style="margin-top: 20px; display: inline-flex; flex-direction: column; align-items: center; gap: 10px;">
                            <span class="status-badge" style="background: rgba(176, 38, 255, 0.1); color: var(--neon-purple); border: 1px solid rgba(176, 38, 255, 0.3); padding: 8px 16px; font-size: 0.8rem; letter-spacing: 1px;">
                                Happy Hour Pricing Applies Automatically During Evening Sessions
                            </span>
                            <div style="margin-top: 15px; padding: 10px 20px; width: 100%;">
                                <table style="width: 100%; border-collapse: collapse; font-size: 0.85rem; color: rgba(255,255,255,0.7);">
                                    <tr>
                                        <td style="padding: 5px 15px; text-align: right; border-right: 1px solid rgba(255,255,255,0.1);">Sunday – Thursday</td>
                                        <td style="padding: 5px 15px; text-align: left; font-weight: bold; color: white;">${wdOpen} – ${closeHr}</td>
                                        <td style="padding: 5px 15px; text-align: left; color: var(--neon-purple);">Happy Hour: ${wdHappy} – ${happyEnd}</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 5px 15px; text-align: right; border-right: 1px solid rgba(255,255,255,0.1);">Friday – Saturday</td>
                                        <td style="padding: 5px 15px; text-align: left; font-weight: bold; color: white;">${weOpen} – ${closeHr}</td>
                                        <td style="padding: 5px 15px; text-align: left; color: var(--neon-purple);">Happy Hour: ${weHappy} – ${happyEnd}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Station Cards Grid (3D Flip logic wrapped in Cover Flow) -->
                    <div class="cover-flow-wrapper">
                        <button class="carousel-btn prev" onclick="scrollCarousel(-1)">&#10094;</button>
                        <button class="carousel-btn next" onclick="scrollCarousel(1)">&#10095;</button>
                        
                        <div class="station-carousel">
                            <%
                                // Calculate today's date for minimum date picker
                                java.time.LocalDate todayDate = java.time.LocalDate.now();
                                pageContext.setAttribute("todayStr", todayDate.toString());
                            %>
                            <c:forEach var="s" items="${stations}">
                                <div class="station-card" id="card-${s.stationID}">
                                    <div class="station-card-inner">
                                        <!-- FRONT OF CARD -->
                                        <div class="card-front" onclick="flipCard('${s.stationID}')">
                                            <div class="station-header">
                                                <div class="station-identity">
                                                    <div class="station-id">${s.stationID}</div>
                                                    <h3>${s.stationName}</h3>
                                                </div>
                                            </div>

                                            <div class="pricing-showcase">
                                                <div class="pricing-tier normal">
                                                    <span class="tier-label">Normal</span>
                                                    <div class="pricing-rates">
                                                        <div class="rate-item">
                                                            <span class="players">1P</span>
                                                            <span class="price">RM${s.normalPrice1Player}</span>
                                                        </div>
                                                        <div class="rate-item ${empty s.normalPrice2Player ? 'unavailable' : ''}">
                                                            <span class="players">2P</span>
                                                            <c:choose>
                                                                <c:when test="${not empty s.normalPrice2Player}">
                                                                    <span class="price">RM${s.normalPrice2Player}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="price">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="pricing-tier happy-hour">
                                                    <span class="tier-label">Happy Hour</span>
                                                    <div class="pricing-rates">
                                                        <div class="rate-item">
                                                            <span class="players">1P</span>
                                                            <span class="price">RM${s.happyHourPrice1Player}</span>
                                                        </div>
                                                        <div class="rate-item ${empty s.happyHourPrice2Player ? 'unavailable' : ''}">
                                                            <span class="players">2P</span>
                                                            <c:choose>
                                                                <c:when test="${not empty s.happyHourPrice2Player}">
                                                                    <span class="price">RM${s.happyHourPrice2Player}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="price">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div style="text-align: center; margin-top: 10px;">
                                                <span style="color: var(--neon-cyan); font-size: 0.8rem; text-transform: uppercase; font-weight: bold; letter-spacing: 1px;">Click to Configure <span style="display:inline-block; margin-left: 5px;">&rarr;</span></span>
                                            </div>
                                        </div>

                                        <!-- BACK OF CARD -->
                                        <div class="card-back" onclick="preventPropagation(event)">
                                            <h3 style="color: var(--neon-cyan); margin-bottom: 20px;">Session Setup</h3>
                                            
                                            <div style="width: 100%; margin-bottom: 20px;">
                                                <label style="display: block; text-align: left; font-size: 0.85rem; color: rgba(255,255,255,0.6); margin-bottom: 5px;">Players</label>
                                                <div class="role-pill-group">
                                                    <div class="role-pill">
                                                        <input type="radio" id="p1-${s.stationID}" name="pc-${s.stationID}" value="1" checked>
                                                        <label for="p1-${s.stationID}">1 Player</label>
                                                    </div>
                                                    <div class="role-pill">
                                                        <!-- Disable 2 Player option if price is unavailable -->
                                                        <c:set var="twoPlayerDisabled" value="${empty s.normalPrice2Player}" />
                                                        <input type="radio" id="p2-${s.stationID}" name="pc-${s.stationID}" value="2" ${twoPlayerDisabled ? 'disabled' : ''}>
                                                        <label for="p2-${s.stationID}" style="${twoPlayerDisabled ? 'text-decoration: line-through;' : ''}">2 Players</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div style="width: 100%; margin-bottom: 24px; text-align: left;">
                                                <label for="date-${s.stationID}" style="display: block; font-size: 0.85rem; color: rgba(255,255,255,0.6); margin-bottom: 5px;">Date</label>
                                                <input type="date" id="date-${s.stationID}" class="input-field" min="${todayStr}" value="${todayStr}" style="width: 100%; padding: 12px; font-size: 1rem; color: white;" required>
                                            </div>

                                            <div style="display: flex; gap: 10px; width: 100%;">
                                                <button type="button" class="btn btn-outline" style="flex: 1;" onclick="flipCard('${s.stationID}')">&larr; Back</button>
                                                <button type="button" class="btn btn-buy" style="flex: 2;" onclick="loadSlots('${s.stationID}', event)">View Slots</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- ── Dot Pagination + Counter ── -->
                        <div class="carousel-footer">
                            <div class="carousel-dots" id="carousel-dots"></div>
                            <span class="carousel-counter" id="carousel-counter"></span>
                        </div>
                    </div>

                    <!-- Dynamic Slot Table Container -->
                    <div id="slot-table-container" style="margin-top: 40px;">
                        <!-- The fragment will be loaded here -->
                    </div>

                </div>
            </main>
        </div>

        <%@ include file="footer.jsp" %>
    </body>
</html>
