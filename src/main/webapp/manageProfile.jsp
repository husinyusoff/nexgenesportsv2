<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - NexGen Esports</title>
</head>
<body class="app-wrapper">
    <jsp:include page="header.jsp"/>

    <div class="main-container">
        <jsp:include page="sidebar.jsp"/>

        <main class="content">
            <div class="module-header">
                <h2>MY PROFILE</h2>
            </div>

            <% if (request.getAttribute("successMsg") != null) { %>
                <div style="color:var(--neon-cyan); margin-bottom: 20px; padding: 12px; border: 1px solid var(--neon-cyan); border-radius: 8px; background: rgba(0,229,255,0.1); font-weight: 600;">
                    <%= request.getAttribute("successMsg") %>
                </div>
            <% } %>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="error-msg"><%= request.getAttribute("errorMsg") %></div>
            <% } %>

            <style>
                /* User ID field: looks like plain text when readonly */
                #userID {
                    font-weight: bold;
                    color: white;
                    margin-bottom: 0;
                    padding: 4px 0;
                    font-family: var(--font-main);
                    font-size: 1rem;
                    width: 100%;
                    background: transparent;
                    border: none;
                    box-shadow: none;
                    outline: none;
                }
                /* When readonly: kill ALL visual effects including focus */
                #userID[readonly] {
                    border: none !important;
                    box-shadow: none !important;
                    outline: none !important;
                    background: transparent !important;
                }
                #userID[readonly]:focus {
                    border: none !important;
                    box-shadow: none !important;
                    outline: none !important;
                }
                /* When editable (not readonly): show standard input look */
                #userID:not([readonly]) {
                    border: 1px solid var(--glass-border);
                    background: rgba(0, 0, 0, 0.3);
                    padding: 8px 12px;
                    border-radius: 8px;
                    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
                }
                /* When editable AND focused: cyan glow — only on explicit click */
                #userID:not([readonly]):focus {
                    border-color: var(--neon-cyan);
                    box-shadow: 0 0 15px rgba(0, 229, 255, 0.4);
                    background: rgba(0, 229, 255, 0.05);
                    outline: none;
                }
            </style>

            <div class="glass-card">
                <form action="${pageContext.request.contextPath}/manageProfile" method="post">

                    <div class="details-grid">
                        <div class="details-item" style="padding: 10px 20px; display: flex; flex-direction: column; justify-content: center;">
                            <span class="label" style="margin-bottom: 2px;">User ID</span>
                            <input type="text" id="userID" name="userID" class="editable-field"
                                   value="<c:out value='${user.userID}'/>" required readonly>
                        </div>
                        <div class="details-item" style="padding: 10px 20px; display: flex; flex-direction: column; justify-content: center;">
                            <span class="label" style="margin-bottom: 2px;">Member Since</span>
                            <strong style="font-size: 1.1rem;"><c:out value="${user.formattedRegistrationDate}"/></strong>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 style="margin: 0; color: var(--neon-cyan);">Personal Information</h3>
                        <button type="button" id="edit-btn" class="btn" style="padding: 6px 16px; font-size: 0.9rem; border: 1px solid var(--neon-cyan); background: transparent; color: var(--neon-cyan);">
                            Edit Profile
                        </button>
                    </div>

                    <label class="label" for="name">Full Name</label>
                    <input class="input-field editable-field" type="text" id="name" name="name"
                           value="<c:out value='${user.name}'/>" required readonly>

                    <label class="label" for="email">Email</label>
                    <input class="input-field editable-field" type="email" id="email" name="email"
                           value="<c:out value='${user.email}'/>" required readonly>

                    <label class="label" for="phoneNumber">Phone Number</label>
                    <input class="input-field editable-field" type="tel" id="phoneNumber" name="phoneNumber"
                           value="<c:out value='${user.phoneNumber}'/>" readonly>

                    <label class="label" for="matricNumber">Matric / Staff Number</label>
                    <input class="input-field editable-field" type="text" id="matricNumber" name="matricNumber"
                           value="<c:out value='${user.matricNumber}'/>"
                           placeholder="e.g. S12345 (Degree), A12345 (Asasi), UMT02848 (Staff)" readonly>

                    <button id="save-btn" class="btn btn-primary btn-block" type="submit" style="display: none;">Save Changes</button>
                </form>
            </div>

            <script>
                document.getElementById('edit-btn').addEventListener('click', function() {
                    const fields = document.querySelectorAll('.editable-field');
                    const isEditing = this.innerText.toUpperCase().trim() === 'CANCEL';

                    if (isEditing) {
                        // Cancel editing — make all readonly and remove focus
                        fields.forEach(f => {
                            f.readOnly = true;
                            f.blur();
                        });
                        this.innerText = 'Edit Profile';
                        this.style.borderColor = 'var(--neon-cyan)';
                        this.style.color = 'var(--neon-cyan)';
                        document.getElementById('save-btn').style.display = 'none';
                    } else {
                        // Start editing — just unlock fields, no auto-focus
                        fields.forEach(f => f.readOnly = false);
                        this.innerText = 'Cancel';
                        this.style.borderColor = '#ff4d4d';
                        this.style.color = '#ff4d4d';
                        document.getElementById('save-btn').style.display = 'block';
                    }
                });
            </script>
        </main>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>
