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

        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
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
                    <i class="fas fa-sort-amount-down"></i> Newest orders first
                </div>
            </div>

            <!-- Orders Table Card -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center py-3"
                     style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border-radius: 0.5rem 0.5rem 0 0;">
                    <span><i class="fas fa-list-alt me-2"></i>All Orders</span>
                    <span class="badge bg-white text-primary fw-bold">${totalOrders} total</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#Order</th>
                                    <th>Date</th>
                                    <th>Customer</th>
                                    <th>Type</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th class="text-end">Amount</th>
                                    <th class="text-center">Actions</th>
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
                                                <td>
                                                    <strong class="text-primary">#${order.orderID}</strong>
                                                </td>
                                                <td class="text-nowrap">
                                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                <td>
                                                    <i class="fas fa-user text-muted me-1"></i>
                                                    <c:choose>
                                                        <c:when test="${not empty order.customerName}">${order.customerName}</c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary">${order.orderType}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus == 'Preparing'}">
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="fas fa-fire-alt"></i> Preparing
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'Delivering'}">
                                                            <span class="badge bg-info text-dark">
                                                                <i class="fas fa-truck"></i> Delivering
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'Completed'}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check-circle"></i> Completed
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'Cancelled'}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-times-circle"></i> Cancelled
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${order.orderStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.paymentStatus == 'Success'}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check"></i> Paid
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.paymentStatus == 'Pending'}">
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="fas fa-clock"></i> Pending
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.paymentStatus == 'Failed'}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-times"></i> Failed
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${order.paymentStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <small class="text-muted ms-1">${order.paymentMethod}</small>
                                                </td>
                                                <td class="text-end">
                                                    <strong style="color: #10b981;">
                                                        $<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" />
                                                    </strong>
                                                </td>
                                                <td class="text-center">
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderID}" 
                                                       class="btn btn-sm btn-primary" title="View Details">
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

                        <c:choose>
                            <c:when test="${totalPages <= 7}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${currentPage > 3}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=1">1</a>
                                    </li>
                                    <c:if test="${currentPage > 4}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:if>
                                <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}"
                                           end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"
                                           var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages - 2}">
                                    <c:if test="${currentPage < totalPages - 3}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/order-management?page=${totalPages}">${totalPages}</a>
                                    </li>
                                </c:if>
                            </c:otherwise>
                        </c:choose>

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
                        <small>Page ${currentPage} of ${totalPages} (Total: ${totalOrders} orders)</small>
                    </div>
                </nav>
            </c:if>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
