<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Menu Management Dashboard - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <div class="container-fluid">
        <div class="row">
            <jsp:include page="includes/restaurant-sidebar.jsp" />
            
            <main class="col-md-9 col-lg-10 main-content p-4" style="background-color: #f8fafc; min-height: 100vh;">
                <div class="row justify-content-center">
                    <div class="col-md-11">
                        <div class="dashboard-card shadow-sm border-0 p-4 bg-white rounded-3 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                                <h1 class="h3 mb-0 text-success"><i class="fas fa-utensils me-2"></i>Menu Management Dashboard</h1>
                                <a href="restaurant-analytics-dashboard" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i> Back to Analytics
                                </a>
                            </div>

                            <form method="get" action="menu-management-dashboard" class="row g-3 mb-4 bg-light p-3 rounded align-items-end">
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">Start date:</label>
                                    <input type="date" name="startDate" value="${param.startDate}" class="form-control" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">End date:</label>
                                    <input type="date" name="endDate" value="${param.endDate}" class="form-control" />
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Category:</label>
                                    <select name="categoryId" class="form-select">
                                        <option value="">All Categories</option>
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.categoryID}" <c:if test="${param.categoryId == c.categoryID}">selected</c:if>>${c.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100"><i class="fas fa-filter me-2"></i> Filter</button>
                                </div>
                            </form>

                            <h4 class="mb-3">Top Selling Items</h4>
                            <div class="table-responsive mb-5">
                                <table class="table table-hover table-bordered table-striped align-middle">
                                    <thead class="table-light">
                                        <tr><th style="width: 60px" class="text-center">#</th><th>Dish Name</th><th class="text-end">Total Sold</th></tr>
                                    </thead>
                                    <tbody>
    <c:forEach var="d" items="${topDishes}" varStatus="s">
        <tr>
            <td>${s.index + 1}</td>
            <td>${d.itemName}</td>
            <td>${d.totalSold}</td>
        </tr>
    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <h4 class="mb-3">Revenue by Dish</h4>
                            <div class="mb-5 bg-light p-3 rounded border">
                                <canvas id="revenueChart" style="max-height: 400px; width: 100%;"></canvas>
                            </div>
                            
                            <div class="table-responsive mb-4">
                                <table class="table table-hover table-bordered table-striped align-middle">
                                    <thead class="table-light">
                                        <tr><th style="width: 60px" class="text-center">#</th><th>Dish Name</th><th class="text-end">Total Sold</th><th class="text-end">Revenue (VND)</th></tr>
                                    </thead>
                                    <tbody>
    <c:forEach var="r" items="${stats}" varStatus="s">
        <tr>
            <td>${s.index + 1}</td>
            <td>${r.itemName}</td>
            <td>${r.totalSold}</td>
            <td>${r.totalRevenue}</td>
        </tr>
    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

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
