<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.time.ZoneId" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  long membershipDeadline = 0;
  my.nexgenesports.model.UserClubMembership cm = (my.nexgenesports.model.UserClubMembership) request.getAttribute("currentMembership");
  if(cm != null && "PENDING".equals(cm.getStatus()) && cm.getPaymentDeadline() != null) {
      membershipDeadline = cm.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
  }
  
  long passDeadline = 0;
  my.nexgenesports.model.UserGamingPass cp = (my.nexgenesports.model.UserGamingPass) request.getAttribute("currentPass");
  if(cp != null && "PENDING".equals(cp.getStatus()) && cp.getPaymentDeadline() != null) {
      passDeadline = cp.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Membership &amp; Pass – NexGen Esports</title>
</head>
<body class="app-wrapper manage-membership-page">

  <jsp:include page="header.jsp"/>

  <div class="main-container">
    <jsp:include page="sidebar.jsp"/>

    <main class="content">
      <div class="glass-card main-dashboard-card">
        <div class="module-header" style="display:flex; flex-direction:column; align-items:center; margin-bottom: 20px;">
          <h2>My Memberships & Passes</h2>
          <p class="subtitle" style="margin-top: 10px;">Elevate your game with our premium tiers.</p>
        </div>

        <div class="tab-switcher">
          <div id="lbl-club" class="tab-label active" data-tab="club">Club Membership</div>
          <div id="lbl-pass" class="tab-label" data-tab="pass">Gaming Passes</div>
        </div>

        <!-- CLUB MEMBERSHIP -->
        <div id="panel-club" class="panel active">
          <div class="pricing-cards">
            <div class="pricing-card premium-card">
              <div class="card-badge">Yearly Access</div>
              <h2>NexGen Club Membership</h2>
              <div class="price">
                <span class="currency">RM</span>
                <span class="amount"><fmt:formatNumber value="${activeSession.fee}" type="number" minFractionDigits="0"/></span>
              </div>
              <p class="tier-desc">Unlock massive exclusive benefits and tournament access for the entire season.</p>

              <c:if test="${currentMembership != null}">
                <div class="status-box ${currentMembership.status == 'ACTIVE' ? 'status-active' : 'status-expired'}">
                  <strong>Status:</strong> ${currentMembership.status} <br>
                  <strong>Expires:</strong> ${fn:replace(currentMembership.expiryDate, 'T', ' ')}
                </div>
              </c:if>

              <ul class="benefit-list">
                <c:forEach var="b" items="${clubBenefits}">
                  <li><span class="check-icon">✓</span> <c:out value="${b.benefitText}"/></li>
                </c:forEach>
              </ul>

              <div class="card-actions">
                <c:choose>
                    <c:when test="${currentMembership != null && currentMembership.status == 'ACTIVE'}">
                        <button class="btn-renew disabled" disabled>Active</button>
                    </c:when>
                    <c:when test="${currentMembership != null && currentMembership.status == 'EXPIRED'}">
                        <form action="${pageContext.request.contextPath}/payMembership" method="get">
                            <input type="hidden" name="sessionId" value="${activeSession.sessionId}"/>
                            <button class="btn-renew pulse">Renew Membership</button>
                        </form>
                    </c:when>
                    <c:when test="${currentMembership != null && currentMembership.status == 'PENDING'}">
                      <div class="pending-payment-container">
                          <span class="timer-warning badge-warning" id="club-timer-display" style="display: inline-block; margin-bottom: 15px;">Calculating...</span>
                          <form action="${pageContext.request.contextPath}/payMembership" method="get" id="club-pay-btn-form">
                              <input type="hidden" name="sessionId" value="${activeSession.sessionId}"/>
                              <button class="btn-primary pulse" id="club-pay-btn" style="width: 100%;">Pay Now</button>
                          </form>
                          <p class="error-msg" id="club-pay-blocked" style="display:none; color:red; font-size:12px; margin-top:10px;">
                              Payment blocked/paused because you do not have enough time to pay (less than 30 seconds). The slot will be released shortly.
                          </p>
                      </div>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/payMembership" method="get">
                            <input type="hidden" name="sessionId" value="${activeSession.sessionId}"/>
                            <button class="btn-buy pulse">Buy Membership</button>
                        </form>
                    </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>

        <!-- GAMING PASSES -->
        <div id="panel-pass" class="panel">
          <c:if test="${currentPass != null}">
             <div class="current-pass-banner ${currentPass.status == 'ACTIVE' ? 'banner-active' : 'banner-expired'}">
                <h3>My Current Pass: <span>${currentPass.tier.tierName}</span> (Status: ${currentPass.status})</h3>
                <p>Expires: ${fn:replace(currentPass.expiryDate, 'T', ' ')}</p>
             </div>
          </c:if>

          <div class="pricing-cards">
            <c:forEach var="tier" items="${passTiers}">
              <div class="pricing-card tier-${tier.tierId}">
                <h2><c:out value="${tier.tierName}"/></h2>
                <div class="price">
                  <span class="currency">RM</span>
                  <span class="amount"><fmt:formatNumber value="${tier.price}" type="number" minFractionDigits="0"/></span>
                  <span class="period">/mo</span>
                </div>

                <ul class="benefit-list data-driven">
                  <c:forEach var="bf" items="${passBenefitsMap[tier.tierId]}">
                    <c:set var="v" value="${bf.benefitText}" />
                    <c:set var="isNo" value="${v == 'X' || v == '?' || v == 'None'}" />
                    <li class="${isNo ? 'disabled-benefit' : 'active-benefit'}">
                      <span class="benefit-name"><c:out value="${bf.benefitName}"/>:</span>
                      <span class="benefit-value"><c:out value="${isNo ? 'No' : v}"/></span>
                    </li>
                  </c:forEach>
                </ul>

                  <div class="card-actions">
                    <c:choose>
                      <c:when test="${currentPass == null}">
                        <form action="${pageContext.request.contextPath}/payPass" method="get">
                          <input type="hidden" name="tierId" value="${tier.tierId}"/>
                          <button class="btn-buy">Buy Plan</button>
                        </form>
                      </c:when>

                      <c:when test="${currentPass.status == 'EXPIRED' && tier.tierId == currentPass.tier.tierId}">
                        <form action="${pageContext.request.contextPath}/payPass" method="get">
                          <input type="hidden" name="tierId" value="${tier.tierId}"/>
                          <button class="btn-renew">Renew Plan</button>
                        </form>
                      </c:when>

                      <c:when test="${currentPass.status == 'PENDING' && tier.tierId == currentPass.tier.tierId}">
                        <div class="pending-payment-container">
                            <span class="timer-warning badge-warning" id="pass-timer-display" style="display: inline-block; margin-bottom: 15px;">Calculating...</span>
                            <form action="${pageContext.request.contextPath}/payPass" method="get" id="pass-pay-btn-form">
                                <input type="hidden" name="tierId" value="${tier.tierId}"/>
                                <button class="btn-primary pulse" id="pass-pay-btn" style="width: 100%;">Pay Now</button>
                            </form>
                            <p class="error-msg" id="pass-pay-blocked" style="display:none; color:red; font-size:12px; margin-top:10px;">
                                Payment blocked/paused because you do not have enough time to pay (less than 30 seconds). The slot will be released shortly.
                            </p>
                        </div>
                      </c:when>

                      <c:when test="${currentPass.status == 'PENDING' && tier.tierId != currentPass.tier.tierId}">
                        <button class="btn-locked" disabled>Other Plan Pending</button>
                      </c:when>

                      <c:when test="${currentPass.status == 'ACTIVE'}">
                        <c:choose>
                          <c:when test="${tier.tierId == currentPass.tier.tierId}">
                            <button class="btn-current" disabled>Current Plan</button>
                          </c:when>
                          <c:when test="${tier.tierId > currentPass.tier.tierId}">
                            <form action="${pageContext.request.contextPath}/payPass" method="get">
                              <input type="hidden" name="tierId" value="${tier.tierId}"/>
                              <button class="btn-upgrade">Upgrade</button>
                            </form>
                          </c:when>
                          <c:otherwise>
                            <button class="btn-locked" disabled>Locked</button>
                          </c:otherwise>
                        </c:choose>
                      </c:when>
                      
                      <c:otherwise>
                        <button class="btn-locked" disabled>Locked</button>
                      </c:otherwise>
                    </c:choose>
                </div>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </main>
  </div>

  <jsp:include page="footer.jsp"/>
  <script>
    (function(){
      let idx    = 0,
          tabs   = ['club','pass'],
          labels = document.querySelectorAll('.tab-label');

      function update(){
        tabs.forEach((t,i)=>{
          document.getElementById('panel-'+t).classList.toggle('active', i===idx);
          labels[i].classList.toggle('active', i===idx);
        });
      }

      labels.forEach((lbl,i)=> lbl.onclick = () => { idx = i; update(); });
      update();

      // Timer Logic
      function startCountdown(deadlineMillis, displayId, btnId, blockedId, formId) {
          if (!deadlineMillis || deadlineMillis <= 0) return;
          
          function updateTimer() {
              const now = new Date().getTime();
              const remaining = deadlineMillis - now;
              
              if (remaining <= 0) {
                  document.getElementById(displayId).textContent = "Expired. Please refresh.";
                  document.getElementById(btnId).disabled = true;
                  return;
              }
              
              const seconds = Math.floor((remaining / 1000) % 60);
              const minutes = Math.floor((remaining / 1000 / 60));
              
              document.getElementById(displayId).textContent = "Time to pay: " + minutes + "m " + seconds + "s";
              
              if (remaining < 30000) {
                  document.getElementById(btnId).disabled = true;
                  document.getElementById(btnId).style.opacity = '0.5';
                  document.getElementById(blockedId).style.display = 'block';
              } else {
                  document.getElementById(btnId).disabled = false;
                  document.getElementById(btnId).style.opacity = '1';
                  document.getElementById(blockedId).style.display = 'none';
              }
          }
          
          updateTimer();
          setInterval(updateTimer, 1000);
          
          document.getElementById(formId).addEventListener('submit', function(e) {
              const now = new Date().getTime();
              if (deadlineMillis - now < 30000) {
                  e.preventDefault();
                  alert("Payment blocked/paused because you do not have enough time to pay (less than 30 seconds). The slot will be released shortly.");
              }
          });
      }
      
      // Load epoch millis for JS
      <c:if test="${currentMembership != null && currentMembership.status == 'PENDING'}">
          startCountdown(<%= membershipDeadline %>, 'club-timer-display', 'club-pay-btn', 'club-pay-blocked', 'club-pay-btn-form');
      </c:if>
      
      <c:if test="${currentPass != null && currentPass.status == 'PENDING'}">
          startCountdown(<%= passDeadline %>, 'pass-timer-display', 'pass-pay-btn', 'pass-pay-blocked', 'pass-pay-btn-form');
      </c:if>
    })();
  </script>
</body>
</html>
