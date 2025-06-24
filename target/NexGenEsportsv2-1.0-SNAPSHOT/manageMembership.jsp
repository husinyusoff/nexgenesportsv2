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
      <div class="card">

        <div class="card-header">
          <h1>Manage Membership &amp; Pass</h1>
        </div>

        <!-- SUMMARY TABLE -->
        <table class="summary-table">
          <thead>
            <tr>
              <th>Type</th>
              <th>Tier / Session</th>
              <th>Price (RM)</th>
              <th>Purchased</th>
              <th>Expires</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Club Membership</td>
              <td><c:out value="${currentMembership != null ? currentMembership.session.sessionName : '-'}"/></td>
              <td>
                <c:choose>
                  <c:when test="${currentMembership != null}">
                    RM<fmt:formatNumber value="${currentMembership.session.fee}" minFractionDigits="2"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${currentMembership != null}">
                    <c:out value="${fn:replace(currentMembership.purchaseDate, 'T', ' ')}"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${currentMembership != null}">
                    <c:out value="${fn:replace(currentMembership.expiryDate, 'T', ' ')}"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td><c:out value="${currentMembership != null ? currentMembership.status : '-'}"/></td>
            </tr>
            <tr>
              <td>Monthly Gaming Pass</td>
              <td><c:out value="${currentPass != null ? currentPass.tier.tierName : '-'}"/></td>
              <td>
                <c:choose>
                  <c:when test="${currentPass != null}">
                    RM<fmt:formatNumber value="${currentPass.tier.price}" minFractionDigits="2"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${currentPass != null}">
                    <c:out value="${fn:replace(currentPass.purchaseDate, 'T', ' ')}"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${currentPass != null}">
                    <c:out value="${fn:replace(currentPass.expiryDate, 'T', ' ')}"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td><c:out value="${currentPass != null ? currentPass.status : '-'}"/></td>
            </tr>
          </tbody>
        </table>

        <!-- TAB SWITCHER -->
        <div class="tab-switcher">
          <div id="prev" class="tab-btn">&lt;</div>
          <div id="lbl-club" class="tab-label active" data-tab="club">Club Membership</div>
          <div id="lbl-pass" class="tab-label" data-tab="pass">Gaming Pass</div>
          <div id="next" class="tab-btn">&gt;</div>
        </div>

        <!-- CLUB BENEFITS PANEL -->
        <div id="panel-club" class="panel active">
          <table class="benefits-table club">
            <thead>
              <tr><th>#</th><th>Benefit</th></tr>
            </thead>
            <tbody>
              <c:forEach var="b" items="${clubBenefits}" varStatus="st">
                <tr>
                  <td>${st.index + 1}</td>
                  <td><c:out value="${b.benefitText}"/></td>
                </tr>
              </c:forEach>
              <tr>
                <td colspan="2" style="text-align:center">
                  <c:choose>
                    <c:when test="${currentMembership != null && currentMembership.status == 'ACTIVE'}">
                      <button class="btn-renew" disabled>Active</button>
                    </c:when>
                    <c:when test="${currentMembership != null && currentMembership.status == 'EXPIRED'}">
                      <form action="${pageContext.request.contextPath}/payMembership" method="get">
                        <input type="hidden" name="sessionId" value="${activeSession.sessionId}"/>
                        <button class="btn-renew">
                          RM<fmt:formatNumber value="${activeSession.fee}" minFractionDigits="2"/>
                        </button>
                      </form>
                    </c:when>
                    <c:otherwise>
                      <form action="${pageContext.request.contextPath}/payMembership" method="get">
                        <input type="hidden" name="sessionId" value="${activeSession.sessionId}"/>
                        <button class="btn-buy">
                          RM<fmt:formatNumber value="${activeSession.fee}" minFractionDigits="2"/>
                        </button>
                      </form>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- PASS BENEFITS PANEL -->
        <div id="panel-pass" class="panel">
          <table class="benefits-table">
            <thead>
              <tr>
                <th>#</th><th>Benefit</th>
                <c:forEach var="tier" items="${passTiers}">
                  <th><c:out value="${tier.tierName}"/></th>
                </c:forEach>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td><td>Discount Per Hour</td>
                <c:forEach var="tier" items="${passTiers}">
                  <td><c:out value="${passBenefitsMap[tier.tierId][0].benefitText}"/></td>
                </c:forEach>
              </tr>
              <tr>
                <td>2</td><td>No Booking Fees</td>
                <c:forEach var="tier" items="${passTiers}">
                  <td><c:out value="${passBenefitsMap[tier.tierId][1].benefitText}"/></td>
                </c:forEach>
              </tr>
              <tr>
                <td>3</td><td>Priority Booking</td>
                <c:forEach var="tier" items="${passTiers}">
                  <td><c:out value="${passBenefitsMap[tier.tierId][2].benefitText}"/></td>
                </c:forEach>
              </tr>
              <tr>
                <td>4</td><td>Free Hours Per Month</td>
                <c:forEach var="tier" items="${passTiers}">
                  <td><c:out value="${passBenefitsMap[tier.tierId][3].benefitText}"/></td>
                </c:forEach>
              </tr>
              <tr>
                <td>5</td><td>Friends Pass</td>
                <c:forEach var="tier" items="${passTiers}">
                  <td><c:out value="${passBenefitsMap[tier.tierId][4].benefitText}"/></td>
                </c:forEach>
              </tr>
              <tr>
                <td colspan="2"></td>
                <c:forEach var="tier" items="${passTiers}">
                  <td>
                    <c:choose>
                      <c:when test="${currentPass == null}">
                        <form action="${pageContext.request.contextPath}/payPass" method="get">
                          <input type="hidden" name="tierId" value="${tier.tierId}"/>
                          <button class="btn-buy">
                            RM<fmt:formatNumber value="${tier.price}" minFractionDigits="2"/>
                          </button>
                        </form>
                      </c:when>
                      <c:when test="${currentPass.status == 'EXPIRED' && tier.tierId == currentPass.tier.tierId}">
                        <form action="${pageContext.request.contextPath}/payPass" method="get">
                          <input type="hidden" name="tierId" value="${tier.tierId}"/>
                          <button class="btn-renew">
                            RM<fmt:formatNumber value="${tier.price}" minFractionDigits="2"/>
                          </button>
                        </form>
                      </c:when>
                      <c:when test="${currentPass.status == 'PENDING'}">
                        <button class="btn-renew" disabled>Pending</button>
                      </c:when>
                      <c:when test="${currentPass.status == 'ACTIVE'}">
                        <c:choose>
                          <c:when test="${tier.tierId == currentPass.tier.tierId}">
                            <button class="btn-renew" disabled>Current</button>
                          </c:when>
                          <c:when test="${tier.tierId > currentPass.tier.tierId}">
                            <form action="${pageContext.request.contextPath}/payPass" method="get">
                              <input type="hidden" name="tierId" value="${tier.tierId}"/>
                              <button class="btn-buy">
                                RM<fmt:formatNumber value="${tier.price}" minFractionDigits="2"/>
                              </button>
                            </form>
                          </c:when>
                          <c:otherwise>
                            <button class="btn-renew" disabled>Locked</button>
                          </c:otherwise>
                        </c:choose>
                      </c:when>
                      <c:otherwise>
                        <button class="btn-renew" disabled>Locked</button>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </c:forEach>
              </tr>
            </tbody>
          </table>
        </div>

      </div>
    </div>
  </div>

  <jsp:include page="footer.jsp"/>
  <script>
    (function(){
      let idx    = 0,
          tabs   = ['club','pass'],
          prev   = document.getElementById('prev'),
          next   = document.getElementById('next'),
          labels = document.querySelectorAll('.tab-label');
      function update(){
        tabs.forEach((t,i)=>{
          document.getElementById('panel-'+t).classList.toggle('active', i===idx);
          labels[i].classList.toggle('active', i===idx);
        });
        prev.classList.toggle('disabled', idx===0);
        next.classList.toggle('disabled', idx===tabs.length-1);
      }
      prev.onclick = () => idx>0 && --idx && update();
      next.onclick = () => idx<tabs.length-1 && ++idx && update();
      labels.forEach((lbl,i)=> lbl.onclick = () => { idx = i; update(); });
      update();
    })();
  </script>
</body>
</html>
