<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Upload giấy phép kinh doanh</title>
</head>
<body>
<h2>Upload giấy phép kinh doanh</h2>
<form method="post" action="business-license-upload" enctype="multipart/form-data">
    <label>Chọn file giấy phép (PDF/JPG/PNG):</label><br>
    <input type="file" name="licenseFile" accept="application/pdf,image/*" required><br><br>
    <input type="submit" value="Upload">
</form>
<c:if test="${not empty error}">
    <div style="color:red;">${error}</div>
</c:if>
<c:if test="${not empty success}">
    <div style="color:green;">${success}</div>
</c:if>
</body>
</html>
