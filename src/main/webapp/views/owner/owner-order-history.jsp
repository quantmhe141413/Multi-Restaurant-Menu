<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<c:set var="pageTitle" value="Order History" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} - FoodieExpress</title>
    <jsp:include page="/views/includes/std_head.jsp" />
</head>
<body>
    <jsp:include page="/views/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/views/includes/restaurant-sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-history text-primary"></i> Order History & Revenue</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Order History</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <!-- Revenue Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card shadow-sm border-0 stat-card stat-card-primary">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <p class="text-muted small mb-1">Total Revenue</p>
                                    <h3 class="mb-0 fw-bold"><fmt:formatNumber value="${stats.totalRevenue}" pattern="#,##0" /> VNĐ</h3>
                                </div>
                                <div class="stat-icon stat-icon-primary">
                                    <i class="fas fa-dollar-sign"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm border-0 stat-card stat-card-success">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <p class="text-muted small mb-1">Completed Orders</p>
                                    <h3 class="mb-0 fw-bold">${stats.completedOrders}</h3>
                                </div>
                                <div class="stat-icon stat-icon-success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm border-0 stat-card stat-card-danger">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <p class="text-muted small mb-1">Cancelled Orders</p>
                                    <h3 class="mb-0 fw-bold">${stats.cancelledOrders}</h3>
                                </div>
                                <div class="stat-icon stat-icon-danger">
                                    <i class="fas fa-times-circle"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm border-0 stat-card stat-card-info">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <p class="text-muted small mb-1">Avg Order Value</p>
                                    <h3 class="mb-0 fw-bold"><fmt:formatNumber value="${stats.avgOrderValue}" pattern="#,##0" /> VNĐ</h3>
                                </div>
                                <div class="stat-icon stat-icon-info">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0"><i class="fas fa-chart-bar text-primary me-2"></i>Revenue Overview</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-wrap chart-wrap-lg">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0"><i class="fas fa-chart-pie text-primary me-2"></i>Order Status</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-wrap">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body p-4">
                    <form method="GET" action="${pageContext.request.contextPath}/owner/order-history" id="filterForm">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0">
                                        <i class="fas fa-calendar text-muted"></i>
                                    </span>
                                    <input type="date" name="fromDate" class="form-control border-start-0 ps-0" 
                                           placeholder="From Date" value="${fromDate}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0">
                                        <i class="fas fa-calendar text-muted"></i>
                                    </span>
                                    <input type="date" name="toDate" class="form-control border-start-0 ps-0" 
                                           placeholder="To Date" value="${toDate}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <select name="status" class="form-select">
                                    <option value="All" ${selectedStatus == 'All' ? 'selected' : ''}>All Status</option>
                                    <option value="Preparing" ${selectedStatus == 'Preparing' ? 'selected' : ''}>Preparing</option>
                                    <option value="Delivering" ${selectedStatus == 'Delivering' ? 'selected' : ''}>Delivering</option>
                                    <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                    <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-1 d-grid">
                                <button type="submit" class="btn btn-primary shadow-sm">
                                    <i class="fas fa-filter"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center py-3">
                    <h5 class="mb-0"><i class="fas fa-list-alt me-2 text-primary"></i>All Orders</h5>
                    <span class="badge bg-primary">${totalOrders} total</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Order #</th>
                                    <th>Date & Time</th>
                                    <th>Customer</th>
                                    <th>Restaurant</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th class="text-end">Amount</th>
                                    <th class="text-center pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty orders}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3 d-block"></i>
                                                <p class="text-muted mb-0">No orders found</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="order" items="${orders}">
                                            <tr>
                                                <td class="ps-4">
                                                    <strong class="text-primary">#${order.orderID}</strong>
                                                </td>
                                                <td class="text-nowrap">
                                                    <div><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" /></div>
                                                    <small class="text-muted"><fmt:formatDate value="${order.createdAt}" pattern="HH:mm" /></small>
                                                </td>
                                                <td>
                                                    <i class="fas fa-user text-muted me-1"></i>
                                                    <c:choose>
                                                        <c:when test="${not empty order.customerName}">${order.customerName}</c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty order.restaurantName}">
                                                            <span class="badge bg-soft-secondary text-secondary">${order.restaurantName}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus == 'Preparing'}">
                                                            <span class="badge bg-warning"><i class="fas fa-fire-alt"></i> Preparing</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'Delivering'}">
                                                            <span class="badge bg-info"><i class="fas fa-truck"></i> Delivering</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'Completed'}">
                                                            <span class="badge bg-success"><i class="fas fa-check-circle"></i> Completed</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'Cancelled'}">
                                                            <span class="badge bg-danger"><i class="fas fa-times-circle"></i> Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${order.orderStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.paymentStatus == 'Success'}">
                                                            <span class="badge bg-success-soft text-success"><i class="fas fa-check"></i> Paid</span>
                                                        </c:when>
                                                        <c:when test="${order.paymentStatus == 'Pending'}">
                                                            <span class="badge bg-warning-soft text-warning"><i class="fas fa-clock"></i> Pending</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${order.paymentStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <br><small class="text-muted">${order.paymentMethod}</small>
                                                </td>
                                                <td class="text-end">
                                                    <strong class="text-success"><fmt:formatNumber value="${order.finalAmount}" pattern="#,##0" /></strong>
                                                </td>
                                                <td class="text-center pe-4">
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderID}" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <c:url value="/owner/order-history" var="paginationUrl">
                    <c:if test="${not empty fromDate}"><c:param name="fromDate" value="${fromDate}" /></c:if>
                    <c:if test="${not empty toDate}"><c:param name="toDate" value="${toDate}" /></c:if>
                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}" /></c:if>
                </c:url>
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=1"><i class="fas fa-angle-double-left"></i></a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
                            </li>
                        </c:if>
                        <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}" 
                                   end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${totalPages}"><i class="fas fa-angle-double-right"></i></a>
                            </li>
                        </c:if>
                    </ul>
                    <div class="text-center text-muted mt-2">
                        <small>Page ${currentPage} of ${totalPages}</small>
                    </div>
                </nav>
            </c:if>
        </main>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
// Order Status Distribution Chart (Doughnut)
const statusCtx = document.getElementById('statusChart');
if (statusCtx) {
    const preparing = ${stats.totalOrders} - ${stats.completedOrders} - ${stats.cancelledOrders};
    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Completed', 'Cancelled', 'Preparing/Delivering'],
            datasets: [{
                data: [${stats.completedOrders}, ${stats.cancelledOrders}, preparing],
                backgroundColor: [
                    'rgba(34, 197, 94, 0.8)',   // green
                    'rgba(239, 68, 68, 0.8)',    // red
                    'rgba(251, 191, 36, 0.8)'    // yellow
                ],
                borderColor: [
                    'rgb(34, 197, 94)',
                    'rgb(239, 68, 68)',
                    'rgb(251, 191, 36)'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 15,
                        font: { size: 12 }
                    }
                }
            },
            cutout: '62%'
        }
    });
}

// Revenue Chart (Bar/Line) - showing completed vs cancelled
const revenueCtx = document.getElementById('revenueChart');
if (revenueCtx) {
    new Chart(revenueCtx, {
        type: 'bar',
        data: {
            labels: ['Completed Orders', 'Cancelled Orders', 'Preparing/Delivering'],
            datasets: [{
                label: 'Number of Orders',
                data: [
                    ${stats.completedOrders}, 
                    ${stats.cancelledOrders},
                    ${stats.totalOrders} - ${stats.completedOrders} - ${stats.cancelledOrders}
                ],
                maxBarThickness: 72,
                categoryPercentage: 0.7,
                barPercentage: 0.9,
                backgroundColor: [
                    'rgba(99, 102, 241, 0.8)',
                    'rgba(239, 68, 68, 0.8)',
                    'rgba(251, 191, 36, 0.8)'
                ],
                borderColor: [
                    'rgb(99, 102, 241)',
                    'rgb(239, 68, 68)',
                    'rgb(251, 191, 36)'
                ],
                borderWidth: 2,
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                title: {
                    display: true,
                    text: 'Order Distribution by Status',
                    font: { size: 14, weight: 'bold' },
                    color: '#374151'
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    suggestedMax: Math.max(3, ${stats.totalOrders}),
                    ticks: { stepSize: 1 },
                    grid: { color: 'rgba(0,0,0,0.05)' }
                },
                x: {
                    grid: { display: false }
                }
            }
        }
    });
}
</script>

<style>
    .bg-soft-secondary { background-color: rgba(108, 117, 125, 0.1); }
    .bg-success-soft { background-color: rgba(34, 197, 94, 0.1); }
    .bg-warning-soft { background-color: rgba(251, 191, 36, 0.1); }
    .text-secondary { color: #64748b; }
    .text-success { color: #22c55e; }
    .text-warning { color: #eab308; }

    .main-content {
        padding: 2rem;
        background-color: #f8fafc;
        min-height: 100vh;
    }

    .page-header h1 {
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }

    .card {
        border-radius: 15px;
        overflow: hidden;
    }

    .table thead th {
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.75rem;
        letter-spacing: 0.05em;
        color: #64748b;
        border-bottom: 1px solid #e2e8f0;
        padding: 1rem 0.75rem;
    }

    .table tbody td {
        padding: 1rem 0.75rem;
        vertical-align: middle;
    }

    .btn {
        border-radius: 8px;
        font-weight: 500;
    }

    .btn-outline-primary {
        border-radius: 8px;
    }

    .badge {
        font-weight: 500;
        padding: 0.35rem 0.65rem;
    }

    /* Stat Cards */
    .stat-card {
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1) !important;
    }

    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.25rem;
    }

    .stat-icon-primary {
        background: rgba(99, 102, 241, 0.1);
        color: #6366f1;
    }

    .stat-icon-success {
        background: rgba(34, 197, 94, 0.1);
        color: #22c55e;
    }

    .stat-icon-danger {
        background: rgba(239, 68, 68, 0.1);
        color: #ef4444;
    }

    .stat-icon-info {
        background: rgba(59, 130, 246, 0.1);
        color: #3b82f6;
    }

    .stat-card-primary { border-left: 4px solid #6366f1; }
    .stat-card-success { border-left: 4px solid #22c55e; }
    .stat-card-danger { border-left: 4px solid #ef4444; }
    .stat-card-info { border-left: 4px solid #3b82f6; }

    /* Charts */
    .chart-wrap {
        position: relative;
        width: 100%;
        height: 260px;
    }

    .chart-wrap-lg {
        height: 320px;
    }
</style>

<jsp:include page="/views/includes/footer.jsp" />
<jsp:include page="/views/includes/std_scripts.jsp" />
</body>
</html>
