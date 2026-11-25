<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title><c:out value="${user.username}"/> &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="users"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>

<main class="page">
  <div class="container" style="max-width:960px">
    <a class="small" href="${contextPath}/users">&larr; All users</a>

    <c:choose>
      <c:when test="${empty user}">
        <div class="card card-body" style="margin-top:16px;text-align:center">
          <h2>User not found</h2>
          <p class="muted">This profile doesn't exist or was removed.</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="card profile-card" style="margin-top:12px;text-align:left">
          <div class="profile-cover"></div>
          <div class="card-body row-between" style="padding-top:0;align-items:flex-end">
            <div class="row" style="align-items:flex-end;gap:18px">
              <div class="avatar avatar-xl" style="margin:-48px 0 0">
                <c:choose>
                  <c:when test="${not empty user.profileImg}"><img src="${contextPath}/profile/photo/${fn:escapeXml(user.username)}" alt=""></c:when>
                  <c:otherwise><c:out value="${fn:toUpperCase(fn:substring(user.username, 0, 1))}"/></c:otherwise>
                </c:choose>
              </div>
              <div>
                <h2 style="margin:0"><c:out value="${user.username}"/></h2>
                <span class="muted small"><c:out value="${empty user.primaryOccupation ? 'No occupation set' : user.primaryOccupation}"/></span>
              </div>
            </div>
            <c:choose>
              <c:when test="${fromCache}">
                <span class="badge badge-ok" title="Served from Memcached"><svg class="icon" style="width:14px;height:14px"><use href="${ico}#i-zap"/></svg> From cache</span>
              </c:when>
              <c:otherwise>
                <span class="badge badge-brand" title="Loaded from MySQL"><svg class="icon" style="width:14px;height:14px"><use href="${ico}#i-database"/></svg> From database</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="grid grid-2" style="margin-top:20px">
          <div class="card">
            <div class="card-head"><h3>Contact &amp; personal</h3></div>
            <div class="card-body">
              <ul class="kv">
                <li><span class="k">User ID</span><span class="v mono"><c:out value="${user.id}"/></span></li>
                <li><span class="k">Email</span><span class="v"><c:out value="${empty user.userEmail ? '-' : user.userEmail}"/></span></li>
                <li><span class="k">Phone</span><span class="v"><c:out value="${empty user.phoneNumber ? '-' : user.phoneNumber}"/></span></li>
                <li><span class="k">Alternate phone</span><span class="v"><c:out value="${empty user.secondaryPhoneNumber ? '-' : user.secondaryPhoneNumber}"/></span></li>
                <li><span class="k">Date of birth</span><span class="v"><c:out value="${empty user.dateOfBirth ? '-' : user.dateOfBirth}"/></span></li>
                <li><span class="k">Gender</span><span class="v" style="text-transform:capitalize"><c:out value="${empty user.gender ? '-' : user.gender}"/></span></li>
                <li><span class="k">Father's name</span><span class="v"><c:out value="${empty user.fatherName ? '-' : user.fatherName}"/></span></li>
                <li><span class="k">Mother's name</span><span class="v"><c:out value="${empty user.motherName ? '-' : user.motherName}"/></span></li>
              </ul>
            </div>
          </div>
          <div class="card">
            <div class="card-head"><h3>Work &amp; location</h3></div>
            <div class="card-body">
              <ul class="kv">
                <li><span class="k">Primary occupation</span><span class="v"><c:out value="${empty user.primaryOccupation ? '-' : user.primaryOccupation}"/></span></li>
                <li><span class="k">Secondary occupation</span><span class="v"><c:out value="${empty user.secondaryOccupation ? '-' : user.secondaryOccupation}"/></span></li>
                <li><span class="k">Experience</span><span class="v"><c:out value="${empty user.workingExperience ? '-' : user.workingExperience}"/></span></li>
                <li><span class="k">Nationality</span><span class="v"><c:out value="${empty user.nationality ? '-' : user.nationality}"/></span></li>
                <li><span class="k">Language</span><span class="v" style="text-transform:capitalize"><c:out value="${empty user.language ? '-' : user.language}"/></span></li>
                <li><span class="k">Permanent address</span><span class="v"><c:out value="${empty user.permanentAddress ? '-' : user.permanentAddress}"/></span></li>
                <li><span class="k">Current address</span><span class="v"><c:out value="${empty user.tempAddress ? '-' : user.tempAddress}"/></span></li>
              </ul>
            </div>
          </div>
        </div>

        <div class="card" style="margin-top:20px">
          <div class="card-head"><h3>Skills</h3></div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty fn:trim(user.skills)}">
                <div class="chips"><c:forEach var="s" items="${fn:split(user.skills, ', ')}"><span class="chip"><c:out value="${s}"/></span></c:forEach></div>
              </c:when>
              <c:otherwise><span class="muted small">No skills listed.</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</main>

<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>
