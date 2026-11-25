<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Edit profile &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="profile"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>

<main class="page">
  <div class="container" style="max-width:860px">
    <div class="row-between" style="margin-bottom:22px">
      <div>
        <a class="small" href="${contextPath}/welcome">&larr; Back to dashboard</a>
        <h1 style="margin-top:6px">Edit profile</h1>
        <p class="muted" style="margin:0">Changes are saved to the database and visible on your dashboard.</p>
      </div>
    </div>

    <form:form method="POST" modelAttribute="user" cssClass="card">

      <div class="form-section">
        <div class="form-section-title">
          <span class="icon-box"><svg class="icon"><use href="${ico}#i-user"/></svg></span>
          <div><h3 style="margin:0">Account</h3><span class="muted small">Your sign-in identity</span></div>
        </div>
        <div class="form-grid">
          <div class="field">
            <label for="username">Username</label>
            <form:input path="username" id="username" cssClass="input" readonly="true"/>
            <p class="hint">Usernames can't be changed.</p>
          </div>
          <div class="field">
            <label for="userEmail">Email</label>
            <form:input path="userEmail" id="userEmail" type="email" cssClass="input" placeholder="you@example.com"/>
          </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-title">
          <span class="icon-box"><svg class="icon"><use href="${ico}#i-calendar"/></svg></span>
          <div><h3 style="margin:0">Personal</h3><span class="muted small">A little about you</span></div>
        </div>
        <div class="form-grid">
          <div class="field">
            <label for="dateOfBirth">Date of birth</label>
            <form:input path="dateOfBirth" id="dateOfBirth" cssClass="input" placeholder="dd/mm/yyyy"/>
          </div>
          <div class="field">
            <label for="nationality">Nationality</label>
            <form:input path="nationality" id="nationality" cssClass="input" placeholder="e.g. Indian"/>
          </div>
          <div class="field">
            <label for="fatherName">Father's name</label>
            <form:input path="fatherName" id="fatherName" cssClass="input"/>
          </div>
          <div class="field">
            <label for="motherName">Mother's name</label>
            <form:input path="motherName" id="motherName" cssClass="input"/>
          </div>
          <div class="field">
            <span class="label">Gender</span>
            <div class="pills">
              <form:radiobutton path="gender" value="male" id="g-male"/><label for="g-male">Male</label>
              <form:radiobutton path="gender" value="female" id="g-female"/><label for="g-female">Female</label>
              <form:radiobutton path="gender" value="other" id="g-other"/><label for="g-other">Other</label>
            </div>
          </div>
          <div class="field">
            <span class="label">Marital status</span>
            <div class="pills">
              <form:radiobutton path="maritalStatus" value="unMarried" id="m-single"/><label for="m-single">Single</label>
              <form:radiobutton path="maritalStatus" value="married" id="m-married"/><label for="m-married">Married</label>
            </div>
          </div>
          <div class="field span-2">
            <span class="label">Mother tongue</span>
            <div class="pills">
              <form:radiobutton path="language" value="english" id="l-en"/><label for="l-en">English</label>
              <form:radiobutton path="language" value="hindi" id="l-hi"/><label for="l-hi">Hindi</label>
              <form:radiobutton path="language" value="spanish" id="l-es"/><label for="l-es">Spanish</label>
              <form:radiobutton path="language" value="german" id="l-de"/><label for="l-de">German</label>
              <form:radiobutton path="language" value="other" id="l-other"/><label for="l-other">Other</label>
            </div>
          </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-title">
          <span class="icon-box"><svg class="icon"><use href="${ico}#i-phone"/></svg></span>
          <div><h3 style="margin:0">Contact</h3><span class="muted small">How people can reach you</span></div>
        </div>
        <div class="form-grid">
          <div class="field">
            <label for="phoneNumber">Phone</label>
            <form:input path="phoneNumber" id="phoneNumber" type="tel" cssClass="input" placeholder="+91 98765 43210"/>
          </div>
          <div class="field">
            <label for="secondaryPhoneNumber">Alternate phone</label>
            <form:input path="secondaryPhoneNumber" id="secondaryPhoneNumber" type="tel" cssClass="input"/>
          </div>
          <div class="field span-2">
            <label for="permanentAddress">Permanent address</label>
            <form:input path="permanentAddress" id="permanentAddress" cssClass="input" placeholder="Street, area, city"/>
          </div>
          <div class="field span-2">
            <label for="tempAddress">Current address</label>
            <form:input path="tempAddress" id="tempAddress" cssClass="input" placeholder="Street, area, city"/>
          </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-title">
          <span class="icon-box"><svg class="icon"><use href="${ico}#i-briefcase"/></svg></span>
          <div><h3 style="margin:0">Professional</h3><span class="muted small">What you do and what you know</span></div>
        </div>
        <div class="form-grid">
          <div class="field">
            <label for="primaryOccupation">Primary occupation</label>
            <form:input path="primaryOccupation" id="primaryOccupation" cssClass="input" placeholder="e.g. DevOps Engineer"/>
          </div>
          <div class="field">
            <label for="secondaryOccupation">Secondary occupation</label>
            <form:input path="secondaryOccupation" id="secondaryOccupation" cssClass="input"/>
          </div>
          <div class="field">
            <label for="workingExperience">Experience (years)</label>
            <form:input path="workingExperience" id="workingExperience" inputmode="numeric" cssClass="input" placeholder="e.g. 5"/>
          </div>
          <div class="field">
            <label for="skills">Skills</label>
            <form:input path="skills" id="skills" cssClass="input" placeholder="Docker, Kubernetes, Terraform"/>
            <p class="hint">Separate skills with commas.</p>
          </div>
        </div>
      </div>

      <div class="card-foot row" style="justify-content:flex-end">
        <a href="${contextPath}/welcome" class="btn btn-ghost">Cancel</a>
        <button class="btn btn-primary" type="submit"><svg class="icon"><use href="${ico}#i-check"/></svg> Save changes</button>
      </div>
    </form:form>
  </div>
</main>

<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>
