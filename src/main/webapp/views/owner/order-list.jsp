<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Order Management" scope="request" />
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
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-clipboard-list text-primary"></i> Order Management</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Orders</li>
                        </ol>
                    </nav>
                </div>
                <div class="text-muted small">
                    <i class="fas fa-sort-amount-down me-1"></i> Newest orders first
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
                                    <th>Type</th>
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
                                                <p class="text-muted mb-0">No orders yet</p>
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
                                                    <span class="badge bg-soft-secondary text-secondary">${order.orderType}</span>
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
                                                    <strong class="text-success">$<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" /></strong>
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
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=1">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${currentPage - 1}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}"
                                   end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${currentPage + 1}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${totalPages}">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                    <div class="text-center text-muted mt-2">
                        <small>Page ${currentPage} of ${totalPages} (${totalOrders} orders)</small>
                    </div>
                </nav>
            </c:if>
        </main>
    </div>
</div>

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

    .btn-outline-primary {
        border-radius: 8px;
    }

    .badge {
        font-weight: 500;
        padding: 0.35rem 0.65rem;
    }
</style>

<jsp:include page="/views/includes/footer.jsp" />
<jsp:include page="/views/includes/std_scripts.jsp" />
</body>
</html>
