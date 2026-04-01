<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css"/>
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

          <button type="submit" class="btn-submit">
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
