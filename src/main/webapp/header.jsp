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
                <%-- Single SVG: 3 paths morph between panel-chevron and staggered bars via CSS d property --%>
                <svg class="toggle-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path class="t-a" d="M 3,3 L 3,21"/>
                    <path class="t-b" d="M 14,7 L 9,12"/>
                    <path class="t-c" d="M 9,12 L 14,17"/>
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
