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
    <style>
        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            transition: color 0.3s ease;
        }
        .password-toggle-btn:hover {
            color: var(--neon-cyan);
        }
        .password-toggle-btn svg {
            position: absolute;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .password-toggle-btn .eye-open {
            opacity: 0;
            transform: scale(0.5) rotate(-45deg);
        }
        .password-toggle-btn .eye-closed {
            opacity: 1;
            transform: scale(1) rotate(0);
        }
        .password-toggle-btn.is-visible .eye-open {
            opacity: 1;
            transform: scale(1) rotate(0);
        }
        .password-toggle-btn.is-visible .eye-closed {
            opacity: 0;
            transform: scale(0.5) rotate(45deg);
        }
    </style>
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
                        <div class="password-toggle-btn" id="togglePassword" aria-label="Toggle password visibility">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-open">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-closed">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                <line x1="1" y1="1" x2="23" y2="23"></line>
                            </svg>
                        </div>
                    </div>
                </t:Field>

                <t:Field id="confirmPassword" label="Confirm Password" required="true">
                    <div class="password-wrapper" style="position: relative;">
                        <input class="input-field" style="width: 100%; padding-right: 40px;" type="password" id="confirmPassword" name="confirmPassword" required
                               placeholder="Re-enter password" minlength="6">
                        <div class="password-toggle-btn" id="toggleConfirm" aria-label="Toggle password visibility">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-open">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="eye-closed">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                <line x1="1" y1="1" x2="23" y2="23"></line>
                            </svg>
                        </div>
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
                        const isVisible = field.type === 'password';
                        field.type = isVisible ? 'text' : 'password';
                        this.classList.toggle('is-visible', isVisible);
                        if (isVisible) {
                            this.style.color = 'var(--neon-cyan)';
                        } else {
                            this.style.color = 'var(--text-muted)';
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
