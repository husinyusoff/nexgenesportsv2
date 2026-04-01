<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>🔐 RBAC Manager – NexGen Esports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css"/>
</head>
<body class="rbac-page">
  <!-- global header -->
  <jsp:include page="/header.jsp"/>
  <button id="openToggle" class="open-toggle">☰</button>

  <div class="container">
    <div class="sidebar">
      <button id="closeToggle" class="close-toggle">×</button>
      <jsp:include page="/sidebar.jsp"/>
    </div>

    <div class="content">
      <div class="card rbac-card">
        <h2>RBAC Manager</h2>

        <c:if test="${param.ok == '1'}">
          <p class="success">✅ Permissions saved!</p>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/admin/rbac">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
          <table class="summary-table rbac-table">
            <thead>
              <tr>
                <th class="inh-col">
                  Page<br/><small>Inherit?</small>
                </th>
                <c:forEach var="rp" items="${rps}">
                  <th>
                    ${rp.role}
                    <c:if test="${not empty rp.position}">/ ${rp.position}</c:if>
                  </th>
                </c:forEach>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${pages}">
                <tr>
                  <td class="inh-col">
                    <input type="checkbox"
                           name="inherit_${p.pageId}"
                           <c:if test="${p.inheritPermission}">checked</c:if> />
                    <strong>${p.name}</strong><br/>
                    <small>${p.url}</small>
                  </td>
                  <c:forEach var="rp" items="${rps}">
                    <td>
                      <input type="checkbox"
                             name="perm_${p.pageId}_${rp.id}"
                             <c:if test="${perms[p.pageId] != null
                                           and perms[p.pageId].contains(rp.id)}">
                               checked
                             </c:if> />
                    </td>
                  </c:forEach>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <button type="submit" class="btn blue-btn" style="margin-top:1rem;">
            Save Changes
          </button>
        </form>
      </div>
    </div>
  </div>

  <jsp:include page="/footer.jsp"/>

  <script>
    document.getElementById('openToggle').onclick  =
      () => document.body.classList.remove('sidebar-collapsed');
    document.getElementById('closeToggle').onclick =
      () => document.body.classList.add('sidebar-collapsed');
  </script>
</body>
</html>
