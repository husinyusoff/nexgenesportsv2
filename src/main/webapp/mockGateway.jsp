<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String module = request.getParameter("module");
    String id = request.getParameter("id");
    String amountStr = request.getParameter("amount");
    String reference = request.getParameter("reference");
    String deadlineStr = request.getParameter("deadlineMillis");
    
    long deadlineMillis = 0;
    if (deadlineStr != null && !deadlineStr.isBlank()) {
        try { deadlineMillis = Long.parseLong(deadlineStr); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Secure Payment Gateway</title>
  <style>
    /* 
      We should use standard styles.css, but this is an external-looking gateway 
      so we could style it independently OR use the system styles.
      Let's link the main system styles but add specific gateway rules securely.
      Wait, rule says NO embedded <style> blocks in JSP custom tags (*.tag files). 
      This is a normal *.jsp file. But to be safe and adhere strictly to Neon Void, 
      we will use standard inline Utility Classes if possible, or include a secure block.
    */
  </style>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css"/>
  <script>
    document.addEventListener("DOMContentLoaded", function() {
        var deadline = <%= deadlineMillis %>;
        if (deadline > 0) {
            function updateTimer() {
                var now = new Date().getTime();
                var remaining = deadline - now;
                var timerEl = document.getElementById("gateway-timer");
                var btn = document.getElementById("gateway-pay-btn");
                var warning = document.getElementById("gateway-warning");
                
                if (remaining <= 0) {
                    timerEl.textContent = "Payment Session Expired";
                    timerEl.style.color = "red";
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    btn.style.cursor = 'not-allowed';
                    warning.style.display = 'block';
                    warning.textContent = "Your session has expired. Please return to the merchant.";
                    return;
                }
                
                var seconds = Math.floor((remaining / 1000) % 60);
                var minutes = Math.floor((remaining / 1000 / 60));
                timerEl.textContent = "Session expires in " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                
                if (remaining < 30000) {
                    timerEl.style.color = "var(--accent)";
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    btn.style.cursor = 'not-allowed';
                    warning.style.display = 'block';
                }
            }
            updateTimer();
            setInterval(updateTimer, 1000);
        }
    });

    function toggleBankList() {
        var bankList = document.getElementById("bank-list");
        bankList.style.display = bankList.style.display === "none" ? "grid" : "none";
    }

    function selectBank(element, bankName) {
        var banks = document.querySelectorAll('.bank-option');
        banks.forEach(function(b) { b.classList.remove('selected'); });
        element.classList.add('selected');
        document.getElementById("selected-bank-name").textContent = bankName;
    }
  </script>
</head>
<body style="background-color: var(--bg-dark); color: var(--text-light); margin: 0; display: flex; align-items: center; justify-content: center; min-height: 100vh; overflow: hidden;">
    <!-- We simulate an external payment gateway screen -->
    <div class="rigid-layout-container" style="width: 100%; max-width: 500px; padding: 20px;">
        
        <div class="glass-card" style="padding: 30px; display: flex; flex-direction: column; gap: 20px;">
            <div style="text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 20px;">
                <h1 style="color: var(--primary); font-family: var(--font-heading); font-size: 24px; margin: 0 0 10px 0; text-transform: uppercase; letter-spacing: 2px;">NEXGEN PAY</h1>
                <p style="margin: 0; font-size: 14px; color: var(--text-muted); display:flex; justify-content:center; align-items:center; gap: 5px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    Secure Checkout
                </p>
                <div id="gateway-timer" style="margin-top: 15px; font-weight: bold; font-family: monospace; font-size: 16px; color: var(--text-light);">Loading timer...</div>
            </div>

            <div style="background: rgba(0,0,0,0.3); padding: 15px; border-radius: 8px; border: 1px dashed rgba(255,255,255,0.1);">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span style="color: var(--text-muted);">Merchant:</span>
                    <strong>NexGen Esports</strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span style="color: var(--text-muted);">Reference:</span>
                    <strong style="font-family: monospace;"><%= reference %></strong>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 18px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 10px; margin-top: 10px;">
                    <span>Total Amount:</span>
                    <strong style="color: var(--accent);">RM <%= amountStr %></strong>
                </div>
            </div>

            <div>
                <p style="margin: 0 0 10px 0; font-weight: 600;">Payment Method (FPX)</p>
                <div class="glass-card bank-option selected" style="padding: 10px 15px; cursor: pointer; display: flex; justify-content: space-between; align-items: center;" onclick="toggleBankList()">
                    <span id="selected-bank-name">Maybank2U</span>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </div>
                
                <div id="bank-list" style="display: none; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 10px;">
                    <div class="glass-card bank-option" style="padding: 10px; text-align: center; cursor: pointer; font-size: 14px;" onclick="selectBank(this, 'Maybank2U')">Maybank2U</div>
                    <div class="glass-card bank-option" style="padding: 10px; text-align: center; cursor: pointer; font-size: 14px;" onclick="selectBank(this, 'CIMB Clicks')">CIMB Clicks</div>
                    <div class="glass-card bank-option" style="padding: 10px; text-align: center; cursor: pointer; font-size: 14px;" onclick="selectBank(this, 'Public Bank')">Public Bank</div>
                    <div class="glass-card bank-option" style="padding: 10px; text-align: center; cursor: pointer; font-size: 14px;" onclick="selectBank(this, 'RHB Now')">RHB Now</div>
                </div>
            </div>

            <p id="gateway-warning" style="display: none; color: var(--accent); font-size: 13px; text-align: center; font-weight: bold; margin: 0;">
                Transaction processing locked. Too close to expiry.
            </p>

            <div style="display: flex; gap: 10px; margin-top: 10px;">
                <form action="${pageContext.request.contextPath}/paymentCallback" method="get" style="flex: 1;">
                    <input type="hidden" name="module" value="<%= module %>" />
                    <input type="hidden" name="id" value="<%= id %>" />
                    <input type="hidden" name="reference" value="<%= reference %>" />
                    <input type="hidden" name="paid" value="false" />
                    <button type="submit" class="danger-btn" style="width: 100%; padding: 12px; background: transparent; border: 1px solid var(--accent); color: var(--accent);">Cancel</button>
                </form>
                <form action="${pageContext.request.contextPath}/paymentCallback" method="get" style="flex: 2;">
                    <input type="hidden" name="module" value="<%= module %>" />
                    <input type="hidden" name="id" value="<%= id %>" />
                    <input type="hidden" name="reference" value="<%= reference %>" />
                    <input type="hidden" name="paid" value="true" />
                    <button type="submit" id="gateway-pay-btn" class="primary-btn pulse" style="width: 100%; padding: 12px; font-weight: bold;">Simulate Payment</button>
                </form>
            </div>
            
            <p style="text-align: center; font-size: 11px; color: var(--text-muted); margin-top: 10px;">
                This is a simulated gateway. No real transaction will occur.
            </p>
        </div>
    </div>

    <!-- Gateway specific styles injected securely below the main styles -->
    <style>
        .bank-option {
            transition: all 0.2s ease;
            background: rgba(255,255,255,0.02);
            border: 1px solid rgba(255,255,255,0.05);
        }
        .bank-option:hover {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.2);
        }
        .bank-option.selected {
            background: rgba(0, 243, 255, 0.1);
            border-color: var(--primary);
            color: var(--primary);
            font-weight: bold;
        }
    </style>
</body>
</html>
