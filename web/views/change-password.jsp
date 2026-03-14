<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đổi mật khẩu</title>
</head>
<body>
<h2>Đổi mật khẩu</h2>
<form method="post" action="change-password">
    <label>Mật khẩu cũ:</label><br>
    <input type="password" name="oldPassword" required><br>
    <label>Mật khẩu mới:</label><br>
    <input type="password" name="newPassword" required><br>
    <label>Nhập lại mật khẩu mới:</label><br>
    <input type="password" name="confirmPassword" required><br><br>
    <input type="submit" value="Đổi mật khẩu">
</form>
<c:if test="${not empty error}">
    <div style="color:red;">${error}</div>
</c:if>
<c:if test="${not empty success}">
    <div style="color:green;">${success}</div>
</c:if>
</body>
</html>
