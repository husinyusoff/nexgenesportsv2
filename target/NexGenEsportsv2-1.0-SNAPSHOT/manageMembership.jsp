<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Membership &amp; Pass – NexGen Esports</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body class="manage-membership-page">
  <!-- Header -->
  <jsp:include page="header.jsp"/>

  <!-- ☰ open-sidebar -->
  <button id="openToggle" class="open-toggle">☰</button>

  <div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
      <button id="closeToggle" class="close-toggle">×</button>
      <jsp:include page="sidebar.jsp"/>
    </div>

    <!-- Main content -->
    <div class="content">
      <div class="card">
        <div class="card-header">
          <h1>Manage Membership &amp; Pass</h1>
        </div>

        <!-- Summary Table -->
        <table class="summary-table">
          <thead>
            <tr>
              <th>Type</th>
              <th>Tier / Session</th>
              <th>Price (RM)</th>
              <th>Purchased</th>
              <th>Expires</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <!-- Club Membership Row -->
            <tr>
              <td>Club Membership</td>
              <td>
                <c:out value="${not empty currentMembership 
                         ? currentMembership.session.sessionName 
                         : '-'}"/>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty currentMembership}">
                    RM<fmt:formatNumber 
                         value="${currentMembership.session.fee}" 
                         type="number" minFractionDigits="2"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:out value="${not empty currentMembership 
                  ? currentMembership.purchaseDate 
                  : '-'}"/>
              </td>
              <td>
                <c:out value="${not empty currentMembership 
                  ? currentMembership.expiryDate 
                  : '-'}"/>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty currentMembership 
                                and today ge currentMembership.session.startMembershipDate}">
                    <form action="${pageContext.request.contextPath}/checkout" method="get">
                      <input type="hidden" name="type"      value="membership"/>
                      <input type="hidden" name="sessionId" value="${upcomingSessions[0].sessionId}"/>
                      <button class="btn-renew">Renew</button>
                    </form>
                  </c:when>
                  <c:otherwise>
                    <form action="${pageContext.request.contextPath}/checkout" method="get">
                      <input type="hidden" name="type"      value="membership"/>
                      <input type="hidden" name="sessionId" value="${upcomingSessions[0].sessionId}"/>
                      <button class="btn-buy">Buy Now</button>
                    </form>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>

            <!-- Monthly Gaming Pass Row -->
            <tr>
              <td>Monthly Gaming Pass</td>
              <td>
                <c:out value="${not empty currentPass 
                         ? currentPass.tier.tierName 
                         : '-'}"/>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty currentPass}">
                    RM<fmt:formatNumber 
                         value="${currentPass.tier.price}" 
                         type="number" minFractionDigits="2"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:out value="${not empty currentPass 
                  ? currentPass.purchaseDate 
                  : '-'}"/>
              </td>
              <td>
                <c:out value="${not empty currentPass 
                  ? currentPass.expiryDate 
                  : '-'}"/>
              </td>
              <td>
                <c:choose>
                  <c:when test="${empty currentPass or today ge currentPass.expiryDate}">
                    <form action="${pageContext.request.contextPath}/checkout" method="get">
                      <input type="hidden" name="type"   value="pass"/>
                      <input type="hidden" name="tierId" 
                        value="${empty currentPass 
                          ? passTiers[0].tierId 
                          : currentPass.tier.tierId}"/>
                      <button class="${empty currentPass ? 'btn-buy' : 'btn-renew'}">
                        <c:out value="${empty currentPass ? 'Buy' : 'Renew'}"/>
                      </button>
                    </form>
                  </c:when>
                  <c:otherwise>
                    <button class="btn-renew" disabled>Active</button>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <jsp:include page="footer.jsp"/>

  <!-- Sidebar toggle script -->
  <script>
    document.getElementById('openToggle').addEventListener('click', () =>
      document.body.classList.remove('sidebar-collapsed')
    );
    document.getElementById('closeToggle').addEventListener('click', () =>
      document.body.classList.add('sidebar-collapsed')
    );
  </script>
</body>
</html>
