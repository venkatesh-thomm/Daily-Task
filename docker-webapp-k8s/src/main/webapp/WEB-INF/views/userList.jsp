<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Users &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="users"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>

<main class="page">
  <div class="container">
    <div class="row-between" style="margin-bottom:22px">
      <div>
        <h1>Users</h1>
        <p class="muted" style="margin:0"><c:out value="${fn:length(users)}"/> registered profiles</p>
      </div>
      <div class="input-wrap search">
        <svg class="icon"><use href="${ico}#i-search"/></svg>
        <input id="filter" class="input" type="search" placeholder="Search name, email, role..." aria-label="Search users">
      </div>
    </div>

    <div class="card">
      <div class="table-wrap">
        <table class="table" id="users">
          <thead>
            <tr><th>User</th><th>Occupation</th><th>Skills</th><th style="width:1%"></th></tr>
          </thead>
          <tbody>
            <c:forEach items="${users}" var="u">
              <tr>
                <td>
                  <div class="row">
                    <span class="avatar"><c:out value="${fn:toUpperCase(fn:substring(u.username, 0, 1))}"/></span>
                    <div>
                      <strong><c:out value="${u.username}"/></strong>
                      <div class="muted small"><c:out value="${empty u.userEmail ? 'No email' : u.userEmail}"/></div>
                    </div>
                  </div>
                </td>
                <td><c:out value="${empty u.primaryOccupation ? '-' : u.primaryOccupation}"/></td>
                <td>
                  <div class="chips">
                    <c:if test="${not empty fn:trim(u.skills)}">
                      <c:forEach var="s" items="${fn:split(u.skills, ', ')}" end="2">
                        <span class="chip"><c:out value="${s}"/></span>
                      </c:forEach>
                    </c:if>
                  </div>
                </td>
                <td><a href="${contextPath}/users/${u.id}" class="btn btn-soft btn-sm">View <svg class="icon"><use href="${ico}#i-chevron"/></svg></a></td>
              </tr>
            </c:forEach>
            <c:if test="${empty users}">
              <tr><td colspan="4" class="muted" style="text-align:center;padding:40px">No users yet.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
<script>
  (function () {
    var input = document.getElementById('filter');
    var rows = document.querySelectorAll('#users tbody tr');
    input.addEventListener('input', function () {
      var q = input.value.toLowerCase();
      rows.forEach(function (r) { r.style.display = r.textContent.toLowerCase().indexOf(q) > -1 ? '' : 'none'; });
    });
  })();
</script>
</body>
</html>
