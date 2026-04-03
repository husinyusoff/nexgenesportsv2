<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>👤 Manage Users – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css"/>
  <style>
    .user-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
    }
    .user-table th, .user-table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid rgba(255,255,255,0.1);
    }
    .user-table th {
      background-color: rgba(255,255,255,0.05);
      color: var(--neon-cyan);
      text-transform: uppercase;
      font-size: 0.85rem;
      letter-spacing: 1px;
    }
    .user-table tr:hover {
      background-color: rgba(255,255,255,0.02);
    }
    .role-form {
      display: flex;
      gap: 10px;
      align-items: center;
    }
    .role-form select {
      flex: 1;
      min-width: 150px;
    }
    .btn-sm {
      padding: 6px 12px;
      font-size: 0.8rem;
    }
  </style>
</head>
<body class="admin-users-page">
  <!-- global header -->
  <jsp:include page="/header.jsp"/>
  <button id="openToggle" class="open-toggle">☰</button>

  <div class="container">
    <div class="sidebar">
      <button id="closeToggle" class="close-toggle">×</button>
      <jsp:include page="/sidebar.jsp"/>
    </div>

    <div class="content">
      <div class="card">
        <h2>👤 Manage Registered Users</h2>
        <p class="subtitle">Review and update user roles and permissions.</p>

        <c:if test="${not empty sessionScope.adminSuccessMsg}">
          <p class="success-msg" style="color: var(--neon-cyan); margin: 10px 0;">
            ✅ ${sessionScope.adminSuccessMsg}
          </p>
          <c:remove var="adminSuccessMsg" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.adminErrorMsg}">
          <p class="error-msg" style="color: var(--neon-pink); margin: 10px 0;">
            ❌ ${sessionScope.adminErrorMsg}
          </p>
          <c:remove var="adminErrorMsg" scope="session"/>
        </c:if>

        <div style="overflow-x: auto;">
          <table class="user-table">
            <thead>
              <tr>
                <th>Username (ID)</th>
                <th>Name</th>
                <th>Email</th>
                <th>Registered On</th>
                <th>Current Role</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="user" items="${usersList}">
                <tr>
                  <td><strong>${user.userID}</strong></td>
                  <td>${user.name}</td>
                  <td><a href="mailto:${user.email}" style="color: var(--neon-cyan);">${user.email}</a></td>
                  <td>
                    ${user.registrationDate.toLocalDate()}
                  </td>
                  <td>
                    <span class="badge" style="background: rgba(0,255,255,0.1); padding: 4px 8px; border-radius: 4px;">
                      ${user.position != null ? user.position : 'Member'}
                    </span>
                  </td>
                  <td>
                    <form action="${pageContext.request.contextPath}/admin/users" method="post" class="role-form">
                      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                      <input type="hidden" name="action" value="updateRole">
                      <input type="hidden" name="targetUserID" value="${user.userID}">
                      
                      <select name="rpId" required>
                        <c:forEach var="role" items="${rolesList}">
                          <option value="${role.id}" <c:if test="${role.id == user.rpId}">selected</c:if>>
                            ${role.role} <c:if test="${not empty role.position}"> - ${role.position}</c:if>
                          </option>
                        </c:forEach>
                      </select>
                      <button type="submit" class="btn blue-btn btn-sm">Update</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty usersList}">
                <tr>
                  <td colspan="6" style="text-align: center; padding: 2rem;">No users found.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="/footer.jsp"/>

  <script>
    document.getElementById('openToggle').addEventListener('click', () => {
      document.body.classList.remove('sidebar-collapsed');
    });
    document.getElementById('closeToggle').addEventListener('click', () => {
      document.body.classList.add('sidebar-collapsed');
    });
  </script>
</body>
</html>
