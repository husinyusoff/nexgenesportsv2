<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
    <meta name="theme-color" content="#09090b">
</head>
<!-- interactive background canvas script -->
<script src="${pageContext.request.contextPath}/js/bg-animation.js"></script>

<!-- shared top bar -->
<header class="header">
    <div class="header-left">
        <!-- ☰ mobile menu toggle button, only visible on mobile via css -->
        <c:if test="${not empty sessionScope.username}">
            <button id="menuToggle" class="menu-toggle">☰</button>
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
