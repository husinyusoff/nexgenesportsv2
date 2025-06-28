<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List, my.nexgenesports.util.PermissionChecker" %>

<c:url value="/" var="ctx"/>

<%
    // pull session attributes once
    List<String> roles     = (List<String>) session.getAttribute("effectiveRoles");
    String       chosenRole = (String)   session.getAttribute("role");
    String       position   = (String)   session.getAttribute("position");

    // precompute access flags
    boolean canIGP       = PermissionChecker.hasAccess(roles, chosenRole, position, "/inGameProfile");
    boolean canST        = PermissionChecker.hasAccess(roles, chosenRole, position, "/selectStation");
    boolean canMB        = PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBooking");
    boolean canMBS       = PermissionChecker.hasAccess(roles, chosenRole, position, "/manageBookings");
    boolean canJoinProg  = PermissionChecker.hasAccess(roles, chosenRole, position, "/programs/join");
    boolean canProg      = PermissionChecker.hasAccess(roles, chosenRole, position, "/programs");
    boolean canGames     = PermissionChecker.hasAccess(roles, chosenRole, position, "/games");
    boolean canTM        = PermissionChecker.hasAccess(roles, chosenRole, position, "/team/manage");
    boolean canTL        = PermissionChecker.hasAccess(roles, chosenRole, position, "/team/list");
    boolean canNotif     = PermissionChecker.hasAccess(roles, chosenRole, position, "/notifications");
    boolean canAudit     = PermissionChecker.hasAccess(roles, chosenRole, position, "/auditLog");
%>

<nav>
  <ul>
    <!-- Dashboard -->
    <li><a href="${ctx}dashboard">Dashboard</a></li>

    <!-- Profile -->
    <li class="dropdown">
      <a href="javascript:void(0)" class="dropdown-btn">Profile</a>
      <ul class="dropdown-content">
        <li><a href="${ctx}manageProfile">My Profile</a></li>
        <c:if test="${canIGP}">
          <li><a href="${ctx}inGameProfile">In-Game Profile</a></li>
        </c:if>
        <li><a href="${ctx}manageMembership">Membership &amp; Pass</a></li>
      </ul>
    </li>

    <!-- Multiplayer Lounge -->
    <li class="dropdown">
      <a href="javascript:void(0)" class="dropdown-btn">Multiplayer Lounge</a>
      <ul class="dropdown-content">
        <c:if test="${canST}">
          <li><a href="${ctx}selectStation">Book Gaming Session</a></li>
        </c:if>
        <c:if test="${canMB}">
          <li><a href="${ctx}manageBooking">Manage My Booking</a></li>
        </c:if>
        <c:if test="${canMBS}">
          <li><a href="${ctx}manageBookings">Manage All Booking</a></li>
        </c:if>
      </ul>
    </li>

    <!-- Program -->
    <li class="dropdown">
      <a href="javascript:void(0)" class="dropdown-btn">Program</a>
      <ul class="dropdown-content">
        <c:if test="${canJoinProg}">
          <li><a href="${ctx}programs/join">Join Tournament / Program</a></li>
        </c:if>
        <c:if test="${canProg}">
          <li><a href="${ctx}programs">Programs &amp; Tournaments</a></li>
        </c:if>
        <c:if test="${canGames}">
          <li><a href="${ctx}games">Games</a></li>
        </c:if>
      </ul>
    </li>

    <!-- Team -->
    <li class="dropdown">
      <a href="javascript:void(0)" class="dropdown-btn">Team</a>
      <ul class="dropdown-content">
        <c:if test="${canTM}">
          <li><a href="${ctx}team/manage">My Teams</a></li>
        </c:if>
        <c:if test="${canTL}">
          <li><a href="${ctx}team/list">Team List</a></li>
        </c:if>
      </ul>
    </li>

    <!-- Notifications & Audit -->
    <c:if test="${canNotif}">
      <li><a href="${ctx}notifications">Notifications</a></li>
    </c:if>
    <c:if test="${canAudit}">
      <li><a href="${ctx}auditLog">Audit Log</a></li>
    </c:if>

    <!-- Logout -->
    <li class="logout-btn"><a href="${ctx}logout">Logout</a></li>
  </ul>
</nav>
