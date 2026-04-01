<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List, my.nexgenesports.util.PermissionChecker" %>
<<<<<<< Updated upstream
<%
    @SuppressWarnings("unchecked")
    List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position = (String) session.getAttribute("position");
    String ctx = request.getContextPath();
    request.setAttribute("ctx", ctx);
=======
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    @SuppressWarnings(
            
    
    "unchecked")
    List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position = (String) session.getAttribute("position");

    // Expose context path
    String ctx = request.getContextPath();
    request.setAttribute("ctx", ctx);

    // CSRF token if needed elsewhere
    String csrfToken = (String) session.getAttribute("csrfToken");
>>>>>>> Stashed changes
%>

<!-- Sidebar Overlay Panel -->
<div class="sidebar" id="sidebar">
    <nav>
        <ul>
            <li><a href="${ctx}/dashboard">Dashboard</a></li>

<<<<<<< Updated upstream
            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Profile ▾</a>
                <ul class="dropdown-content">
                    <li><a href="${ctx}/manageProfile">My Profile</a></li>
=======
        <!-- Profile dropdown -->
        <li class="dropdown">
            <a href="#" class="dropdown-btn">Profile</a>
            <ul class="dropdown-content">
                <li><a href="${ctx}/manageProfile">My Profile</a></li>
>>>>>>> Stashed changes
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/inGameProfile")) { %>
                    <li><a href="${ctx}/inGameProfile">In-Game Profile</a></li>
                    <% } %>
                    <li><a href="${ctx}/manageMembership">Membership &amp; Pass</a></li>
                </ul>
            </li>

<<<<<<< Updated upstream
            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Multiplayer Lounge ▾</a>
                <ul class="dropdown-content">
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/selectStation")) { %>
                    <li><a href="${ctx}/selectStation">Book Gaming Session</a></li>
=======
        <!-- Multiplayer Lounge dropdown -->
        <li class="dropdown">
            <a href="#" class="dropdown-btn">Multiplayer Lounge</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/selectStation")) { %>
                <li><a href="${ctx}/selectStation">Book Gaming Session</a></li>
>>>>>>> Stashed changes
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBooking")) { %>
                    <li><a href="${ctx}/manageBooking">Manage My Booking</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBookings")) { %>
                    <li><a href="${ctx}/manageBookings">Manage All Booking</a></li>
                    <% } %>
                </ul>
            </li>

<<<<<<< Updated upstream
            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Program ▾</a>
                <ul class="dropdown-content">
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/create")) { %>
                    <li><a href="${ctx}/programs/new">Create Program</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/join")) { %>
                    <li><a href="${ctx}/programs/join">Join Program</a></li>
                    <% } %>
=======
        <!-- Program dropdown -->
        <li class="dropdown">
            <a href="#" class="dropdown-btn">Program</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/new")) { %>
                <li><a href="${ctx}/programs/new">Create Program</a></li>
                    <% } %>
>>>>>>> Stashed changes
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs")) { %>
                    <li><a href="${ctx}/programs">Programs &amp; Tournaments</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/games")) { %>
                    <li><a href="${ctx}/games">Games</a></li>
                    <% } %>
                </ul>
            </li>

<<<<<<< Updated upstream
            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Team ▾</a>
                <ul class="dropdown-content">
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/manage")) { %>
                    <li><a href="${ctx}/team/manage">My Teams</a></li>
=======
        <!-- Team dropdown -->
        <li class="dropdown">
            <a href="#" class="dropdown-btn">Team</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/manage")) { %>
                <li><a href="${ctx}/team/manage">My Teams</a></li>
>>>>>>> Stashed changes
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/list")) { %>
                    <li><a href="${ctx}/team/list">Team List</a></li>
                    <% } %>
                </ul>
            </li>

            <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/notifications")) { %>
            <li><a href="${ctx}/notifications">Notifications</a></li>
            <% } %>
            <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/auditLog")) { %>
<<<<<<< Updated upstream
            <li><a href="${ctx}/auditLog">Audit Log</a></li>
            <% }%>
            
            <li><a href="${ctx}/logout" style="color: var(--neon-pink); border: 1px solid var(--neon-pink);">Logout</a></li>
        </ul>
    </nav>
</div>
=======
        <li><a href="${ctx}/auditLog">Audit Log</a></li>
            <% } %>

        <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/admin/rbac")) { %>
        <li>
            <a href="${ctx}/admin/rbac" class="btn small gray-btn">
                RBAC Center
            </a>
        </li>
        <% }%>
>>>>>>> Stashed changes

<!-- Script to handle sidebar toggle & dropdowns on new responsive layout -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');

        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
            });

            // Close sidebar if clicking outside on mobile
            document.addEventListener('click', (e) => {
                if (window.innerWidth <= 900) {
                    if (!sidebar.contains(e.target) && !menuToggle.contains(e.target) && sidebar.classList.contains('active')) {
                        sidebar.classList.remove('active');
                    }
                }
            });
        }

        // Handle dropdowns
        const dropdownBtns = document.querySelectorAll('.dropdown-btn');
        dropdownBtns.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const content = this.nextElementSibling;
                if(content.style.display === 'block') {
                    content.style.display = 'none';
                } else {
                    document.querySelectorAll('.dropdown-content').forEach(el => el.style.display = 'none');
                    content.style.display = 'block';
                }
            });
        });
    });
</script>
