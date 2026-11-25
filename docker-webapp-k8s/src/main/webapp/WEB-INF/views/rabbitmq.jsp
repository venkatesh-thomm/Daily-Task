<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>RabbitMQ &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="home"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<main class="center-page">
  <div class="card card-body status-card">
    <div class="status-icon"><svg class="icon"><use href="${ico}#i-send"/></svg></div>
    <h2>Messages published</h2>
    <p class="muted">20 test messages were sent to RabbitMQ.</p>
    <div class="grid grid-3" style="margin:22px 0">
      <div class="card card-body"><div class="stat" style="flex-direction:column;gap:2px"><div class="val">2</div><div class="lbl">Connections</div></div></div>
      <div class="card card-body"><div class="stat" style="flex-direction:column;gap:2px"><div class="val">6</div><div class="lbl">Channels</div></div></div>
      <div class="card card-body"><div class="stat" style="flex-direction:column;gap:2px"><div class="val">2</div><div class="lbl">Queues</div></div></div>
    </div>
    <a class="btn btn-ghost" href="${contextPath}/welcome"><svg class="icon"><use href="${ico}#i-arrow-left"/></svg> Back to dashboard</a>
  </div>
</main>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>
