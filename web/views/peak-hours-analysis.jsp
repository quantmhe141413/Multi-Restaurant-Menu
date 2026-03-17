<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Phân tích khung giờ cao điểm</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .chart-container { display: flex; align-items: flex-end; gap: 5px; height: 300px; border-bottom: 2px solid #333; padding-bottom: 10px; margin-top: 50px; }
        .bar { background-color: #4CAF50; width: 30px; text-align: center; color: white; font-size: 12px; }
        .hour-label { writing-mode: vertical-rl; text-orientation: mixed; margin-bottom: -40px; }
        table { border-collapse: collapse; width: 100%; margin-top: 50px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Phân tích khung giờ cao điểm</h2>
    <p>Biểu đồ số lượng đơn hàng theo giờ trong ngày:</p>
    
    <div class="chart-container">
        <c:forEach var="entry" items="${peakHours}">
            <c:set var="height" value="${entry.value * 20}" />
            <div class="bar" style="height: ${height > 0 ? height : 5}px;" title="Giờ: ${entry.key}, Đơn: ${entry.value}">
                <c:if test="${entry.value > 0}">${entry.value}</c:if>
                <div class="hour-label">${entry.key}h</div>
            </div>
        </c:forEach>
    </div>

    <table>
        <tr>
            <th>Khung giờ</th>
            <c:forEach var="entry" items="${peakHours}">
                <th>${entry.key}h</th>
            </c:forEach>
        </tr>
        <tr>
            <td>Số đơn hàng</td>
            <c:forEach var="entry" items="${peakHours}">
                <td>${entry.value}</td>
            </c:forEach>
        </tr>
    </table>
    
    <br/>
    <a href="restaurant-analytics-dashboard">Quay lại Dashboard</a>
</body>
</html>
