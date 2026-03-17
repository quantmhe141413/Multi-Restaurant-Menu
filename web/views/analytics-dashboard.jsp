<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Dashboard Phân tích - ${restaurant.name}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; color: #333; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }
        .stat-card { background: #f9f9f9; padding: 20px; border-radius: 8px; border: 1px solid #ddd; text-align: center; }
        .stat-value { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .stat-label { color: #7f8c8d; margin-top: 5px; }
        .filter-section { background: #f4f7f6; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn { padding: 8px 16px; text-decoration: none; background: #3498db; color: white; border-radius: 4px; display: inline-block; }
        .btn-green { background: #27ae60; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Dashboard Phân tích: ${restaurant.name}</h1>
        <div>
            <a href="peak-hours-analysis" class="btn">Xem Giờ Cao Điểm</a>
            <a href="menu-management-dashboard" class="btn btn-green">Quản lý Menu</a>
        </div>
    </div>

    <div class="filter-section">
        <form method="get" action="restaurant-analytics-dashboard">
            Từ ngày: <input type="date" name="startDate" value="${startDate}">
            Đến ngày: <input type="date" name="endDate" value="${endDate}">
            <input type="submit" value="Lọc báo cáo" class="btn">
        </form>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="VND"/></div>
            <div class="stat-label">Tổng doanh thu</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${totalOrders}</div>
            <div class="stat-label">Tổng đơn hàng</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:choose>
                    <c:when test="${totalOrders > 0}">
                        <fmt:formatNumber value="${totalRevenue / totalOrders}" type="currency" currencySymbol="VND"/>
                    </c:when>
                    <c:otherwise>0 VND</c:otherwise>
                </c:choose>
            </div>
            <div class="stat-label">Giá trị đơn hàng TB</div>
        </div>
    </div>

    <h3>Chi tiết doanh thu theo ngày</h3>
    <table>
        <thead>
            <tr>
                <th>Ngày</th>
                <th>Số đơn hàng</th>
                <th>Doanh thu</th>
                <th>Trung bình/Đơn</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="stat" items="${dailyStats}">
                <tr>
                    <td>${stat.date}</td>
                    <td>${stat.count}</td>
                    <td><fmt:formatNumber value="${stat.revenue}" type="currency" currencySymbol="VND"/></td>
                    <td><fmt:formatNumber value="${stat.revenue / stat.count}" type="currency" currencySymbol="VND"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty dailyStats}">
                <tr>
                    <td colspan="4" style="text-align:center;">Không có dữ liệu trong khoảng thời gian này.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
