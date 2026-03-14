<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>Menu Management Dashboard</title>
</head>
<body>
<h2>Menu Management Dashboard</h2>
<form method="get" action="menu-management-dashboard">
    <label>Start date: <input type="date" name="startDate" value="${param.startDate}"/></label>
    <label>End date: <input type="date" name="endDate" value="${param.endDate}"/></label>
    <label>Category:
        <select name="categoryId">
            <option value="">All</option>
            <c:forEach var="c" items="${categories}">
                <option value="${c.categoryID}" <c:if test="${param.categoryId == c.categoryID}">selected</c:if>>${c.categoryName}</option>
            </c:forEach>
        </select>
    </label>
    <input type="submit" value="Filter"/>
</form>

<h3>Top Selling Items</h3>
<table border="1" cellpadding="6" cellspacing="0">
    <tr><th>STT</th><th>Tên món</th><th>Số lượng bán</th></tr>
    <c:forEach var="d" items="${topDishes}" varStatus="s">
        <tr>
            <td>${s.index + 1}</td>
            <td>${d.itemName}</td>
            <td>${d.totalSold}</td>
        </tr>
    </c:forEach>
</table>

<h3>Revenue by Dish</h3>
<canvas id="revenueChart" width="800" height="400"></canvas>
<table border="1" cellpadding="6" cellspacing="0">
    <tr><th>STT</th><th>Tên món</th><th>Số lượng bán</th><th>Doanh thu</th></tr>
    <c:forEach var="r" items="${stats}" varStatus="s">
        <tr>
            <td>${s.index + 1}</td>
            <td>${r.itemName}</td>
            <td>${r.totalSold}</td>
            <td>${r.totalRevenue}</td>
        </tr>
    </c:forEach>
</table>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const labels = [
        <c:forEach var="r" items="${stats}" varStatus="s">
            "${fn:escapeXml(r.itemName)}"<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    const data = [
        <c:forEach var="r" items="${stats}" varStatus="s">
            ${r.totalRevenue}<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (VND)',
                data: data,
                backgroundColor: 'rgba(54, 162, 235, 0.5)'
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } }
        }
    });
</script>

</body>
</html>
