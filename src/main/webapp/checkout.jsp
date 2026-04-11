<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.time.ZoneId" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
  <jsp:include page="/header.jsp"/>
  
  <main class="rigid-layout-container">
    <div class="page-hero">
      <h1 class="page-title">Secure Checkout</h1>
      <p class="page-subtitle">Review your order details and complete payment.</p>
    </div>
    
    <div class="checkout-grid">
      <!-- Left Column: Details -->
      <div class="checkout-details-card">
        <h2 style="font-family: var(--font-heading); font-size: 1.5rem; color: var(--text-primary); border-bottom: 1px solid var(--border-color); padding-bottom: 0.5rem; margin-top: 0;">Order Summary</h2>
        
        <c:choose>
          <c:when test="${not empty booking}">
            <div class="detail-row">
              <span class="detail-label">Item</span>
              <span class="detail-value">Station Booking</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Station ID</span>
              <span class="detail-value">${booking.stationID}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Date</span>
              <span class="detail-value">${booking.date}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Time</span>
              <span class="detail-value">${booking.startTime} &ndash; ${booking.endTime}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Players</span>
              <span class="detail-value">${booking.playerCount}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Price Strategy</span>
              <span class="detail-value"><span class="badge-chip">${booking.priceType}</span></span>
            </div>
          </c:when>
          
          <c:when test="${not empty ucm}">
            <div class="detail-row">
              <span class="detail-label">Item</span>
              <span class="detail-value">Club Membership Registration/Renewal</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Plan</span>
              <span class="detail-value">${ucm.session.sessionName}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Benefits</span>
              <span class="detail-value" style="color: var(--accent); font-size: 0.9rem;">Exclusive member discounts applied to future bookings.</span>
            </div>
          </c:when>

          <c:when test="${not empty ugp}">
            <div class="detail-row">
              <span class="detail-label">Item</span>
              <span class="detail-value">Gaming Pass Purchase</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Tier</span>
              <span class="detail-value">${ugp.tier.tierName}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Validity</span>
              <span class="detail-value">30 Days from Activation</span>
            </div>
          </c:when>

          <c:when test="${not empty users}">
            <div class="detail-row">
              <span class="detail-label">Item</span>
              <span class="detail-value">${program.programType == 'TOURNAMENT' ? 'Tournament Registration' : 'Program Registration'}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Event Name</span>
              <span class="detail-value">${program.programName}</span>
            </div>
            <c:if test="${not isSolo}">
              <div class="detail-row">
                <span class="detail-label">Team ID</span>
                <span class="detail-value">${teamId}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">Main Players</span>
                <span class="detail-value" style="font-size: 1rem;">
                  <c:forEach var="u" items="${users}" varStatus="st">
                    <c:if test="${roles[st.index] == 'MAIN'}">
                      <span style="display:inline-block; margin-right:8px;"><i class="fas fa-user"></i> ${u}</span>
                    </c:if>
                  </c:forEach>
                </span>
              </div>
              <div class="detail-row">
                <span class="detail-label">Sub Players</span>
                <span class="detail-value" style="font-size: 1rem;">
                  <c:forEach var="u" items="${users}" varStatus="st">
                    <c:if test="${roles[st.index] == 'SUB'}">
                      <span style="display:inline-block; margin-right:8px; color: var(--text-secondary);"><i class="fas fa-user-friends"></i> ${u}</span>
                    </c:if>
                  </c:forEach>
                </span>
              </div>
            </c:if>
          </c:when>
          
          <c:otherwise>
            <div class="error-state">Nothing to checkout.</div>
          </c:otherwise>
        </c:choose>
      </div>
      
      <!-- Right Column: Receipt Breakdown & Actions -->
      <div class="checkout-receipt-card">
        <h2 style="font-family: var(--font-heading); font-size: 1.2rem; color: var(--text-primary); margin-top: 0; text-transform: uppercase;">Payment Summary</h2>
        
        <c:choose>
            <c:when test="${not empty pricing}">
                <!-- Booking / Tournament uses PricingEngine -->
                <div>
                   <div class="receipt-line">
                       <span>Subtotal</span>
                       <span>RM <fmt:formatNumber value="${pricing.originalPrice}" minFractionDigits="2"/></span>
                   </div>
                   
                   <c:if test="${pricing.membershipDiscountAmount.doubleValue() > 0}">
                       <div class="receipt-line discount">
                           <span>Club Discount (${activeMem.session.discountRate}%)</span>
                           <span>- RM <fmt:formatNumber value="${pricing.membershipDiscountAmount}" minFractionDigits="2"/></span>
                       </div>
                   </c:if>
                   
                   <c:if test="${pricing.passDiscountAmount.doubleValue() > 0}">
                       <div class="receipt-line discount">
                           <span>Pass Discount (${activePass.tier.discountRate}%)</span>
                           <span>- RM <fmt:formatNumber value="${pricing.passDiscountAmount}" minFractionDigits="2"/></span>
                       </div>
                   </c:if>
                </div>
                <div class="receipt-divider"></div>
                <div class="receipt-total">
                   <span>Total</span>
                   <span style="color: var(--accent);">RM <fmt:formatNumber value="${pricing.finalPrice}" minFractionDigits="2"/></span>
                </div>
            </c:when>
            
            <c:when test="${not empty amount}">
                <!-- Memberships / Passes are purely fixed amount -->
                <div>
                   <div class="receipt-line">
                       <span>Subtotal</span>
                       <span>RM <fmt:formatNumber value="${amount}" minFractionDigits="2"/></span>
                   </div>
                </div>
                <div class="receipt-divider"></div>
                <div class="receipt-total">
                   <span>Total</span>
                   <span style="color: var(--accent);">RM <fmt:formatNumber value="${amount}" minFractionDigits="2"/></span>
                </div>
            </c:when>
        </c:choose>
        
        <div style="margin-top: 1rem;">
            <form action="${pageContext.request.contextPath}/redirectToPayment" method="post" style="display: flex; flex-direction: column; gap: 1rem;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
    
              <c:if test="${not empty booking}">
                <input type="hidden" name="module"      value="booking"/>
                <input type="hidden" name="stationID"   value="${booking.stationID}"/>
                <input type="hidden" name="date"        value="${booking.date}"/>
                <input type="hidden" name="playerCount" value="${booking.playerCount}"/>
                <input type="hidden" name="priceType"   value="${booking.priceType}"/>
                <c:forEach var="slot" items="${slots}">
                   <input type="hidden" name="slots" value="${slot}"/>
                </c:forEach>
              </c:if>
    
              <c:if test="${not empty ucm}">
                <input type="hidden" name="module"    value="membership"/>
                <input type="hidden" name="sessionId" value="${ucm.session.sessionId}"/>
                <input type="hidden" name="fee"       value="${amount}"/>
              </c:if>
    
              <c:if test="${not empty ugp}">
                <input type="hidden" name="module" value="pass"/>
                <input type="hidden" name="tierId" value="${ugp.tier.tierId}"/>
                <input type="hidden" name="price"  value="${amount}"/>
              </c:if>
    
              <c:if test="${not empty users}">
                <input type="hidden" name="progId" value="${program.progId}"/>
                <input type="hidden" name="module" value="${program.programType == 'TOURNAMENT' ? 'tournament' : 'program'}"/>
    
                <c:if test="${not isSolo}">
                  <input type="hidden" name="teamId" value="${teamId}"/>
                </c:if>
    
                <c:forEach var="i" begin="0" end="${users.size() - 1}">
                  <input type="hidden" name="user" value="${users[i]}"/>
                  <input type="hidden" name="role" value="${roles[i]}"/>
                </c:forEach>
              </c:if>
    
              <button type="submit" class="btn-primary" style="width: 100%; text-align: center;">
                <c:choose>
                  <c:when test="${not empty users}">
                    Confirm &amp; Pay
                  </c:when>
                  <c:otherwise>
                    Confirm &amp; Pay
                  </c:otherwise>
                </c:choose>
              </button>
            </form>
            
            <div style="margin-top: 1rem; text-align: center;">
              <c:choose>
                <c:when test="${not empty booking}">
                  <a href="${pageContext.request.contextPath}/manageBooking" style="color: var(--text-secondary); text-decoration: none; font-size: 0.9rem;">Cancel</a>
                </c:when>
                <c:when test="${not empty ucm || not empty ugp}">
                  <a href="${pageContext.request.contextPath}/manageMembership" style="color: var(--text-secondary); text-decoration: none; font-size: 0.9rem;">Cancel</a>
                </c:when>
                <c:when test="${not empty users}">
                  <a href="${pageContext.request.contextPath}/programs" style="color: var(--text-secondary); text-decoration: none; font-size: 0.9rem;">Cancel</a>
                </c:when>
                <c:otherwise>
                  <a href="${pageContext.request.contextPath}/dashboard.jsp" style="color: var(--text-secondary); text-decoration: none; font-size: 0.9rem;">Cancel</a>
                </c:otherwise>
              </c:choose>
            </div>
        </div>
      </div>
    </div>
  </main>
  
  <jsp:include page="/footer.jsp"/>
  
  <!-- Add Font Awesome if not included already down the hierarchy, though usually header imports styles -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</body>
</html>
