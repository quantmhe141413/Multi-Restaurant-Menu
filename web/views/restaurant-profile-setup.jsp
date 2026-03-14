<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thiết lập hồ sơ nhà hàng</title>
</head>
<body>
<h2>Thiết lập hồ sơ nhà hàng</h2>
<form method="post" action="restaurant-profile-setup">
    <label>Tên nhà hàng:</label><br>
    <input type="text" name="name" required><br>
    <label>Địa chỉ:</label><br>
    <input type="text" name="address" required><br>
    <label>Số điện thoại:</label><br>
    <input type="text" name="phone" required><br>
    <label>Mô tả:</label><br>
    <textarea name="description" rows="4" cols="40"></textarea><br><br>
    <input type="submit" value="Lưu hồ sơ">
</form>
<p>
    <a href="business-license-upload">Tải giấy phép kinh doanh lên</a>
</p>
<c:if test="${not empty success}">
    <div style="color:green;">${success}</div>
</c:if>
</body>
</html>
