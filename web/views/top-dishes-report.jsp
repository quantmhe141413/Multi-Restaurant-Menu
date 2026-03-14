<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Báo cáo món bán chạy</title>
</head>
<body>
<h2>Báo cáo món bán chạy</h2>
<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>STT</th>
        <th>Tên món</th>
        <th>Số lượng bán</th>
    </tr>
    <c:forEach var="dish" items="${topDishes}" varStatus="status">
        <tr>
            <td>${status.index + 1}</td>
            <td>${dish.itemName}</td>
            <td>${dish.totalSold}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
