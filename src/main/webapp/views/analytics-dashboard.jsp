<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Dashboard Phân tích - ${restaurant.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
    <style>
        body { font-family: Arial, sans-serif; color: #333; }
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
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <div class="container-fluid">
        <div class="row">
            <jsp:include page="includes/restaurant-sidebar.jsp" />
            
            <main class="col-md-9 col-lg-10 main-content p-4" style="background-color: #f8fafc; min-height: 100vh;">
                <div class="row justify-content-center">
                    <div class="col-md-11">
                        <div class="dashboard-card shadow-sm border-0 p-4 bg-white rounded-3">
                            <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                                <h1 class="h3 mb-0 text-primary"><i class="fas fa-chart-line me-2"></i>Dashboard Phân tích: ${restaurant.name}</h1>
                                <div>
                                    <a href="peak-hours-analysis" class="btn btn-outline-primary me-2"><i class="fas fa-clock me-1"></i>Xem Giờ Cao Điểm</a>
                                    <a href="menu-management-dashboard" class="btn btn-success"><i class="fas fa-utensils me-1"></i>Quản lý Menu</a>
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

    <h3 class="mt-4 mb-3"><i class="fas fa-table me-2"></i>Chi tiết doanh thu theo ngày</h3>
    <div class="table-responsive">
        <table class="table table-hover border">
            <thead class="table-light">
                <tr>
                    <th>Ngày</th>
                    <th class="text-center">Số đơn hàng</th>
                    <th class="text-end">Doanh thu</th>
                    <th class="text-end">Trung bình/Đơn</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stat" items="${dailyStats}">
                    <tr>
                        <td class="fw-bold">${stat.date}</td>
                        <td class="text-center"><span class="badge bg-soft-primary text-primary px-2">${stat.count}</span></td>
                        <td class="text-end fw-bold text-success"><fmt:formatNumber value="${stat.revenue}" pattern="#,###" /> VND</td>
                        <td class="text-end"><fmt:formatNumber value="${stat.revenue / stat.count}" pattern="#,###" /> VND</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty dailyStats}">
                    <tr>
                        <td colspan="4" class="text-center py-4 text-muted">
                            <i class="fas fa-calendar-times fa-2x mb-2 d-block"></i>
                            Không có dữ liệu trong khoảng thời gian này.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-4">
            <div class="text-muted small">
                Hiển thị trang ${currentPage} trên tổng số ${totalPages} trang
            </div>
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&startDate=${startDate}&endDate=${endDate}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/std_scripts.jsp" />
</body>
</html>
