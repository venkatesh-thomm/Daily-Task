<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/includes/head.jspf" %>
  <title>Profile photo &middot; DevOps WebApp</title>
</head>
<body>
<c:set var="activeNav" value="photo"/>
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>

<main class="center-page">
  <div class="card" style="max-width:480px;width:100%">
    <div class="card-head">
      <div>
        <h3>Profile photo</h3>
        <span class="muted small">PNG, JPG, GIF or WebP, up to 2 MB</span>
      </div>
    </div>
    <div class="card-body">
      <c:if test="${not empty error}">
        <div class="alert alert-err"><svg class="icon"><use href="${ico}#i-alert"/></svg> <c:out value="${error}"/></div>
      </c:if>

      <form action="${contextPath}/uploadFile?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
        <img id="preview" class="preview" alt="Preview">
        <label class="dropzone" id="drop">
          <input type="file" name="file" id="file" accept="image/png,image/jpeg,image/gif,image/webp" required>
          <span class="icon-box"><svg class="icon icon-lg"><use href="${ico}#i-upload"/></svg></span>
          <strong id="dropText">Drop an image here or click to browse</strong>
          <span class="muted small">A square image looks best</span>
        </label>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <div class="row" style="justify-content:flex-end;margin-top:20px">
          <a class="btn btn-ghost" href="${contextPath}/welcome">Cancel</a>
          <button class="btn btn-primary" type="submit"><svg class="icon"><use href="${ico}#i-upload"/></svg> Upload photo</button>
        </div>
      </form>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
<script>
  (function () {
    var file = document.getElementById('file'), drop = document.getElementById('drop');
    var preview = document.getElementById('preview'), text = document.getElementById('dropText');
    ['dragenter', 'dragover'].forEach(function (e) { drop.addEventListener(e, function () { drop.classList.add('drag'); }); });
    ['dragleave', 'drop'].forEach(function (e) { drop.addEventListener(e, function () { drop.classList.remove('drag'); }); });
    file.addEventListener('change', function () {
      var f = file.files[0];
      if (!f) { return; }
      text.textContent = f.name;
      var reader = new FileReader();
      reader.onload = function (ev) { preview.src = ev.target.result; preview.style.display = 'block'; };
      reader.readAsDataURL(f);
    });
  })();
</script>
</body>
</html>
