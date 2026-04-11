<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>👤 Manage Users – NexGen Esports</title>
  <style>
    /* Table specific styles for neon void */
    .neon-table-wrapper {
        overflow-x: auto;
        margin-top: 10px;
    }
    .neon-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }
    .neon-table th {
        background: rgba(0, 229, 255, 0.05);
        color: var(--neon-cyan);
        text-transform: uppercase;
        font-family: var(--font-heading);
        font-size: 0.85rem;
        letter-spacing: 1.5px;
        padding: 14px;
        text-align: left;
        border-bottom: 1px solid rgba(0, 229, 255, 0.2);
    }
    .neon-table td {
        padding: 16px 14px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        font-family: var(--font-main);
        font-size: 0.95rem;
        color: var(--text-primary);
        transition: var(--transition);
    }
    .neon-table tr:hover td {
        background-color: rgba(255, 255, 255, 0.03);
    }
    .user-row.is-disabled td {
        opacity: 0.5;
        background-color: rgba(255, 0, 127, 0.02);
    }
    .user-row.is-disabled:hover td {
        background-color: rgba(255, 0, 127, 0.05);
    }
    
    .neon-table th[data-sort] {
        cursor: pointer;
        user-select: none;
        transition: background-color 0.2s ease;
    }
    .neon-table th[data-sort]:hover {
        background: rgba(0, 229, 255, 0.1);
    }
    .sort-icon {
        display: inline-block;
        margin-left: 5px;
        font-size: 0.8rem;
    }
    
    .filter-combo-row {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
    }
    .filter-combo-row .form-group {
        flex: 1;
        min-width: 200px;
        margin-bottom: 0;
    }
    
    /* Action Buttons */
    .action-group {
        display: flex;
        gap: 10px;
    }
  </style>
</head>
<body class="app-wrapper">
  <!-- global header -->
  <jsp:include page="/header.jsp"/>

  <div class="main-container">
    <jsp:include page="/sidebar.jsp"/>

    <main class="content">
      <div class="rigid-layout-container">
      
        <!-- COHESIVE PROFILE HERO -->
        <div class="profile-hero">
            <div class="profile-hero-icon">👥</div>
            <h2>Manage Users</h2>
            <p class="subtitle">Review, update roles, and deactivate users in the arena.</p>
        </div>

        <!-- ALERTS -->
        <c:if test="${not empty sessionScope.adminSuccessMsg}">
          <div class="success-msg" style="animation: modalSlideIn 0.4s ease-out;">
            ✓ ${sessionScope.adminSuccessMsg}
          </div>
          <c:remove var="adminSuccessMsg" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.adminErrorMsg}">
          <div class="success-msg" style="background: rgba(255, 0, 127, 0.1); color: var(--neon-pink); border-color: var(--neon-pink); animation: modalSlideIn 0.4s ease-out;">
            ✕ ${sessionScope.adminErrorMsg}
          </div>
          <c:remove var="adminErrorMsg" scope="session"/>
        </c:if>

        <div class="profile-panels-grid" style="grid-template-columns: 1fr;">
            
            <!-- CONTROLS PANEL -->
            <div class="profile-panel">
                <div class="panel-header" style="margin-bottom: 20px;">
                    <div class="panel-title"><span class="panel-icon">🔍</span> Search & Filters</div>
                </div>
                
                <div class="filter-combo-row">
                    <div class="form-group">
                        <label>Search Query</label>
                        <input type="text" id="searchInput" class="profile-input" placeholder="Username, Name, or Email...">
                    </div>
                    <div class="form-group">
                        <label>Role Filter</label>
                        <select id="roleFilter" class="profile-input">
                            <option value="ALL">All Roles</option>
                            <c:forEach var="role" items="${rolesList}">
                                <option value="${role.role}">${role.role} <c:if test="${not empty role.position}"> - ${role.position}</c:if></option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: auto; padding-bottom: 8px;">
                        <input type="checkbox" id="hideDisabledToggle" checked style="width: 18px; height: 18px; accent-color: var(--neon-cyan); cursor: pointer;">
                        <label for="hideDisabledToggle" style="margin-bottom: 0; cursor: pointer; color: var(--text-muted); font-size: 0.9rem;">Hide Disabled Users</label>
                    </div>
                </div>
            </div>

            <!-- REGISTRY PANEL -->
            <div class="profile-panel">
                <div class="panel-header">
                    <div class="panel-title"><span class="panel-icon">📋</span> User Registry</div>
                </div>
                
                <div class="neon-table-wrapper">
                    <table class="neon-table" id="usersTable">
                      <thead>
                        <tr>
                          <th data-sort="id">Username (ID) <span class="sort-icon"></span></th>
                          <th data-sort="name">Name <span class="sort-icon"></span></th>
                          <th data-sort="email">Email <span class="sort-icon"></span></th>
                          <th data-sort="date">Registered On <span class="sort-icon"></span></th>
                          <th data-sort="role">Current Role <span class="sort-icon"></span></th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="user" items="${usersList}">
                          <%-- Find Role Text --%>
                          <c:set var="userRoleText" value=""/>
                          <c:set var="userRoleRaw" value=""/>
                          <c:forEach var="r" items="${rolesList}">
                            <c:if test="${r.id == user.rpId}">
                              <c:set var="userRoleText" value="${r.role}"/>
                              <c:set var="userRoleRaw" value="${r.role}"/>
                              <c:if test="${not empty r.position}">
                                <c:set var="userRoleText" value="${r.role} - ${r.position}"/>
                              </c:if>
                            </c:if>
                          </c:forEach>
                          
                          <tr class="user-row ${userRoleRaw == 'disabled' ? 'is-disabled' : ''}" data-search="${user.userID.toLowerCase()} ${user.name.toLowerCase()} ${user.email.toLowerCase()}" data-role="${userRoleRaw}" data-year="${user.registrationDate.getYear()}">
                            <td><strong style="color: var(--neon-cyan);">${user.userID}</strong></td>
                            <td>${user.name}</td>
                            <td>${user.email}</td>
                            <td style="color: var(--text-muted);">${user.registrationDate.toLocalDate()}</td>
                            <td>
                              <c:choose>
                                  <c:when test="${userRoleRaw == 'disabled'}">
                                      <span class="badge badge-danger">Deactivated</span>
                                  </c:when>
                                  <c:otherwise>
                                      <span class="badge badge-success" style="background: rgba(0, 229, 255, 0.1); color: var(--neon-cyan); border-color: rgba(0, 229, 255, 0.5);">
                                        ${userRoleText}
                                      </span>
                                  </c:otherwise>
                              </c:choose>
                            </td>
                            <td>
                               <div class="action-group">
                                 <button type="button" class="btn-panel-edit" onclick="openEditModal('${user.userID}', '${user.rpId}', '${user.name}')">✎ Edit</button>
                                 <c:if test="${userRoleRaw != 'disabled'}">
                                     <button type="button" class="btn-panel-edit cancel" onclick="openDeactivateModal('${user.userID}', '${user.name}')">✕ Deactivate</button>
                                 </c:if>
                               </div>
                            </td>
                          </tr>
                        </c:forEach>
                        <c:if test="${empty usersList}">
                          <tr>
                            <td colspan="6">
                                <div class="empty-state" style="border: none; background: transparent;">
                                    <div class="empty-icon">👥</div>
                                    <div class="empty-message">No users found.</div>
                                </div>
                            </td>
                          </tr>
                        </c:if>
                      </tbody>
                    </table>
                </div>
            </div>

        </div><!-- /.profile-panels-grid -->

      </div><!-- /.rigid-layout-container -->
    </main><!-- /.content -->
  </div><!-- /.main-container -->

  <jsp:include page="/footer.jsp"/>

  <!-- Edit Role Modal -->
  <div id="editModal" class="modal-overlay">
      <div class="modal-content profile-panel" style="background: rgba(10, 10, 18, 0.95); margin: 20px;">
          <div class="panel-header">
              <div class="panel-title"><span class="panel-icon">✎</span> Edit User Role</div>
              <button type="button" class="btn-close" onclick="closeModals()">×</button>
          </div>
          
          <p style="color: var(--text-muted); margin-bottom: 1.5rem;" id="editModalInfo"></p>
          <form action="${pageContext.request.contextPath}/admin/users" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="updateRole">
              <input type="hidden" name="targetUserID" id="editUserID" value="">
              
              <div class="form-group">
                  <label for="editRpId">Select New Role</label>
                  <select name="rpId" id="editRpId" class="profile-input" style="width: 100%; display: block;" required>
                    <c:forEach var="role" items="${rolesList}">
                        <c:if test="${role.role != 'disabled'}">
                            <option value="${role.id}">
                                ${role.role} <c:if test="${not empty role.position}"> - ${role.position}</c:if>
                            </option>
                        </c:if>
                    </c:forEach>
                  </select>
              </div>
              
              <div class="save-row visible" style="border-top: none;">
                  <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex: 0.5; justify-content: center;">Cancel</button>
                  <button type="submit" class="btn-save" style="flex: 1;">💾 Save Changes</button>
              </div>
          </form>
      </div>
  </div>

  <!-- Deactivate Modal -->
  <div id="deactivateModal" class="modal-overlay">
      <div class="modal-content profile-panel" style="background: rgba(20, 10, 15, 0.95); border-color: var(--neon-pink); margin: 20px;">
          <div class="panel-header">
              <div class="panel-title" style="color: var(--neon-pink);"><span class="panel-icon">⚠</span> Confirm Deactivation</div>
              <button type="button" class="btn-close" onclick="closeModals()">×</button>
          </div>
          
          <p style="color: var(--text-primary); margin-bottom: 1.5rem;" id="deactivateModalInfo"></p>
          <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; line-height: 1.5;">
              This will revoke the user's access to the system immediately. Their historical data will remain intact.
          </p>
          <form action="${pageContext.request.contextPath}/admin/users" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="action" value="deactivate">
              <input type="hidden" name="targetUserID" id="deactivateUserID" value="">
              
              <div class="save-row visible" style="border-top: none;">
                  <button type="button" class="btn-panel-edit" onclick="closeModals()" style="flex: 0.5; justify-content: center;">Cancel</button>
                  <button type="submit" class="btn-save" style="background: linear-gradient(90deg, var(--neon-pink), #cc0052); flex: 1;">Deactivate</button>
              </div>
          </form>
      </div>
  </div>

  <script>
    const searchInput = document.getElementById('searchInput');
    const roleFilter = document.getElementById('roleFilter');
    const hideDisabledToggle = document.getElementById('hideDisabledToggle');
    const tbody = document.querySelector('#usersTable tbody');
    let userRowsArray = Array.from(document.querySelectorAll('.user-row'));

    // --- Filter Logic ---
    function filterTable() {
        const query = searchInput.value.toLowerCase().trim();
        const role = roleFilter.value;
        const hideDisabled = hideDisabledToggle.checked;

        userRowsArray.forEach(row => {
            const rowRole = row.getAttribute('data-role');
            const matchesSearch = row.getAttribute('data-search').includes(query);
            const matchesRole = (role === 'ALL' || rowRole === role);
            const matchesDisabledFilter = !(hideDisabled && rowRole === 'disabled');
            
            if (matchesSearch && matchesRole && matchesDisabledFilter) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    searchInput.addEventListener('input', filterTable);
    roleFilter.addEventListener('change', filterTable);
    hideDisabledToggle.addEventListener('change', filterTable);
    
    // Initial Filter pass to hide deactivated users by default
    filterTable();

    // --- Sort Logic ---
    let currentSortCol = null;
    let currentSortDir = 'asc';

    // Initialize Icons
    document.querySelectorAll('.neon-table th[data-sort] .sort-icon').forEach(icon => {
        icon.textContent = ' ⇅';
        icon.style.opacity = '0.3';
    });

    document.querySelectorAll('.neon-table th[data-sort]').forEach(th => {
        th.addEventListener('click', () => {
            const sortKey = th.getAttribute('data-sort');
            
            // Direction toggle
            if (currentSortCol === sortKey) {
                currentSortDir = currentSortDir === 'asc' ? 'desc' : 'asc';
            } else {
                currentSortCol = sortKey;
                currentSortDir = 'asc';
            }

            // Update Header Styling
            document.querySelectorAll('.neon-table th[data-sort] .sort-icon').forEach(icon => {
                icon.textContent = ' ⇅';
                icon.style.opacity = '0.3';
            });
            const activeIcon = th.querySelector('.sort-icon');
            activeIcon.textContent = currentSortDir === 'asc' ? ' ▲' : ' ▼';
            activeIcon.style.opacity = '1';

            // Sort Array
            userRowsArray.sort((a, b) => {
                let valA = getCellValue(a, sortKey);
                let valB = getCellValue(b, sortKey);
                
                if (sortKey === 'date') {
                    valA = new Date(valA).getTime();
                    valB = new Date(valB).getTime();
                } else {
                    valA = valA.toLowerCase();
                    valB = valB.toLowerCase();
                }

                if (valA < valB) return currentSortDir === 'asc' ? -1 : 1;
                if (valA > valB) return currentSortDir === 'asc' ? 1 : -1;
                return 0;
            });

            // Reattach rows based on sorted array
            userRowsArray.forEach(row => tbody.appendChild(row));
        });
    });

    function getCellValue(row, sortKey) {
        const idxMap = { 'id': 0, 'name': 1, 'email': 2, 'date': 3, 'role': 4 };
        const idx = idxMap[sortKey];
        if (idx === undefined) return '';
        const td = row.children[idx];
        return td ? td.textContent.trim() : '';
    }

    // Modal Logic
    function openEditModal(userID, currentRpId, userName) {
        document.getElementById('editUserID').value = userID;
        const select = document.getElementById('editRpId');
        for(let i = 0; i < select.options.length; i++) {
            if(select.options[i].value === currentRpId) {
                select.options[i].selected = true;
                break;
            }
        }
        document.getElementById('editModalInfo').textContent = "Updating role for user: " + userName + " (" + userID + ")";
        document.getElementById('editModal').classList.add('active');
    }

    function openDeactivateModal(userID, userName) {
        document.getElementById('deactivateUserID').value = userID;
        document.getElementById('deactivateModalInfo').innerHTML = "Are you sure you want to deactivate <strong>" + userName + "</strong> (" + userID + ")?";
        document.getElementById('deactivateModal').classList.add('active');
    }

    function closeModals() {
        document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
    }
  </script>
</body>
</html>
