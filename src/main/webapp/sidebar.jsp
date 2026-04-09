<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List, my.nexgenesports.util.PermissionChecker" %>
<%
    @SuppressWarnings("unchecked")
    List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position = (String) session.getAttribute("position");
    String ctx = request.getContextPath();
    request.setAttribute("ctx", ctx);
%>

<!-- Sidebar Overlay Panel -->
<div class="sidebar" id="sidebar">
    <nav>
        <ul>
            <li><a href="${ctx}/dashboard.jsp">Dashboard</a></li>

            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Profile <svg class="arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></a>
                <ul class="dropdown-content">
                    <li><a href="${ctx}/manageProfile">My Profile</a></li>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/inGameProfile")) { %>
                    <li><a href="${ctx}/inGameProfile">In-Game Profile</a></li>
                    <% } %>
                    <li><a href="${ctx}/manageMembership">Membership &amp; Pass</a></li>
                </ul>
            </li>

            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Multiplayer Lounge <svg class="arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></a>
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
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageStations")) { %>
                    <li><a href="${ctx}/manageStations">Manage Stations</a></li>
                    <% } %>
                </ul>
            </li>

            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Program <svg class="arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></a>
                <ul class="dropdown-content">
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/create")) { %>
                    <li><a href="${ctx}/programs/new">Create Program</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/join")) { %>
                    <li><a href="${ctx}/programs/join">Join Program</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/programs")) { %>
                    <li><a href="${ctx}/programs">Programs &amp; Tournaments</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/games")) { %>
                    <li><a href="${ctx}/games">Games</a></li>
                    <% } %>
                </ul>
            </li>

            <li class="dropdown">
                <a href="javascript:void(0)" class="dropdown-btn">Team <svg class="arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></a>
                <ul class="dropdown-content">
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/manage")) { %>
                    <li><a href="${ctx}/team/manage">My Teams</a></li>
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
            <li><a href="${ctx}/auditLog">Audit Log</a></li>
            <%}%>
            
            <c:set var="canAccessUsers" value='<%= PermissionChecker.hasAccess((List<String>)request.getSession().getAttribute("effectiveRoles"), (String)request.getSession().getAttribute("role"), (String)request.getSession().getAttribute("position"), "/admin/users") %>' />
            <c:set var="canAccessRbac" value='<%= PermissionChecker.hasAccess((List<String>)request.getSession().getAttribute("effectiveRoles"), (String)request.getSession().getAttribute("role"), (String)request.getSession().getAttribute("position"), "/admin/rbac") %>' />
            <c:set var="canAccessMemberships" value='<%= PermissionChecker.hasAccess((List<String>)request.getSession().getAttribute("effectiveRoles"), (String)request.getSession().getAttribute("role"), (String)request.getSession().getAttribute("position"), "/admin/memberships") %>' />
            
            <c:if test="${canAccessUsers || canAccessRbac || canAccessMemberships}">
                <li class="dropdown">
                    <a href="javascript:void(0)" class="dropdown-btn">Admin Management <svg class="arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></a>
                    <ul class="dropdown-content">
                        <c:if test="${canAccessUsers}">
                        <li><a href="${ctx}/admin/users">Manage Users</a></li>
                        </c:if>
                        <c:if test="${canAccessMemberships}">
                        <li><a href="${ctx}/admin/memberships">Manage Memberships</a></li>
                        </c:if>
                        <c:if test="${canAccessRbac}">
                        <li><a href="${ctx}/admin/rbac">Manage Permissions</a></li>
                        </c:if>
                    </ul>
                </li>
            </c:if>
            
            <li><a href="${ctx}/logout" style="color: var(--neon-pink); border: 1px solid var(--neon-pink);">Logout</a></li>
        </ul>
    </nav>
</div>

<!-- Script to handle sidebar toggle & dropdowns on new responsive layout -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const menuToggle = document.getElementById('menuToggle');
        const sidebar    = document.getElementById('sidebar');

        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', () => {
                if (window.innerWidth <= 900) {
                    // Mobile: slide in from left with backdrop
                    document.documentElement.classList.toggle('sidebar-mobile-open');
                } else {
                    // Desktop: slide off-canvas and REMEMBER across navigation
                    const isNowCollapsed = document.documentElement.classList.toggle('sidebar-collapsed');
                    try { localStorage.setItem('sidebar-collapsed', isNowCollapsed ? 'true' : 'false'); } catch(e) {}
                }
            });

            // Close mobile sidebar when clicking the backdrop
            document.addEventListener('click', (e) => {
                if (window.innerWidth <= 900 && !sidebar.contains(e.target) && !menuToggle.contains(e.target)) {
                    document.documentElement.classList.remove('sidebar-mobile-open');
                }
            });

            window.addEventListener('resize', () => {
                if (window.innerWidth > 900) document.documentElement.classList.remove('sidebar-mobile-open');
            });
        }

        // ── Smooth accordion dropdowns ──────────────────────────────────────
        document.querySelectorAll('.dropdown-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const content = this.nextElementSibling;
                const isOpen  = this.classList.contains('open');

                // Close all first
                document.querySelectorAll('.dropdown-btn').forEach(b => b.classList.remove('open'));
                document.querySelectorAll('.dropdown-content').forEach(el => { el.style.maxHeight = '0'; el.style.opacity = '0'; });

                if (!isOpen) {
                    this.classList.add('open');
                    content.style.maxHeight = content.scrollHeight + 'px';
                    content.style.opacity   = '1';
                }
            });
        });

        // ── Auto-expand dropdown containing the current page ────────────────
        const currentPath = window.location.pathname;

        document.querySelectorAll('.dropdown-content a').forEach(link => {
            try {
                if (new URL(link.href).pathname === currentPath) {
                    link.classList.add('active-link');
                    const dc = link.closest('.dropdown-content');
                    if (dc) {
                        dc.previousElementSibling.classList.add('open');
                        requestAnimationFrame(() => { dc.style.maxHeight = dc.scrollHeight + 'px'; dc.style.opacity = '1'; });
                    }
                }
            } catch(e) {}
        });

        // ── Highlight top-level standalone links (e.g. Dashboard) ──────────
        document.querySelectorAll('.sidebar nav > ul > li > a:not(.dropdown-btn)').forEach(link => {
            try { if (new URL(link.href).pathname === currentPath) link.classList.add('active-link'); } catch(e) {}
        });
    });
</script>

