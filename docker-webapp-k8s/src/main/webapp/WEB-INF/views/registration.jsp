<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Create account &middot; DevOps WebApp</title>
</head>
<body>
<div class="auth">
  <aside class="auth-side">
    <a class="brand" href="${contextPath}/index">
      <span class="brand-mark"><svg class="icon"><use href="${ico}#i-logo"/></svg></span>
      <span>DevOps WebApp<small>Cloud-native profile hub</small></span>
    </a>
    <div>
      <h1>Create your profile in a minute.</h1>
      <p>Sign up, add your skills and experience, and upload a photo.</p>
      <ul class="auth-points">
        <li><span class="tick"><svg class="icon"><use href="${ico}#i-check"/></svg></span> Free, no credit card</li>
        <li><span class="tick"><svg class="icon"><use href="${ico}#i-briefcase"/></svg></span> Showcase your DevOps skills</li>
        <li><span class="tick"><svg class="icon"><use href="${ico}#i-lock"/></svg></span> Only you can edit your profile</li>
      </ul>
    </div>
    <p class="small" style="margin:0">&copy; DevOps WebApp</p>
  </aside>

  <main class="auth-main">
    <div class="auth-card">
      <h2>Create account</h2>
      <p class="muted">It only takes a few seconds.</p>

      <form:form method="POST" modelAttribute="userForm" novalidate="novalidate">
        <spring:bind path="username">
          <div class="field ${status.error ? 'has-error' : ''}">
            <label for="username">Username</label>
            <div class="input-wrap">
              <svg class="icon"><use href="${ico}#i-user"/></svg>
              <form:input path="username" id="username" cssClass="input" placeholder="6-32 letters, numbers, . _ -" autocomplete="username" autofocus="true"/>
            </div>
            <form:errors path="username" cssClass="field-error"/>
          </div>
        </spring:bind>

        <spring:bind path="userEmail">
          <div class="field ${status.error ? 'has-error' : ''}">
            <label for="userEmail">Email</label>
            <div class="input-wrap">
              <svg class="icon"><use href="${ico}#i-mail"/></svg>
              <form:input path="userEmail" id="userEmail" type="email" cssClass="input" placeholder="you@example.com" autocomplete="email"/>
            </div>
            <form:errors path="userEmail" cssClass="field-error"/>
          </div>
        </spring:bind>

        <spring:bind path="password">
          <div class="field ${status.error ? 'has-error' : ''}">
            <label for="password">Password</label>
            <div class="input-wrap">
              <svg class="icon"><use href="${ico}#i-lock"/></svg>
              <form:password path="password" id="password" cssClass="input" placeholder="At least 8 characters" autocomplete="new-password"/>
            </div>
            <form:errors path="password" cssClass="field-error"/>
          </div>
        </spring:bind>

        <spring:bind path="passwordConfirm">
          <div class="field ${status.error ? 'has-error' : ''}">
            <label for="passwordConfirm">Confirm password</label>
            <div class="input-wrap">
              <svg class="icon"><use href="${ico}#i-lock"/></svg>
              <form:password path="passwordConfirm" id="passwordConfirm" cssClass="input" placeholder="Repeat your password" autocomplete="new-password"/>
            </div>
            <form:errors path="passwordConfirm" cssClass="field-error"/>
          </div>
        </spring:bind>

        <button class="btn btn-primary btn-lg btn-block" type="submit">Create account <svg class="icon"><use href="${ico}#i-arrow-right"/></svg></button>
      </form:form>

      <p class="auth-foot">Already have an account? <a href="${contextPath}/login">Sign in</a></p>
    </div>
  </main>
</div>
</body>
</html>
