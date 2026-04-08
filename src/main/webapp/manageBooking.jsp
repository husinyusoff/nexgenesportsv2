<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bookings – NexGen Esports</title>
</head>
<body class="app-wrapper">
  <jsp:include page="header.jsp"/>

  <div class="main-container">
    <jsp:include page="sidebar.jsp"/>
    
    <main class="content">
      <div class="module-header">
        <h2>🎮 My Bookings</h2>
        <a href="${pageContext.request.contextPath}/selectStation" class="btn btn-primary">+ Book a Station</a>
      </div>

      <div class="glass-card">
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Station</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
              <th>Payment</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <%
              java.util.List<my.nexgenesports.model.Booking> bks = (java.util.List<my.nexgenesports.model.Booking>) request.getAttribute("bookings");
              java.util.Map<Integer, Long> deadlineMap = new java.util.HashMap<>();
              if(bks != null) {
                  for(my.nexgenesports.model.Booking bk : bks) {
                      if("PENDING".equals(bk.getPaymentStatus()) && bk.getPaymentDeadline() != null) {
                          deadlineMap.put(bk.getBookingID(), bk.getPaymentDeadline().atZone(java.time.ZoneId.systemDefault()).toInstant().toEpochMilli());
                      }
                  }
              }
              request.setAttribute("deadlineMap", deadlineMap);
            %>
            <c:forEach var="b" items="${bookings}">
              <tr>
                <td data-label="ID">${b.bookingID}</td>
                <td data-label="Station">${b.stationID}</td>
                <td data-label="Date">${b.date}</td>
                <td data-label="Time">${b.startTime} - ${b.endTime}</td>
                <td data-label="Status">${b.status}</td>
                <td data-label="Payment">
                    <c:choose>
                        <c:when test="${b.paymentStatus == 'PENDING'}">
                            <span class="timer-pill badge-warning" id="pill-${b.bookingID}" data-deadline="${deadlineMap[b.bookingID]}">Calculating...</span>
                        </c:when>
                        <c:otherwise>${b.paymentStatus}</c:otherwise>
                    </c:choose>
                </td>
                <td class="table-actions">
                  <button class="btn btn-primary view-btn" style="font-size:0.8rem;" 
                     data-id="${b.bookingID}"
                     data-station="${b.stationID}"
                     data-date="${b.date}"
                     data-time="${b.startTime} - ${b.endTime}"
                     data-price="${b.price}"
                     data-status="${b.paymentStatus}"
                     data-pillid="pill-${b.bookingID}">
                    View
                  </button>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </main>
  </div>
  
  <div id="bookingModal" class="modal-overlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px); z-index:1000;">
      <div class="modal-content glass-card" style="position:relative; width:90%; max-width: 400px; margin: 10% auto; padding: 30px;">
          <span id="closeModal" style="position:absolute; top:15px; right:20px; cursor:pointer; font-size:24px; color: var(--text-muted);">&times;</span>
          <h2>Booking Details</h2>
          <p><strong>Booking ID:</strong> <span id="m-bid"></span></p>
          <p><strong>Station ID:</strong> <span id="m-station"></span></p>
          <p><strong>Date & Time:</strong> <span id="m-datetime"></span></p>
          <p><strong>Price:</strong> RM <span id="m-price"></span></p>
          <p><strong>Status:</strong> <span id="m-status"></span></p>
          
          <div id="m-pending-section" style="display:none; margin-top:20px; border-top:1px solid rgba(255, 255, 255, 0.1); padding-top:15px;">
              <p style="color:var(--accent); font-weight:bold;">Time Remaining: <span id="m-timer"></span></p>
              <form action="${pageContext.request.contextPath}/checkout.jsp" method="get" id="m-pay-form">
                  <input type="hidden" name="bookingID" id="m-bid-input" value=""/>
                  <button type="submit" id="m-pay-btn" class="btn btn-primary pulse" style="width:100%; margin-bottom:10px;">Pay Now</button>
              </form>
              <p id="m-pay-warning" style="display:none; color:red; font-size:12px;">Payment blocked/paused because you do not have enough time to pay (less than 30 seconds). The slot will be released shortly.</p>
          </div>
      </div>
  </div>

  <jsp:include page="footer.jsp"/>
  <script>
    document.addEventListener("DOMContentLoaded", function() {
        var pills = document.querySelectorAll('.timer-pill');
        var intervals = {};
        
        pills.forEach(function(pill) {
            var dl = parseInt(pill.getAttribute('data-deadline'), 10);
            if(isNaN(dl) || dl <= 0) return;
            
            function update() {
                var now = new Date().getTime();
                var remaining = dl - now;
                if(remaining <= 0) {
                    pill.textContent = "EXPIRED";
                    pill.style.color = "red";
                    clearInterval(intervals[pill.id]);
                } else {
                    var s = Math.floor((remaining / 1000) % 60);
                    var m = Math.floor((remaining / 1000 / 60));
                    pill.textContent = m + "m " + s + "s";
                    pill.setAttribute('data-remaining', remaining);
                }
            }
            update();
            intervals[pill.id] = setInterval(update, 1000);
        });
        
        var modal = document.getElementById('bookingModal');
        var activePillId = null;
        var modalInterval = null;
        
        document.querySelectorAll('.view-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                document.getElementById('m-bid').textContent = btn.getAttribute('data-id');
                document.getElementById('m-station').textContent = btn.getAttribute('data-station');
                document.getElementById('m-datetime').textContent = btn.getAttribute('data-date') + " " + btn.getAttribute('data-time');
                document.getElementById('m-price').textContent = btn.getAttribute('data-price');
                document.getElementById('m-status').textContent = btn.getAttribute('data-status');
                
                var status = btn.getAttribute('data-status');
                if(status === 'PENDING') {
                    document.getElementById('m-pending-section').style.display = 'block';
                    document.getElementById('m-bid-input').value = btn.getAttribute('data-id');
                    
                    activePillId = btn.getAttribute('data-pillid');
                    
                    if(modalInterval) clearInterval(modalInterval);
                    modalInterval = setInterval(function() {
                        var pill = document.getElementById(activePillId);
                        var remaining = parseInt(pill.getAttribute('data-remaining'), 10);
                        document.getElementById('m-timer').textContent = pill.textContent;
                        var pbtn = document.getElementById('m-pay-btn');
                        var warn = document.getElementById('m-pay-warning');
                        
                        if(remaining < 30000) {
                            pbtn.disabled = true;
                            pbtn.style.opacity = '0.5';
                            warn.style.display = 'block';
                        } else {
                            pbtn.disabled = false;
                            pbtn.style.opacity = '1';
                            warn.style.display = 'none';
                        }
                    }, 500);
                } else {
                    document.getElementById('m-pending-section').style.display = 'none';
                }
                
                modal.style.display = 'block';
            });
        });
        
        document.getElementById('closeModal').addEventListener('click', function() {
            modal.style.display = 'none';
            if(modalInterval) clearInterval(modalInterval);
        });
        
        var payForm = document.getElementById('m-pay-form');
        payForm.addEventListener('submit', function(e) {
            if(activePillId) {
                var pill = document.getElementById(activePillId);
                var remaining = parseInt(pill.getAttribute('data-remaining'), 10);
                if(remaining < 30000) {
                    e.preventDefault();
                    alert("Payment blocked/paused because you do not have enough time to pay (less than 30 seconds). The slot will be released shortly.");
                }
            }
        });
    });
  </script>
</body>
</html>
