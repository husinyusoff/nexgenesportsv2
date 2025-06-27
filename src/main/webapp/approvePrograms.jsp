<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Pending Approvals</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>
  <h1>Pending Programs for Approval</h1>

  <table border="1" cellpadding="5" cellspacing="0">
    <thead>
      <tr><th>ID</th><th>Name</th><th>Creator</th><th>Dates</th><th>Actions</th></tr>
    </thead>
    <tbody>
      <c:forEach var="p" items="${pending}">
        <tr>
          <td>${p.progID}</td>
          <td>${p.programName}</td>
          <td>${p.creatorId}</td>
          <td>${p.startDate} → ${p.endDate}</td>
          <td>
            <form action="${pageContext.request.contextPath}/programs/${p.progID}/approve"
                  method="post" style="display:inline;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <button type="submit">Approve</button>
            </form>
            &nbsp;
            <form action="${pageContext.request.contextPath}/programs/${p.progID}/delete"
                  method="post" style="display:inline;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <button type="submit" onclick="return confirm('Reject & delete?')">Reject</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <p style="margin-top:1em;">
    <a href="${pageContext.request.contextPath}/programs">← Back to Programs</a>
  </p>
</body>
</html>
