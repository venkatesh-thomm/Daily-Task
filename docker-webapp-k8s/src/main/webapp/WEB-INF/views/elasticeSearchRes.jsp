<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Elasticsearch &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="home"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<main class="center-page">
  <div class="card card-body status-card">
    <div class="status-icon brand"><svg class="icon"><use href="${ico}#i-search"/></svg></div>
    <h2>Elasticsearch sync</h2>
    <p class="muted">User data is <strong><c:out value="${result}"/></strong> into Elasticsearch.</p>
    <p class="small muted">Verify it at <span class="mono">http://&lt;elasticsearch-host&gt;:9200/users/user/&lt;id&gt;</span></p>
    <a class="btn btn-ghost" href="${contextPath}/welcome"><svg class="icon"><use href="${ico}#i-arrow-left"/></svg> Back to dashboard</a>
  </div>
</main>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>
