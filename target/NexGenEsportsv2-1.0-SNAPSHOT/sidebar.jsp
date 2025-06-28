<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List, my.nexgenesports.util.PermissionChecker" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Grab roles & context
    @SuppressWarnings(
            
    
    "unchecked")
    List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position = (String) session.getAttribute("position");

    // Compute context path and expose it for EL
    String ctx = request.getContextPath();
    request.setAttribute("ctx", ctx);

    // (If you need CSRF elsewhere)
    String csrfToken = (String) session.getAttribute("csrfToken");
%>

<nav>
    <ul>
        <!-- Dashboard -->
        <li><a href="${ctx}/dashboard">Dashboard</a></li>

        <!-- Profile dropdown -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Profile</a>
            <ul class="dropdown-content">
                <li><a href="${ctx}/manageProfile">My Profile</a></li>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/inGameProfile")) { %>
                <li><a href="${ctx}/inGameProfile">In-Game Profile</a></li>
                    <% } %>
                <li><a href="${ctx}/manageMembership">Membership &amp; Pass</a></li>
            </ul>
        </li>

        <!-- Multiplayer Lounge dropdown -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Multiplayer Lounge</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/selectStation")) { %>
                <li><a href="${ctx}/selectStation">Book Gaming Session</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBooking")) { %>
                <li><a href="${ctx}/manageBooking">Manage My Booking</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBookings")) { %>
                <li><a href="${ctx}/manageBookings">Manage All Booking</a></li>
                    <% } %>
            </ul>
        </li>

        <!-- Program dropdown -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Program</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/join")) { %>
                <li><a href="${ctx}/programs/new">Create Program</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/join")) { %>
                <li><a href="${ctx}/programs/join">Join Program</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs")) { %>
                <li><a href="${ctx}/programs">Programs &amp; Tournaments</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/edit")) { %>
                <li><a href="${ctx}/programs/edit?progId=${param.progId}"> Edit Program</a></li>
                    <% } %>      
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/games")) { %>
                <li><a href="${ctx}/games">Games</a></li>
                    <% } %>
            </ul>
        </li>

        <!-- Team dropdown -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Team</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/manage")) { %>
                <li><a href="${ctx}/team/manage">My Teams</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/list")) { %>
                <li><a href="${ctx}/team/list">Team List</a></li>
                    <% } %>
            </ul>
        </li>

        <!-- Notifications & Audit -->
        <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/notifications")) { %>
        <li><a href="${ctx}/notifications">Notifications</a></li>
            <% } %>
            <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/auditLog")) { %>
        <li><a href="${ctx}/auditLog">Audit Log</a></li>
            <% }%>

        <!-- Logout -->
        <li class="logout-btn"><a href="${ctx}/logout">Logout</a></li>
    </ul>
</nav>
