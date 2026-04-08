<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.time.ZoneId" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  long deadlineMillis = 0;
  if(request.getAttribute("booking") != null) {
      my.nexgenesports.model.Booking b = (my.nexgenesports.model.Booking) request.getAttribute("booking");
      if(b.getPaymentDeadline() != null) {
          deadlineMillis = b.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
      }
  } else if(request.getAttribute("ucm") != null) {
      my.nexgenesports.model.UserClubMembership m = (my.nexgenesports.model.UserClubMembership) request.getAttribute("ucm");
      if(m.getPaymentDeadline() != null) {
          deadlineMillis = m.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
      }
  } else if(request.getAttribute("ugp") != null) {
      my.nexgenesports.model.UserGamingPass p = (my.nexgenesports.model.UserGamingPass) request.getAttribute("ugp");
      if(p.getPaymentDeadline() != null) {
          deadlineMillis = p.getPaymentDeadline().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
      }
  } else if(request.getAttribute("deadlineMillis") != null) {
      deadlineMillis = (Long) request.getAttribute("deadlineMillis");
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css"/>
  <script>
    document.addEventListener("DOMContentLoaded", function() {
        var deadline = <%= deadlineMillis %>;
        if (deadline > 0) {
            function updateTimer() {
                var now = new Date().getTime();
                var remaining = deadline - now;
                var display = document.getElementById("timer-display");
                var btn = document.getElementById("pay-btn");
                var blockMsg = document.getElementById("pay-blocked-msg");
                
                if (remaining <= 0) {
                    display.textContent = "Expired. Please refresh.";
                    btn.disabled = true;
                    return;
                }
                
                var seconds = Math.floor((remaining / 1000) % 60);
                var minutes = Math.floor((remaining / 1000 / 60));
                
                display.textContent = "Time to pay: " + minutes + "m " + seconds + "s";
                
                if (remaining < 30000) {
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    blockMsg.style.display = 'block';
                } else {
                    btn.disabled = false;
                    btn.style.opacity = '1';
                    blockMsg.style.display = 'none';
                }
            }
            updateTimer();
            setInterval(updateTimer, 1000);
        }
    });
  </script>
</head>
<body class="checkout-page">
  <jsp:include page="/header.jsp"/>
  <div class="container">
    <div class="sidebar">
      <jsp:include page="/sidebar.jsp"/>
    </div>
    <div class="content">
      <div class="checkout-box">
        <h2>Checkout</h2>

        <c:choose>
          <c:when test="${not empty booking}">
            <p><strong>Station:</strong> ${booking.stationID}</p>
            <p><strong>Date:</strong> ${booking.date}</p>
            <p><strong>Time:</strong> ${booking.startTime} – ${booking.endTime}</p>
            <p><strong>Players:</strong> ${booking.playerCount}</p>
            <p><strong>Total:</strong> RM<fmt:formatNumber value="${booking.price}" minFractionDigits="2"/></p>
          </c:when>
          <c:when test="${not empty ucm}">
            <p><strong>Membership:</strong> ${ucm.session.sessionName}</p>
            <p><strong>Fee:</strong> RM<fmt:formatNumber value="${amount}" minFractionDigits="2"/></p>
          </c:when>
          <c:when test="${not empty ugp}">
            <p><strong>Pass Tier:</strong> ${ugp.tier.tierName}</p>
            <p><strong>Price:</strong> RM<fmt:formatNumber value="${amount}" minFractionDigits="2"/></p>
          </c:when>
          <c:when test="${not empty users}">
            <p><strong>${program.programType == 'TOURNAMENT' ? 'Tournament' : 'Program'}:</strong> ${program.programName}</p>
            <p><strong>Registration Fee:</strong> RM<fmt:formatNumber value="${amount}" minFractionDigits="2"/></p>
            <c:if test="${not isSolo}">
              <p><strong>Team ID:</strong> ${teamId}</p>
            </c:if>
            <c:if test="${not isSolo}">
              <p><strong>Main Players:</strong> 
                <c:forEach var="u" items="${users}" varStatus="st">
                  <c:if test="${roles[st.index] == 'MAIN'}">
                    ${u}<c:if test="${!st.last}">, </c:if>
                  </c:if>
                </c:forEach>
              </p>
              <p><strong>Sub Players:</strong> 
                <c:forEach var="u" items="${users}" varStatus="st">
                  <c:if test="${roles[st.index] == 'SUB'}">
                    ${u}<c:if test="${!st.last}">, </c:if>
                  </c:if>
                </c:forEach>
              </p>
            </c:if>
          </c:when>
          <c:otherwise>
            <div class="error">Nothing to checkout.</div>
          </c:otherwise>
        </c:choose>

        <div style="margin: 15px 0;">
            <span class="timer-warning" id="timer-display" style="font-weight: bold; color: var(--accent);"></span>
        </div>

        <form action="${pageContext.request.contextPath}/redirectToPayment" method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

          <c:if test="${not empty booking}">
            <input type="hidden" name="bookingID" value="${booking.bookingID}"/>
            <input type="hidden" name="module"    value="booking"/>
          </c:if>

          <c:if test="${not empty ucm}">
            <input type="hidden" name="ucmId" value="${ucm.id}"/>
            <input type="hidden" name="module" value="membership"/>
            <input type="hidden" name="fee"    value="${amount}"/>
          </c:if>

          <c:if test="${not empty ugp}">
            <input type="hidden" name="ugpId" value="${ugp.id}"/>
            <input type="hidden" name="module" value="pass"/>
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

          <button type="submit" class="btn-submit pulse" id="pay-btn">
            <c:choose>
              <c:when test="${not empty users}">
                Pay &amp; Register
              </c:when>
              <c:otherwise>
                Pay Now
              </c:otherwise>
            </c:choose>
          </button>
        </form>

        <p class="error-msg" id="pay-blocked-msg" style="display:none; color:red; font-size:12px; margin-top:10px;">
            Payment blocked/paused because you do not have enough time to pay (less than 30 seconds). The slot will be released shortly.
        </p>

        <c:choose>
          <c:when test="${not empty booking}">
            <a href="${pageContext.request.contextPath}/manageBooking" class="btn-back">Cancel</a>
          </c:when>
          <c:when test="${not empty ucm || not empty ugp}">
            <a href="${pageContext.request.contextPath}/manageMembership" class="btn-back">Cancel</a>
          </c:when>
          <c:when test="${not empty users}">
            <a href="${pageContext.request.contextPath}/programs" class="btn-back">Cancel</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn-back">Cancel</a>
          </c:otherwise>
        </c:choose>

      </div>
    </div>
  </div>
  <jsp:include page="/footer.jsp"/>
</body>
</html>
