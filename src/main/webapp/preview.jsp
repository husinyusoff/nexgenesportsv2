<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/shared" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Component Preview - NexGen Esports</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
    <div id="esports-bg-canvas"></div>

    <t:AppShell>
        
        <t:PageHeader title="Design System Verification">
            <t:Button variant="primary" onClick="document.getElementById('demoModal').classList.add('active');">Trigger Modal</t:Button>
        </t:PageHeader>

        <div class="preview-layout">
            
            <h3 class="section-title">Store & Subscriptions</h3>
            <div class="flex-row">
                <t:StoreCard title="Basic Pass" price="RM 15" actionLabel="Purchase Basic" actionVariant="outline-primary">
                    <ul>
                        <li>1 Hour Gaming Session</li>
                        <li>Standard Peripherals</li>
                        <li>Casual Lounge Access</li>
                    </ul>
                </t:StoreCard>
                <t:StoreCard title="Pro Pass" price="RM 50" isPremium="true" actionLabel="Purchase Premium" actionVariant="primary">
                    <ul>
                        <li>5 Hours Gaming Session</li>
                        <li>High-Refresh Rate Monitors</li>
                        <li>Tournament Priority Booking</li>
                        <li>Free Beverage</li>
                    </ul>
                </t:StoreCard>
                <t:StoreCard title="Athlete Member" price="RM 250" actionLabel="Apply Now" actionVariant="secondary">
                    <ul>
                        <li>Monthly Unlimited Access</li>
                        <li>Team Scrimmage Rooms</li>
                        <li>Official Jersey</li>
                    </ul>
                </t:StoreCard>
            </div>

            <h3 class="section-title mt-3">Navigation & State</h3>
            <t:TabSwitcher>
                <span class="tab-label active">Component Library</span>
                <span class="tab-label">Layout Guidelines</span>
                <span class="tab-label">Global Typography</span>
            </t:TabSwitcher>
            
            <div class="mb-3">
                <t:Alert variant="success">Successfully extracted all requested components including StoreCard!</t:Alert>
            </div>

            <h3 class="section-title mt-3">Refined Primitives</h3>
            <t:GlassCard>
                <h3 class="section-title">Status Badges</h3>
                <div class="flex-row mb-3">
                    <t:Badge variant="success">Active</t:Badge>
                    <t:Badge variant="warning">Pending Eval</t:Badge>
                    <t:Badge variant="danger">Banned</t:Badge>
                    <t:Badge variant="premium">VIP Member</t:Badge>
                </div>
                
                <h3 class="section-title mt-3">Form Fields</h3>
                <div class="mb-3">
                    <t:Field id="username" label="Username">
                        <input type="text" id="username" class="input-field" placeholder="Enter username...">
                    </t:Field>
                </div>

                <h3 class="section-title mt-3">Button Variants</h3>
                <div class="flex-row mb-3">
                    <t:Button variant="primary">Primary Action</t:Button>
                    <t:Button variant="secondary">Secondary Action</t:Button>
                    <t:Button variant="outline-primary">Outline Focus</t:Button>
                    <t:Button variant="outline-danger">Danger Delete</t:Button>
                </div>
            </t:GlassCard>
            
            <h3 class="section-title mt-3">Data Grid</h3>
            <t:GlassCard cssClass="mb-3">
                <t:DataTable>
                    <thead>
                        <tr><th>Component Name</th><th>Status</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td data-label="Component Name">StoreCard.tag</td>
                            <td data-label="Status"><t:Badge variant="success">Live</t:Badge></td>
                            <td data-label="Action"><t:Button variant="secondary">Inspect</t:Button></td>
                        </tr>
                    </tbody>
                </t:DataTable>
            </t:GlassCard>

        </div>
        
        <t:Modal id="demoModal" title="System Check">
            <p class="mb-3">Testing modal overlay layout constraints.</p>
            <div class="flex-row">
                <t:Button variant="secondary" onClick="document.getElementById('demoModal').classList.remove('active');">Close</t:Button>
                <t:Button variant="primary" onClick="document.getElementById('demoModal').classList.remove('active');">Verify</t:Button>
            </div>
        </t:Modal>

    </t:AppShell>
</body>
</html>
