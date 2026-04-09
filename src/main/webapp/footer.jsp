<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>

<div class="footer">
  © NexGen Esports 2025 All Rights Reserved.
</div>

<c:if test="${not empty sessionScope.username}">
    <t:Modal id="sessionTimeoutModal" title="Session Expires Soon">
        <p style="color: var(--text-muted); margin-bottom: 20px; font-family: var(--font-main);">Your session will expire in 2 minutes due to inactivity.</p>
        <div style="display: flex; justify-content: flex-end;">
            <button type="button" class="btn-primary" onclick="keepSessionAlive(); return false;" style="padding: 10px 20px; border-radius: 8px;">Stay Logged In</button>
        </div>
    </t:Modal>
    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let warningTimer;
            let expireTimer;
            
            // 28 mins warning, 30 mins expire
            const WARNING_TIME = 28 * 60 * 1000;
            const EXPIRE_TIME = 30 * 60 * 1000;
            
            function startTimers() {
                clearTimeout(warningTimer);
                clearTimeout(expireTimer);
                warningTimer = setTimeout(showTimeoutWarning, WARNING_TIME);
                expireTimer = setTimeout(logoutDueToTimeout, EXPIRE_TIME);
            }
            
            function showTimeoutWarning() {
                const modal = document.getElementById('sessionTimeoutModal');
                if(modal) modal.classList.add('active');
            }
            
            function logoutDueToTimeout() {
                window.location.href = '${pageContext.request.contextPath}/login.jsp?status=sessionExpired';
            }
            
            window.keepSessionAlive = function() {
                fetch('${pageContext.request.contextPath}/keepalive', { method: 'POST' })
                .then(response => {
                    if(response.ok) {
                        const modal = document.getElementById('sessionTimeoutModal');
                        if(modal) modal.classList.remove('active');
                        startTimers();
                    } else {
                        logoutDueToTimeout();
                    }
                })
                .catch(e => { console.error('Keepalive error:', e); logoutDueToTimeout(); });
            };
            
            startTimers();
        });
    </script>
</c:if>
