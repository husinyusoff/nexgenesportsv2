<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Book Gaming Session – NexGen Esports</title>
        <link rel="stylesheet" href="styles.css">
        <style>
        <style>
            .role-pill-group {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-top: 10px;
            }
            .role-pill {
                position: relative;
                flex: 1;
            }
            .role-pill input[type="radio"], .role-pill input[type="checkbox"] {
                position: absolute; /* Changed to position absolute so we can't accidentally click empty space */
                opacity: 0;
                cursor: pointer;
                height: 0;
                width: 0;
            }
            .role-pill label {
                display: flex;
                padding: 12px 10px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 8px;
                background: rgba(15, 15, 20, 0.8);
                color: rgba(255, 255, 255, 0.6);
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 600;
                font-size: 0.9rem;
                height: 100%;
                text-align: center;
            }
            .role-pill input[type="radio"]:checked + label, .role-pill input[type="checkbox"]:checked + label {
                border-color: var(--neon-cyan);
                background: rgba(0, 229, 255, 0.1);
                color: white;
                box-shadow: 0 0 10px rgba(0, 229, 255, 0.2);
            }
            .role-pill input[type="radio"]:disabled + label, .role-pill input[type="checkbox"]:disabled + label {
                opacity: 0.4;
                cursor: not-allowed;
            }
            
            /* Cover Flow Wrapper */
            .cover-flow-wrapper {
                position: relative;
                width: 100%;
                margin-top: 2rem;
                margin-bottom: 2rem;
            }
            /* Carousel Arrows */
            .carousel-btn {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                z-index: 15;
                background: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(5px);
                border: 1px solid var(--neon-cyan);
                color: var(--neon-cyan);
                width: 48px;
                height: 48px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 1.5rem;
                box-shadow: 0 0 15px rgba(0, 229, 255, 0.2);
                transition: all 0.3s ease;
            }
            .carousel-btn:hover {
                background: var(--neon-cyan);
                color: black;
                box-shadow: 0 0 20px rgba(0, 229, 255, 0.6);
            }
            .carousel-btn.prev { left: 10px; }
            .carousel-btn.next { right: 10px; }

            /* Station Carousel Horizontal List */
            .station-carousel {
                display: flex;
                overflow-x: auto;
                gap: 2rem;
                padding: 3rem calc(50% - 170px); /* 340px total width / 2 => centers first/last elements */
                scroll-snap-type: x mandatory;
                scrollbar-width: none; /* Hide standard scrollbar */
                scroll-behavior: smooth;
            }
            .station-carousel::-webkit-scrollbar {
                display: none;
            }
            .station-carousel > .station-card {
                flex: 0 0 340px; 
                width: 340px;
                min-width: 340px;
                scroll-snap-align: center;
                transition: transform 0.5s cubic-bezier(0.2, 0.8, 0.2, 1), filter 0.5s ease, opacity 0.5s ease;
                filter: blur(5px);
                opacity: 0.6;
                transform: scale(0.85); /* shrink peripheral cards */
            }
            .station-carousel > .station-card.active-card {
                filter: blur(0px);
                opacity: 1;
                transform: scale(1.05); /* elevate central card */
                z-index: 5;
            }

            @media(max-width: 768px) {
                .station-carousel > .station-card {
                    flex: 0 0 260px;
                    width: 260px;
                    min-width: 260px;
                }
                .station-carousel {
                    padding: 2rem calc(50% - 130px);
                }
                .carousel-btn { 
                    width: 32px; 
                    height: 32px; 
                    font-size: 1rem; 
                    opacity: 0.3;
                    background: rgba(0,0,0,0.6);
                }
                .carousel-btn.prev { left: 4px; }
                .carousel-btn.next { right: 4px; }
            }
        </style>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const carousel = document.querySelector('.station-carousel');
                const cards = document.querySelectorAll('.station-card');

                if(cards.length === 0) return;

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
                        if (i === activeIndex) {
                            card.classList.add('active-card');
                        } else {
                            card.classList.remove('active-card');
                        }
                    });
                }

                // Attach scroll event for intersection mapping
                carousel.addEventListener('scroll', updateActiveCard);
                // Initial update
                updateActiveCard();

                window.scrollCarousel = function(dir) {
                    const active = document.querySelector('.station-card.active-card');
                    if(!active) return;
                    const index = Array.from(cards).indexOf(active);
                    let targetIndex = index + dir;
                    
                    if (targetIndex < 0) targetIndex = 0;
                    if (targetIndex >= cards.length) targetIndex = cards.length - 1;
                    
                    // Optional: remove flip states when traversing via arrows
                    cards.forEach(c => c.classList.remove('flipped', 'selected'));
                    
                    cards[targetIndex].scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
                };

                window.flipCard = function(stationId) {
                    var card = document.getElementById('card-' + stationId);
                    
                    // If it's a peripheral card, only bring it to center. Do NOT flip it.
                    if (!card.classList.contains('active-card')) {
                        cards.forEach(function(c) { c.classList.remove('flipped', 'selected'); });
                        card.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
                        return;
                    }
                    
                    var wasFlipped = card.classList.contains('flipped');
                    
                    // Unflip all others
                    document.querySelectorAll('.station-card').forEach(function(c) {
                        if(c.id !== 'card-' + stationId) {
                            c.classList.remove('flipped', 'selected');
                        }
                    });
                    
                    // Toggle current
                    if(!wasFlipped) {
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
                            container.scrollIntoView({ behavior: 'smooth', block: 'start' });
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
                        <h2>BOOK GAMING SESSION</h2>
                        <p class="subtitle">Choose your battleground and session configuration.</p>
                        <div style="margin-top: 20px; display: inline-flex; flex-direction: column; align-items: center; gap: 10px;">
                            <span class="status-badge" style="background: rgba(176, 38, 255, 0.1); color: var(--neon-purple); border: 1px solid rgba(176, 38, 255, 0.3); padding: 8px 16px; font-size: 0.8rem; letter-spacing: 1px;">
                                Happy Hour Pricing Applies Automatically During Evening Sessions
                            </span>
                            <div style="margin-top: 15px; padding: 10px 20px; width: 100%;">
                                <table style="width: 100%; border-collapse: collapse; font-size: 0.85rem; color: rgba(255,255,255,0.7);">
                                    <tr>
                                        <td style="padding: 5px 15px; text-align: right; border-right: 1px solid rgba(255,255,255,0.1);">Monday – Thursday</td>
                                        <td style="padding: 5px 15px; text-align: left; font-weight: bold; color: white;">${wdOpen} – ${closeHr}</td>
                                        <td style="padding: 5px 15px; text-align: left; color: var(--neon-purple);">Happy Hour: ${wdHappy} – ${happyEnd}</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 5px 15px; text-align: right; border-right: 1px solid rgba(255,255,255,0.1);">Friday</td>
                                        <td style="padding: 5px 15px; text-align: left; font-weight: bold; color: white;">${weOpen} – ${closeHr}</td>
                                        <td style="padding: 5px 15px; text-align: left; color: var(--neon-purple);">Happy Hour: ${weHappy} – ${happyEnd}</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 5px 15px; text-align: right; border-right: 1px solid rgba(255,255,255,0.1);">Saturday – Sunday</td>
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
