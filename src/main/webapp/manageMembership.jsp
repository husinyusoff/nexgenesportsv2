<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Membership &amp; Pass – NexGen Esports</title>
  <link rel="stylesheet" href="styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="manage-membership-page">

  <jsp:include page="header.jsp"/>
  <button id="openToggle" class="open-toggle">☰</button>

  <div class="container">
    <div class="sidebar">
      <button id="closeToggle" class="close-toggle">×</button>
      <jsp:include page="sidebar.jsp"/>
    </div>

    <div class="content">
      <div class="card main-dashboard-card">
        <div class="card-header">
          <h1>My Memberships & Passes</h1>
          <p class="subtitle">Elevate your game with our premium tiers.</p>
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

                      <c:when test="${currentPass.status == 'PENDING'}">
                        <button class="btn-locked" disabled>Pending</button>
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
    </div>
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
    })();
  </script>
</body>
</html>
