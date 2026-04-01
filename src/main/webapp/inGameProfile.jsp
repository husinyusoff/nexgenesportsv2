<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>In-Game Profile - NexGen Esports</title>
</head>
<body class="app-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <jsp:include page="sidebar.jsp"/>

        <main class="content">
            <div class="module-header">
                <h2>IN-GAME PROFILE</h2>
            </div>

            <% if (request.getAttribute("successMsg") != null) { %>
                <div style="color:var(--neon-cyan); margin-bottom: 20px; padding: 12px; border: 1px solid var(--neon-cyan); border-radius: 8px; background: rgba(0,229,255,0.1); font-weight: 600;">
                    <%= request.getAttribute("successMsg") %>
                </div>
            <% } %>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="error-msg"><%= request.getAttribute("errorMsg") %></div>
            <% } %>

            <div class="glass-card">
                <p style="color: var(--text-muted); margin-bottom: 25px; font-size: 0.95rem;">
                    Set up your esports identity. This information will be visible to other club members and tournament organizers.
                </p>

                <form action="${pageContext.request.contextPath}/inGameProfile" method="post">

                    <label class="label" for="ign">In-Game Name (Default)</label>
                    <input class="input-field" type="text" id="ign" name="ign"
                           value="<c:out value='${user.ign}'/>"
                           placeholder="Your primary gaming alias">

                    <label class="label" for="discordID">Discord ID</label>
                    <input class="input-field" type="text" id="discordID" name="discordID"
                           value="<c:out value='${user.discordID}'/>"
                           placeholder="e.g. username#1234 or username">

                    <label class="label" for="bio">Bio</label>
                    <textarea class="input-field" id="bio" name="bio" rows="4"
                              placeholder="Tell us about yourself as a gamer..."
                              style="resize: vertical;"><c:out value='${user.bio}'/></textarea>

                    <button class="btn btn-primary btn-block" type="submit">Save Changes</button>
                </form>
            </div>
        </main>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>
