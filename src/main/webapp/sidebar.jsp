<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="my.nexgenesports.util.PermissionChecker" %>

<%
    @SuppressWarnings(
            
    "unchecked")
  List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
    String chosenRole = (String) session.getAttribute("role");
    String position = (String) session.getAttribute("position");
    String ctx = request.getContextPath();
%>
<nav>
    <ul>
        <!-- Dashboard -->
        <li><a href="<%=ctx%>/dashboard">Dashboard</a></li>

        <!-- Profile dropdown -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Profile</a>
            <ul class="dropdown-content">
                <li><a href="<%=ctx%>/manageProfile">My Profile</a></li>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/inGameProfile")) {%>
                <li><a href="<%=ctx%>/inGameProfile">In-Game Profile</a></li>
                    <% }%>
                <li><a href="<%=ctx%>/manageMembership">Membership &amp; Pass</a></li>
            </ul>
        </li>

        <!-- Multiplayer Lounge dropdown -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Multiplayer Lounge</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/selectStation")) {%>
                <li><a href="<%=ctx%>/selectStation">Book Gaming Session</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBooking")) {%>
                <li><a href="<%=ctx%>/manageBooking">Manage My Booking</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBookings")) {%>
                <li><a href="<%=ctx%>/manageBookings">Manage All Booking</a></li>
                    <% } %>
            </ul>
        </li>

        <!-- Program dropdown (added) -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Program</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/joinTourProg")) {%>
                <li><a href="<%=ctx%>/joinTourProg">Join Tournament / Program</a></li>
                    <% } %>
                    <%-- If you have a tournaments listing servlet --%>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/tournaments")) {%>
                <li><a href="<%=ctx%>/tournaments">Tournaments</a></li>
                    <% } %>
                    <%-- Game List (read) --%>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/games")) {%>
                <li><a href="<%=ctx%>/games">Games</a></li>
                    <% } %>
            </ul>
        </li>


        <li class="dropdown">
            <a href="javascript:void(0)" class="dropdown-btn">Team</a>
            <ul class="dropdown-content">
                <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team/manage")) { %>
                <li><a href="<%=ctx%>/team/manage">My Teams</a></li>
                    <% } %>
                    <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/team")) { %>
                <li><a href="<%=ctx%>/team">Team List</a></li>
                    <% } %>
            </ul>
        </li>


        <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/notifications")) {%>
        <li><a href="<%=ctx%>/notifications">Notifications</a></li>
            <% } %>
            <% if (PermissionChecker.hasAccess(roles, chosenRole, position, "/auditLog")) {%>
        <li><a href="<%=ctx%>/auditLog">Audit Log</a></li>
            <% }%>

        <!-- Logout -->
        <li class="logout-btn"><a href="<%=ctx%>/logout">Logout</a></li>
    </ul>
</nav>
