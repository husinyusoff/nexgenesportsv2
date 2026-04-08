<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - NexGen Esports</title>
</head>
<body>
    <t:AppShell cssClass="auth-wrapper" hideSidebar="true">
        <t:GlassCard cssClass="auth-box" style="max-width: 480px;">
            <h2 style="text-align: center; margin-bottom: 24px; color: var(--text-primary); font-family: var(--font-heading); text-transform: uppercase;">CREATE ACCOUNT</h2>

            <c:if test="${param.status == 'success'}">
                <t:Alert variant="success">Registration successful! <a href="login.jsp" style="color: white; font-weight: bold; text-decoration: underline;">Login here</a></t:Alert>
            </c:if>
            <c:if test="${not empty requestScope.errorMsg}">
                <t:Alert variant="danger"><c:out value="${requestScope.errorMsg}"/></t:Alert>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth?action=register" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <t:Field id="userID" label="User ID" required="true">
                    <input class="input-field" type="text" id="userID" name="userID" required
                           placeholder="Choose a unique User ID" pattern="[a-zA-Z0-9_]+"
                           title="Only letters, numbers, and underscores allowed">
                </t:Field>

                <t:Field id="name" label="Full Name" required="true">
                    <input class="input-field" type="text" id="name" name="name" required
                           placeholder="Enter your full name">
                </t:Field>

                <t:Field id="email" label="Email" required="true">
                    <input class="input-field" type="email" id="email" name="email" required
                           placeholder="your.email@student.umt.edu.my">
                </t:Field>

                <t:Field id="phoneNumber" label="Phone Number">
                    <input class="input-field" type="tel" id="phoneNumber" name="phoneNumber"
                           placeholder="01X-XXXXXXX">
                </t:Field>

                <t:Field id="matricNumber" label="Matric / Staff Number">
                    <input class="input-field" type="text" id="matricNumber" name="matricNumber"
                           placeholder="e.g. S12345 (Student), Staff ID (Staff)">
                </t:Field>

                <t:Field id="newPassword" label="Password" required="true">
                    <div class="password-wrapper" style="position: relative;">
                        <input class="input-field" style="width: 100%; padding-right: 40px;" type="password" id="newPassword" name="password" required
                               placeholder="Minimum 6 characters" minlength="6">
                        <span class="eye-icon" id="togglePassword" style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);">👁</span>
                    </div>
                </t:Field>

                <t:Field id="confirmPassword" label="Confirm Password" required="true">
                    <div class="password-wrapper" style="position: relative;">
                        <input class="input-field" style="width: 100%; padding-right: 40px;" type="password" id="confirmPassword" name="confirmPassword" required
                               placeholder="Re-enter password" minlength="6">
                        <span class="eye-icon" id="toggleConfirm" style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);">👁</span>
                    </div>
                </t:Field>

                <div style="margin-top: 30px;">
                    <t:Button variant="primary" type="submit" cssClass="w-100" style="width: 100%;">Sign Up</t:Button>
                </div>

                <div class="auth-links" style="margin-top: 20px; display: flex; justify-content: center; font-size: 0.85rem;">
                    <a href="${pageContext.request.contextPath}/login.jsp" style="color: var(--neon-cyan); transition: var(--transition);">Already have an account? Login</a>
                </div>
            </form>
        </t:GlassCard>
    </t:AppShell>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            function setupToggle(toggleId, fieldId) {
                const toggleBtn = document.getElementById(toggleId);
                if (toggleBtn) {
                    toggleBtn.addEventListener('click', function() {
                        const field = document.getElementById(fieldId);
                        if (field.type === 'password') {
                            field.type = 'text';
                            this.style.color = '#00e5ff';
                        } else {
                            field.type = 'password';
                            this.style.color = '#a0a0ab';
                        }
                    });
                }
            }
            setupToggle('togglePassword', 'newPassword');
            setupToggle('toggleConfirm', 'confirmPassword');
        });
    </script>
</body>
</html>
