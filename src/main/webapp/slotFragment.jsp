<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty error}">
    <div class="glass-card error-card" style="border-color: var(--neon-purple); text-align: center; padding: 20px;">
        <p style="color: var(--neon-purple); font-weight: bold; margin: 0;">${error}</p>
    </div>
</c:if>

<c:choose>
    <c:when test="${not showSlots}">
        <div class="glass-card" style="text-align: center; padding: 30px;">
            <p style="color: rgba(255,255,255,0.6);">Please select a valid future date to view available time slots.</p>
        </div>
    </c:when>

    <c:otherwise>
        <div class="glass-card" style="animation: fadeUp 0.6s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;">
            <div style="background: rgba(15, 15, 20, 0.9); border: 1px solid rgba(255,255,255,0.05); padding: 20px; border-radius: 12px; margin-bottom: 24px; display: flex; flex-wrap: wrap; justify-content: space-between; align-items: center; gap: 15px;">
                <div>
                    <h3 style="margin: 0 0 5px 0; color: var(--neon-cyan); letter-spacing: 1px;">AVAILABLE SLOTS</h3>
                    <p style="margin: 0; font-size: 0.85rem; color: rgba(255,255,255,0.6);">Select your preferred booking schedule below.</p>
                </div>
                <div style="display: flex; gap: 15px; font-size: 0.85rem;">
                    <div style="background: rgba(255,255,255,0.05); padding: 8px 16px; border-radius: 6px;">
                        <span style="color: rgba(255,255,255,0.5); display: block; font-size: 0.7rem; text-transform: uppercase; margin-bottom: 2px;">Station</span>
                        <strong style="color: white;">${stationName}</strong>
                    </div>
                    <div style="background: rgba(255,255,255,0.05); padding: 8px 16px; border-radius: 6px;">
                        <span style="color: rgba(255,255,255,0.5); display: block; font-size: 0.7rem; text-transform: uppercase; margin-bottom: 2px;">Date</span>
                        <strong style="color: white;">${selectedDate}</strong>
                    </div>
                    <div style="background: rgba(255,255,255,0.05); padding: 8px 16px; border-radius: 6px;">
                        <span style="color: rgba(255,255,255,0.5); display: block; font-size: 0.7rem; text-transform: uppercase; margin-bottom: 2px;">Players</span>
                        <strong style="color: white;">${playerCount}P</strong>
                    </div>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/bookStation" id="finalBookingForm" onsubmit="return validateSelection()">
                <input type="hidden" name="csrfToken"   value="${sessionScope.csrfToken}"/>
                <input type="hidden" name="stationID"    value="${stationID}" />
                <input type="hidden" name="playerCount"  value="${playerCount}" />
                <input type="hidden" name="date"         value="${selectedDate}" />

                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 15px; margin-bottom: 20px; text-align: center;">
                    <c:forEach var="hr" begin="${openingHour}" end="22">
                        <div class="role-pill">
                            <c:choose>
                                <c:when test="${bookedHours.contains(hr) or (isToday and hr <= currentHour)}">
                                    <input type="checkbox" id="slot-${hr}" disabled />
                                    <label for="slot-${hr}" style="display: flex; flex-direction: column; gap: 5px;">
                                        <span style="font-size: 1.1rem; font-weight: bold; color: white;">${hr}:00</span>
                                        <span style="font-size: 0.75rem; color: #ff3c6a; text-transform: uppercase; letter-spacing: 1px;">Unavailable</span>
                                    </label>
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="timeSlots" id="slot-${hr}" value="${hr}" />
                                    <label for="slot-${hr}" style="display: flex; flex-direction: column; gap: 5px;">
                                        <span style="font-size: 1.1rem; font-weight: bold; color: white;">${hr}:00</span>
                                        <span style="font-size: 0.75rem; color: var(--neon-cyan); text-transform: uppercase; letter-spacing: 1px;">Available</span>
                                    </label>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>

                <div class="form-actions" style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 16px;">
                    <button type="button" class="btn btn-outline" onclick="document.getElementById('slot-table-container').innerHTML = '';">Cancel</button>
                    <button type="submit" class="btn btn-buy">Proceed to Checkout</button>
                </div>
            </form>
        </div>
    </c:otherwise>
</c:choose>
