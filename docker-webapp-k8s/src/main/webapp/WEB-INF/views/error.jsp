<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Something went wrong &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="code" value="${requestScope['javax.servlet.error.status_code']}"/>
<main class="center-page" style="min-height:100vh">
  <div class="card card-body status-card">
    <div class="code-big"><c:out value="${empty code ? 'Oops' : code}"/></div>
    <c:choose>
      <c:when test="${code == 404}">
        <h2>Page not found</h2>
        <p class="muted">The page you're looking for doesn't exist or has moved.</p>
      </c:when>
      <c:when test="${code == 403}">
        <h2>Access denied</h2>
        <p class="muted">You don't have permission to view this page.</p>
      </c:when>
      <c:otherwise>
        <h2>Something went wrong</h2>
        <p class="muted">An unexpected error occurred. Please try again in a moment.</p>
      </c:otherwise>
    </c:choose>
    <div class="row" style="justify-content:center">
      <a class="btn btn-primary" href="${contextPath}/welcome"><svg class="icon"><use href="${ico}#i-home"/></svg> Go to dashboard</a>
    </div>
  </div>
</main>
</body>
</html>
