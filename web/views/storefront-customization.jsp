<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Tùy chỉnh Storefront</title>
</head>
<body>
<h2>Tùy chỉnh Storefront</h2>
<c:if test="${not empty currentLogo || not empty currentTheme}">
    <h3>Preview hiện tại</h3>
    <div style="display:flex;align-items:center;gap:16px;">
        <c:if test="${not empty currentLogo}">
            <div>
                <div>Logo hiện tại:</div>
                <img src="${pageContext.request.contextPath}${currentLogo}" alt="current logo" style="max-height:80px;border:1px solid #ccc;padding:4px;"/>
            </div>
        </c:if>
        <div>
            <div>Màu theme hiện tại:</div>
            <div style="width:120px;height:40px;border:1px solid #ccc;background:${currentTheme};"></div>
        </div>
    </div>
    <hr/>
</c:if>
<form method="post" action="storefront-customization" enctype="multipart/form-data">
    <label>Upload logo (PNG/JPG, max 5MB):</label><br>
    <input type="file" name="logoFile" accept="image/*"><br><br>
    <label>Chọn màu theme:</label><br>
    <input type="color" name="themeColor" value="#ffffff"><br><br>
    <input type="submit" value="Lưu thay đổi">
</form>
<c:if test="${not empty error}">
    <div style="color:red;">${error}</div>
</c:if>
<c:if test="${not empty success}">
    <div style="color:green;">${success}</div>
</c:if>
</body>
</html>
