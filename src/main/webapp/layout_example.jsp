<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Layout Comparison Example</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
    <div id="esports-bg-canvas"></div>

    <t:AppShell>
        
        <t:PageHeader title="MY PROFILE (MODULAR LAYOUT)">
            <t:Button variant="primary">Edit Profile</t:Button>
        </t:PageHeader>

        <div class="preview-layout" style="max-width: 900px; margin: 0;">
            
            <t:Alert variant="success">Notice how the beautiful animated background bleeds through the gap between these two cards!</t:Alert>

            <!-- Card 1: Just for the top stats -->
            <t:GlassCard>
                <div style="display: flex; justify-content: space-between;">
                    <div>
                        <span style="color: var(--neon-cyan); font-size: 0.8rem; font-weight: bold;">USER ID</span><br>
                        <strong style="font-size: 1.2rem;">husinyusoff</strong>
                    </div>
                    <div>
                        <span style="color: var(--neon-cyan); font-size: 0.8rem; font-weight: bold;">MEMBER SINCE</span><br>
                        <strong style="font-size: 1.2rem;">09:00 20/06/2025</strong>
                    </div>
                </div>
            </t:GlassCard>

            <!-- Card 2: Just for the form -->
            <t:GlassCard>
                <h3 class="section-title">Personal Information</h3>
                
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <t:Field id="fullname" label="FULL NAME">
                        <input type="text" id="fullname" class="input-field" value="Husin Yusoff" readonly>
                    </t:Field>
                    
                    <t:Field id="email" label="EMAIL">
                        <input type="text" id="email" class="input-field" value="athlete1@student.umt.edu.my" readonly>
                    </t:Field>

                    <t:Field id="phone" label="PHONE NUMBER">
                        <input type="text" id="phone" class="input-field" value="01111194399" readonly>
                    </t:Field>
                </div>
            </t:GlassCard>

        </div>

    </t:AppShell>
</body>
</html>
