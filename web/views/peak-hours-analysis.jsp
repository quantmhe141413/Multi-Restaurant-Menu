<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Peak Hours Analysis - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
    <style>
        .chart-wrapper {
            background: #fff;
            padding: 2rem;
            border-radius: var(--radius);
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }
        .chart-container {
            display: flex;
            align-items: flex-end;
            gap: 8px;
            height: 250px;
            border-bottom: 2px solid var(--border);
            padding-bottom: 10px;
        }
        .bar {
            background: linear-gradient(to top, var(--primary) 0%, #ff6b81 100%);
            width: 100%;
            max-width: 40px;
            text-align: center;
            color: white;
            font-size: 11px;
            font-weight: 600;
            border-radius: 4px 4px 0 0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }
        .bar:hover {
            filter: brightness(1.1);
            transform: scaleX(1.1);
            z-index: 10;
        }
        .hour-label {
            position: absolute;
            bottom: -40px;
            left: 50%;
            transform: translateX(-50%) rotate(-45deg);
            color: var(--text-muted);
            white-space: nowrap;
            font-size: 12px;
        }
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Peak Hours Analysis</h1>
                    <a href="restaurant-analytics-dashboard" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                    </a>
                </div>

                <div class="dashboard-card mb-4">
                    <h4 class="mb-4">Order Distribution by Hour</h4>
                    <div class="chart-wrapper">
                        <div class="chart-container">
                            <c:forEach var="entry" items="${peakHours}">
                                <c:set var="height" value="${entry.value * 25}" />
                                <div class="bar" style="height: ${height > 0 ? height : 5}px;" title="${entry.key}h: ${entry.value} orders">
                                    <c:if test="${entry.value > 0}">${entry.value}</c:if>
                                    <div class="hour-label">${entry.key}h</div>
                                </div>
                            </c:forEach>
                        </div>
                        <div style="height: 50px;"></div> <!-- Spacer for rotated labels -->
                    </div>
                </div>

                <div class="dashboard-card">
                    <h4 class="mb-4">Detailed Statistics</h4>
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>Time Range</th>
                                    <c:forEach var="entry" items="${peakHours}" step="2">
                                        <th>${entry.key}h</th>
                                    </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-bold">Orders</td>
                                    <c:forEach var="entry" items="${peakHours}" step="2">
                                        <td>${entry.value}</td>
                                    </c:forEach>
                                </tr>
                            </tbody>
                        </table>
                    </div>
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
