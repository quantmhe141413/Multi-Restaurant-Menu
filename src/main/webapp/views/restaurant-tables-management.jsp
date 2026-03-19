<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Restaurant Tables Management</title>
</head>
<body>
<h2>Restaurant Tables Management</h2>

<h3>Thêm bàn mới</h3>
<form method="post" action="restaurant-tables">
    <input type="hidden" name="action" value="create" />
    <label>Số bàn: <input type="text" name="tableNumber" required/></label>
    <label>Sức chứa: <input type="number" name="capacity" value="2" min="1" required/></label>
    <label>Trạng thái: 
        <select name="tableStatus">
            <option value="Available">Available</option>
            <option value="Occupied">Occupied</option>
            <option value="Reserved">Reserved</option>
        </select>
    </label>
    <button type="submit">Thêm</button>
</form>

<h3>Danh sách bàn</h3>
<table border="1" cellpadding="6" cellspacing="0">
    <tr><th>STT</th><th>Số bàn</th><th>Sức chứa</th><th>Trạng thái</th><th>Hành động</th></tr>
    <c:forEach var="t" items="${tables}" varStatus="s">
        <tr>
            <td>${s.index + 1}</td>
            <td>${t.tableNumber}</td>
            <td>${t.capacity}</td>
            <td>${t.tableStatus}</td>
            <td>
                <form method="post" action="restaurant-tables" style="display:inline-block;">
                    <input type="hidden" name="action" value="toggle" />
                    <input type="hidden" name="tableId" value="${t.tableID}" />
                    <input type="hidden" name="active" value="${t.isActive ? 0 : 1}" />
                    <button type="submit">${t.isActive ? 'Deactivate' : 'Activate'}</button>
                </form>
                <form method="post" action="restaurant-tables" style="display:inline-block;">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="tableId" value="${t.tableID}" />
                    <input type="text" name="tableNumber" value="${t.tableNumber}" />
                    <input type="number" name="capacity" value="${t.capacity}" min="1" />
                    <select name="tableStatus">
                        <option value="Available" ${t.tableStatus == 'Available' ? 'selected' : ''}>Available</option>
                        <option value="Occupied" ${t.tableStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                        <option value="Reserved" ${t.tableStatus == 'Reserved' ? 'selected' : ''}>Reserved</option>
                    </select>
                    <button type="submit">Cập nhật</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>
