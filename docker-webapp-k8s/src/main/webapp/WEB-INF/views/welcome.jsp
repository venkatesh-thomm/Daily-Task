<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Dashboard &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="home"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>

<main class="page">
  <div class="container stack">

    <section class="welcome-banner row-between">
      <div>
        <h1>Hi <c:out value="${me}"/>, welcome back</h1>
        <p>Here's your profile at a glance. Keep it up to date so your team knows what you work on.</p>
      </div>
      <a class="btn btn-lg" style="background:#fff;color:var(--brand-1)" href="${contextPath}/user/${fn:escapeXml(me)}">
        <svg class="icon"><use href="${ico}#i-edit"/></svg> Edit profile
      </a>
    </section>

    <div class="dash">
      <!-- left: profile card -->
      <aside class="stack">
        <div class="card profile-card">
          <div class="profile-cover"></div>
          <div class="card-body" style="padding-top:0">
            <div class="avatar avatar-xl">
              <c:choose>
                <c:when test="${not empty user.profileImg}">
                  <img src="${contextPath}/profile/photo/${fn:escapeXml(me)}" alt="Profile photo">
                </c:when>
                <c:otherwise><c:out value="${fn:toUpperCase(fn:substring(me, 0, 1))}"/></c:otherwise>
              </c:choose>
            </div>
            <h2><c:out value="${me}"/></h2>
            <p class="muted small" style="margin-bottom:14px">
              <c:out value="${empty user.primaryOccupation ? 'Add your occupation' : user.primaryOccupation}"/>
            </p>
            <c:if test="${isAdmin}"><span class="badge badge-brand" style="margin-bottom:14px"><svg class="icon" style="width:14px;height:14px"><use href="${ico}#i-shield"/></svg> Administrator</span></c:if>

            <div style="text-align:left;margin-top:8px">
              <div class="row-between small" style="margin-bottom:8px">
                <strong>Profile completeness</strong><span class="muted"><c:out value="${completion}"/>%</span>
              </div>
              <div class="progress"><span style="width:${completion}%"></span></div>
              <c:if test="${completion < 100}">
                <p class="hint">Fill in the missing details to reach 100%.</p>
              </c:if>
            </div>
          </div>
          <div class="card-foot row" style="justify-content:center">
            <a class="btn btn-soft btn-sm" href="${contextPath}/upload"><svg class="icon"><use href="${ico}#i-camera"/></svg> Change photo</a>
          </div>
        </div>

        <div class="card">
          <div class="card-head"><h3>Skills</h3></div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty fn:trim(user.skills)}">
                <div class="chips">
                  <c:forEach var="s" items="${fn:split(user.skills, ', ')}">
                    <span class="chip"><c:out value="${s}"/></span>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise><p class="muted small" style="margin:0">No skills yet. <a href="${contextPath}/user/${fn:escapeXml(me)}">Add some</a>.</p></c:otherwise>
            </c:choose>
          </div>
        </div>
      </aside>

      <!-- right: details + actions + platform -->
      <section class="stack">
        <div class="grid grid-3">
          <div class="card card-body stat">
            <span class="icon-box"><svg class="icon"><use href="${ico}#i-server"/></svg></span>
            <div><div class="lbl">Served by pod</div><div class="val mono"><c:out value="${podName}"/></div></div>
          </div>
          <div class="card card-body stat">
            <span class="icon-box"><svg class="icon"><use href="${ico}#i-box"/></svg></span>
            <div><div class="lbl">Runtime</div><div class="val">Java <c:out value="${javaVersion}"/></div></div>
          </div>
          <div class="card card-body stat">
            <span class="icon-box"><svg class="icon"><use href="${ico}#i-activity"/></svg></span>
            <div><div class="lbl">Status</div><div class="val row" style="gap:8px"><span class="dot dot-live"></span> Healthy</div></div>
          </div>
        </div>

        <div class="card">
          <div class="card-head">
            <h3>About you</h3>
            <a class="btn btn-ghost btn-sm" href="${contextPath}/user/${fn:escapeXml(me)}"><svg class="icon"><use href="${ico}#i-edit"/></svg> Edit</a>
          </div>
          <div class="card-body grid grid-2" style="gap:0 32px">
            <ul class="kv">
              <li><span class="k"><svg class="icon"><use href="${ico}#i-mail"/></svg> Email</span><span class="v"><c:out value="${empty user.userEmail ? '-' : user.userEmail}"/></span></li>
              <li><span class="k"><svg class="icon"><use href="${ico}#i-phone"/></svg> Phone</span><span class="v"><c:out value="${empty user.phoneNumber ? '-' : user.phoneNumber}"/></span></li>
              <li><span class="k"><svg class="icon"><use href="${ico}#i-calendar"/></svg> Date of birth</span><span class="v"><c:out value="${empty user.dateOfBirth ? '-' : user.dateOfBirth}"/></span></li>
              <li><span class="k"><svg class="icon"><use href="${ico}#i-pin"/></svg> Address</span><span class="v"><c:out value="${empty user.permanentAddress ? '-' : user.permanentAddress}"/></span></li>
            </ul>
            <ul class="kv">
              <li><span class="k"><svg class="icon"><use href="${ico}#i-briefcase"/></svg> Occupation</span><span class="v"><c:out value="${empty user.primaryOccupation ? '-' : user.primaryOccupation}"/></span></li>
              <li><span class="k"><svg class="icon"><use href="${ico}#i-clock"/></svg> Experience</span><span class="v"><c:out value="${empty user.workingExperience ? '-' : user.workingExperience}"/><c:if test="${not empty user.workingExperience}"> yrs</c:if></span></li>
              <li><span class="k"><svg class="icon"><use href="${ico}#i-globe"/></svg> Nationality</span><span class="v"><c:out value="${empty user.nationality ? '-' : user.nationality}"/></span></li>
              <li><span class="k"><svg class="icon"><use href="${ico}#i-user"/></svg> Language</span><span class="v" style="text-transform:capitalize"><c:out value="${empty user.language ? '-' : user.language}"/></span></li>
            </ul>
          </div>
        </div>

        <div class="card">
          <div class="card-head"><h3>Quick actions</h3></div>
          <div class="card-body grid grid-2">
            <a class="action" href="${contextPath}/user/${fn:escapeXml(me)}">
              <span class="icon-box"><svg class="icon"><use href="${ico}#i-edit"/></svg></span>
              <div><strong>Update profile</strong><span>Personal, contact and work details</span></div>
              <svg class="icon chev"><use href="${ico}#i-chevron"/></svg>
            </a>
            <a class="action" href="${contextPath}/upload">
              <span class="icon-box"><svg class="icon"><use href="${ico}#i-camera"/></svg></span>
              <div><strong>Upload photo</strong><span>PNG, JPG, GIF or WebP up to 2 MB</span></div>
              <svg class="icon chev"><use href="${ico}#i-chevron"/></svg>
            </a>
            <c:if test="${isAdmin}">
              <a class="action" href="${contextPath}/users">
                <span class="icon-box"><svg class="icon"><use href="${ico}#i-users"/></svg></span>
                <div><strong>All users</strong><span>Browse every registered profile</span></div>
                <svg class="icon chev"><use href="${ico}#i-chevron"/></svg>
              </a>
              <a class="action" href="${contextPath}/user/rabbit">
                <span class="icon-box"><svg class="icon"><use href="${ico}#i-send"/></svg></span>
                <div><strong>RabbitMQ test</strong><span>Publish 20 test messages</span></div>
                <svg class="icon chev"><use href="${ico}#i-chevron"/></svg>
              </a>
              <a class="action" href="${contextPath}/user/elasticsearch">
                <span class="icon-box"><svg class="icon"><use href="${ico}#i-search"/></svg></span>
                <div><strong>Elasticsearch sync</strong><span>Index users into Elasticsearch</span></div>
                <svg class="icon chev"><use href="${ico}#i-chevron"/></svg>
              </a>
            </c:if>
          </div>
        </div>
      </section>
    </div>
  </div>
</main>

<c:if test="${param.updated != null}">
  <div class="toast" role="status"><svg class="icon"><use href="${ico}#i-check"/></svg> Profile updated</div>
</c:if>
<c:if test="${param.photo != null}">
  <div class="toast" role="status"><svg class="icon"><use href="${ico}#i-check"/></svg> Photo updated</div>
</c:if>

<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>
