<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <meta name="theme-color" content="#09090b">

    <%-- FOUC Prevention: Apply sidebar state BEFORE paint so there's zero flicker on navigation --%>
    <script>
        try {
            if (localStorage.getItem('sidebar-collapsed') === 'true') {
                document.documentElement.classList.add('sidebar-collapsed');
            }
        } catch(e) {}
    </script>
</head>
<%-- interactive background canvas script --%>
<script src="${pageContext.request.contextPath}/js/bg-animation.js"></script>

<%-- shared top bar --%>
<header class="header">
    <div class="header-left">
        <%-- Animated SVG Hamburger Toggle - visible to all logged-in users --%>
        <c:if test="${not empty sessionScope.username}">
            <button id="menuToggle" class="menu-toggle" aria-label="Toggle sidebar">
                <%-- Icon shown when sidebar is OPEN: panel + double-left chevron --%>
                <svg class="toggle-icon icon-open" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="2" y="3" width="5" height="18" rx="1"/>
                    <polyline points="16 7 12 12 16 17"/>
                    <polyline points="20 7 16 12 20 17"/>
                </svg>
                <%-- Icon shown when sidebar is CLOSED: staggered gamer speed-bars --%>
                <svg class="toggle-icon icon-closed" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
                    <line x1="3" y1="6"  x2="21" y2="6"/>
                    <line x1="3" y1="12" x2="15" y2="12"/>
                    <line x1="3" y1="18" x2="9"  y2="18"/>
                </svg>
            </button>
        </c:if>
        <div class="logos">
            <img src="${pageContext.request.contextPath}/images/umt-logo.png" alt="UMT Logo">
            <img src="${pageContext.request.contextPath}/images/esports-logo.png" alt="Esports Logo">
        </div>
    </div>

    <h1>NEXGEN ESPORTS</h1>

    <div class="header-right">
        <c:if test="${not empty sessionScope.username}">
            <div class="user-avatar">
                <span>${sessionScope.username}</span>
            </div>
        </c:if>
    </div>
</header>
