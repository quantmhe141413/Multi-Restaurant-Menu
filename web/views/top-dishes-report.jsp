<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Top Dishes Report - FoodieExpress</title>
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Top Selling Dishes</h1>
                    <a href="restaurant-analytics-dashboard" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                    </a>
                </div>

                <div class="dashboard-card">
                    <h4 class="mb-4">Sales Performance Ranking</h4>
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 80px;">Rank</th>
                                <th>Dish Name</th>
                                <th class="text-center">Quantity Sold</th>
                                <th class="text-end">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dish" items="${topDishes}" varStatus="status">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${status.index == 0}">
                                                <span class="badge bg-warning text-dark"><i class="fas fa-trophy me-1"></i> #1</span>
                                            </c:when>
                                            <c:when test="${status.index == 1}">
                                                <span class="badge bg-secondary">#2</span>
                                            </c:when>
                                            <c:when test="${status.index == 2}">
                                                <span class="badge bg-bronze" style="background: #cd7f32;">#3</span>
                                            </c:when>
                                            <c:otherwise>
                                                #${status.index + 1}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-bold">${dish.itemName}</td>
                                    <td class="text-center">
                                        <span class="stat-value" style="font-size: 1.25rem;">${dish.totalSold}</span>
                                    </td>
                                    <td class="text-end">
                                        <span class="badge bg-success">Best Seller</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${empty topDishes}">
                        <div class="text-center p-5">
                            <i class="fas fa-chart-bar fa-3x text-muted mb-3"></i>
                            <p class="text-muted">No sales data available for this period.</p>
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
