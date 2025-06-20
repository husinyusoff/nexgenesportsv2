<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
  <body>
    <h2>Business Hours Configuration</h2>
    <form method="post">
      <table>
        <tr><th>Key</th><th>Value (0–23)</th></tr>
        <c:forEach var="k"
                   items="${fn:split(
                     'weekday_open,weekend_open,closing_hour,happy_start_offset,happy_end_hour', ','
                   )}">
          <tr>
            <td>${k}</td>
            <td>
              <input name="${k}"
                     value="${cfg.get(k)}"
                     size="3"/>
            </td>
          </tr>
        </c:forEach>
      </table>
      <button type="submit">Save</button>
    </form>
  </body>
</html>
