<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Sign in &middot; DevOps WebApp</title>
</head>
<body>
<div class="auth">
  <aside class="auth-side">
    <a class="brand" href="${contextPath}/index">
      <span class="brand-mark"><svg class="icon"><use href="${ico}#i-logo"/></svg></span>
      <span>DevOps WebApp<small>Cloud-native profile hub</small></span>
    </a>
    <div>
      <h1>Welcome back.</h1>
      <p>Sign in to manage your profile on an app that's built, shipped and scaled the DevOps way.</p>
      <ul class="auth-points">
        <li><span class="tick"><svg class="icon"><use href="${ico}#i-layers"/></svg></span> Runs across 3 availability zones</li>
        <li><span class="tick"><svg class="icon"><use href="${ico}#i-zap"/></svg></span> Scales automatically with traffic</li>
        <li><span class="tick"><svg class="icon"><use href="${ico}#i-shield"/></svg></span> Passwords hashed with BCrypt</li>
      </ul>
    </div>
    <p class="small" style="margin:0">&copy; DevOps WebApp</p>
  </aside>

  <main class="auth-main">
    <div class="auth-card">
      <h2>Sign in</h2>
      <p class="muted">Enter your username and password to continue.</p>

      <c:if test="${not empty message}">
        <div class="alert alert-ok"><svg class="icon"><use href="${ico}#i-check"/></svg> <c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-err"><svg class="icon"><use href="${ico}#i-alert"/></svg> <c:out value="${error}"/></div>
      </c:if>

      <form method="POST" action="${contextPath}/login">
        <div class="field ${not empty error ? 'has-error' : ''}">
          <label for="username">Username</label>
          <div class="input-wrap">
            <svg class="icon"><use href="${ico}#i-user"/></svg>
            <input id="username" name="username" type="text" class="input" placeholder="your.username" autocomplete="username" autofocus required>
          </div>
        </div>
        <div class="field ${not empty error ? 'has-error' : ''}">
          <label for="password">Password</label>
          <div class="input-wrap">
            <svg class="icon"><use href="${ico}#i-lock"/></svg>
            <input id="password" name="password" type="password" class="input" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" autocomplete="current-password" required>
          </div>
        </div>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button class="btn btn-primary btn-lg btn-block" type="submit">Sign in <svg class="icon"><use href="${ico}#i-arrow-right"/></svg></button>
      </form>

      <div class="divider-text">New here?</div>
      <a class="btn btn-ghost btn-lg btn-block" href="${contextPath}/registration">Create an account</a>
      <p class="auth-foot"><a href="${contextPath}/index">&larr; Back to home</a></p>
    </div>
  </main>
</div>
</body>
</html>
