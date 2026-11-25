<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>DevOps WebApp &middot; Build, ship and run with confidence</title>
</head>
<body>

<header class="nav">
  <div class="container">
    <a class="brand" href="${contextPath}/index">
      <span class="brand-mark"><svg class="icon"><use href="${ico}#i-logo"/></svg></span>
      <span>DevOps WebApp<small>Cloud-native profile hub</small></span>
    </a>
    <nav class="nav-links">
      <a href="#features">Features</a>
      <a href="#stack">Tech stack</a>
      <a href="#how">How it runs</a>
    </nav>
    <div class="nav-right">
      <c:choose>
        <c:when test="${not empty me}">
          <a class="btn btn-primary" href="${contextPath}/welcome">Open dashboard <svg class="icon"><use href="${ico}#i-arrow-right"/></svg></a>
        </c:when>
        <c:otherwise>
          <a class="btn btn-ghost" href="${contextPath}/login">Sign in</a>
          <a class="btn btn-primary" href="${contextPath}/registration">Get started</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<section class="hero">
  <div class="container">
    <span class="eyebrow"><span class="dot dot-live"></span> Running on a highly-available Kubernetes cluster</span>
    <h1>Build, ship and run <span class="grad">with confidence</span></h1>
    <p>A Java web application packaged as Docker images and deployed across three availability zones with kops: autoscaling, self-healing and zero-downtime rollouts.</p>
    <div class="hero-cta">
      <a class="btn btn-primary btn-lg" href="${contextPath}/registration">Create a free account <svg class="icon"><use href="${ico}#i-arrow-right"/></svg></a>
      <a class="btn btn-ghost btn-lg" href="${contextPath}/login">I already have an account</a>
    </div>
    <div class="pipeline" aria-label="Delivery pipeline">
      <span class="stage"><svg class="icon"><use href="${ico}#i-branch"/></svg> Code</span><span class="arrow">&rarr;</span>
      <span class="stage"><svg class="icon"><use href="${ico}#i-zap"/></svg> Build</span><span class="arrow">&rarr;</span>
      <span class="stage"><svg class="icon"><use href="${ico}#i-box"/></svg> Containerise</span><span class="arrow">&rarr;</span>
      <span class="stage"><svg class="icon"><use href="${ico}#i-layers"/></svg> Orchestrate</span><span class="arrow">&rarr;</span>
      <span class="stage"><svg class="icon"><use href="${ico}#i-activity"/></svg> Observe</span>
    </div>
  </div>
</section>

<section class="section" id="features">
  <div class="container">
    <div class="section-head">
      <span class="kicker">Why it's built this way</span>
      <h2>Production habits, in a simple app</h2>
      <p class="muted">Every layer is designed to stay up when something underneath it fails.</p>
    </div>
    <div class="grid grid-3">
      <div class="card card-body card-hover feature">
        <div class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-box"/></svg></div>
        <h3>Containerised</h3>
        <p>Multi-stage Docker build, a slim non-root Tomcat runtime and configuration injected at runtime, so no secrets live in the image.</p>
      </div>
      <div class="card card-body card-hover feature">
        <div class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-layers"/></svg></div>
        <h3>Highly available</h3>
        <p>Three control-plane nodes and app replicas spread across availability zones, behind an AWS load balancer.</p>
      </div>
      <div class="card card-body card-hover feature">
        <div class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-zap"/></svg></div>
        <h3>Autoscaling</h3>
        <p>The Horizontal Pod Autoscaler adds pods under load; the cluster autoscaler adds nodes when pods need room.</p>
      </div>
      <div class="card card-body card-hover feature">
        <div class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-shield"/></svg></div>
        <h3>Secure by default</h3>
        <p>Restricted pod security, network policies, hashed passwords, CSRF protection and role-based pages.</p>
      </div>
      <div class="card card-body card-hover feature">
        <div class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-activity"/></svg></div>
        <h3>Health-checked</h3>
        <p>Startup, readiness and liveness probes on a dedicated health endpoint keep traffic away from pods that aren't ready.</p>
      </div>
      <div class="card card-body card-hover feature">
        <div class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-database"/></svg></div>
        <h3>Persistent data</h3>
        <p>MySQL on an encrypted EBS volume that survives pod restarts and node replacement.</p>
      </div>
    </div>
  </div>
</section>

<section class="section" id="stack" style="background:#fff; border-top:1px solid var(--line); border-bottom:1px solid var(--line);">
  <div class="container">
    <div class="section-head">
      <span class="kicker">Tech stack</span>
      <h2>Tools behind the pipeline</h2>
    </div>
    <div class="tech-grid">
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/git.jpg" alt=""><span>Git</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/jenkins.png" alt=""><span>Jenkins</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/docker.png" alt=""><span>Docker</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/aws.png" alt=""><span>AWS</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/Ansible_logo.png" alt=""><span>Ansible</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/puppet.jpg" alt=""><span>Puppet</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/Vagrant.png" alt=""><span>Vagrant</span></div>
      <div class="tech"><img src="${contextPath}/resources/Images/technologies/python-logo.png" alt=""><span>Python</span></div>
    </div>
  </div>
</section>

<section class="section" id="how">
  <div class="container">
    <div class="section-head">
      <span class="kicker">How it runs</span>
      <h2>From commit to cluster</h2>
    </div>
    <div class="grid grid-4">
      <div class="card card-body"><span class="badge badge-brand">01</span><h3 style="margin-top:12px">Build</h3><p class="muted small" style="margin:0">Maven compiles the WAR inside a build container.</p></div>
      <div class="card card-body"><span class="badge badge-brand">02</span><h3 style="margin-top:12px">Package</h3><p class="muted small" style="margin:0">The WAR is copied into a slim Tomcat image and pushed to a registry.</p></div>
      <div class="card card-body"><span class="badge badge-brand">03</span><h3 style="margin-top:12px">Deploy</h3><p class="muted small" style="margin:0">Kubernetes rolls new pods out one at a time, with zero downtime.</p></div>
      <div class="card card-body"><span class="badge badge-brand">04</span><h3 style="margin-top:12px">Operate</h3><p class="muted small" style="margin:0">Probes, autoscaling and disruption budgets keep it healthy.</p></div>
    </div>
    <div class="cta-band" style="margin-top:56px">
      <div>
        <h2>Ready to try it?</h2>
        <p>Create an account and see which pod serves your request in the footer.</p>
      </div>
      <a class="btn btn-lg" href="${contextPath}/registration">Get started <svg class="icon"><use href="${ico}#i-arrow-right"/></svg></a>
    </div>
  </div>
</section>

<c:set var="footerDark" value="${true}"/>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>
