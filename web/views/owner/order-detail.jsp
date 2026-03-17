<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Order Detail" scope="request" />
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
                    <h1><i class="fas fa-receipt text-primary"></i> Order #${order.orderID}</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order-management">Orders</a></li>
                            <li class="breadcrumb-item active">Detail</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${sessionScope.user.roleID == 2}">
                            <a href="${pageContext.request.contextPath}/owner/order-history" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Back to List
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/order-management" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Back to List
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="row">
                <!-- Order Status & Actions Card -->
                <div class="col-lg-4 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0"><i class="fas fa-info-circle text-primary me-2"></i>Order Status</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="text-muted small mb-2">Current Status</label>
                                <div id="current-status-badge">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Preparing'}">
                                            <span class="badge bg-warning fs-6"><i class="fas fa-fire-alt"></i> Preparing</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Delivering'}">
                                            <span class="badge bg-info fs-6"><i class="fas fa-truck"></i> Delivering</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Completed'}">
                                            <span class="badge bg-success fs-6"><i class="fas fa-check-circle"></i> Completed</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Cancelled'}">
                                            <span class="badge bg-danger fs-6"><i class="fas fa-times-circle"></i> Cancelled</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Only Staff (roleID = 3) can update order status -->
                            <c:if test="${sessionScope.user.roleID == 3 && order.orderStatus != 'Completed' && order.orderStatus != 'Cancelled'}">
                                <hr>
                                <label class="text-muted small mb-2">Update Status</label>
                                <div class="d-grid gap-2">
                                    <c:if test="${order.orderStatus == 'Preparing'}">
                                        <button class="btn btn-info" onclick="updateStatus('Delivering')">
                                            <i class="fas fa-truck me-1"></i> Mark as Delivering
                                        </button>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'Delivering'}">
                                        <button class="btn btn-success" onclick="updateStatus('Completed')">
                                            <i class="fas fa-check-circle me-1"></i> Mark as Delivered
                                        </button>
                                    </c:if>
                                    <button class="btn btn-outline-danger btn-sm" onclick="updateStatus('Cancelled')">
                                        <i class="fas fa-times me-1"></i> Cancel Order
                                    </button>
                                </div>
                            </c:if>

                            <hr>
                            <div class="small">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Order Type:</span>
                                    <span class="badge bg-soft-secondary text-secondary">${order.orderType}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Payment:</span>
                                    <span class="badge ${order.paymentStatus == 'Success' ? 'bg-success' : 'bg-warning'}">${order.paymentStatus}</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span class="text-muted">Method:</span>
                                    <strong>${order.paymentMethod}</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customer Info Card -->
                <div class="col-lg-8 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0"><i class="fas fa-user text-primary me-2"></i>Customer Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="text-muted small">Customer Name</label>
                                    <div class="fw-bold">${order.customerName}</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small">Order Date</label>
                                    <div class="fw-bold"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small">Total Amount</label>
                                    <div class="fs-5 text-success fw-bold">$<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" /></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small">Delivery Fee</label>
                                    <div class="fw-bold">$<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00" /></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Items Card -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white border-bottom">
                    <h5 class="mb-0"><i class="fas fa-utensils text-primary me-2"></i>Order Items</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Item</th>
                                    <th class="text-center">Quantity</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end pe-4">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderItems}">
                                    <c:set var="menuItem" value="${menuItems[item.itemID]}" />
                                    <tr>
                                        <td class="ps-4">
                                            <strong>${menuItem != null ? menuItem.itemName : 'Unknown Item'}</strong>
                                            <c:if test="${not empty item.note}">
                                                <br><small class="text-muted"><i class="fas fa-sticky-note me-1"></i>${item.note}</small>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary">${item.quantity}</span>
                                        </td>
                                        <td class="text-end">$<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00" /></td>
                                        <td class="text-end pe-4">
                                            <strong>$<fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,##0.00" /></strong>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="3" class="text-end pe-3"><strong>Total Amount:</strong></td>
                                    <td class="text-end pe-4"><strong class="text-success fs-5">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></strong></td>
                                </tr>
                                <c:if test="${order.discountAmount > 0}">
                                    <tr>
                                        <td colspan="3" class="text-end pe-3 text-muted">Discount:</td>
                                        <td class="text-end pe-4 text-danger">-$<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0.00" /></td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <td colspan="3" class="text-end pe-3 text-muted">Delivery Fee:</td>
                                    <td class="text-end pe-4">+$<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00" /></td>
                                </tr>
                                <tr class="table-primary">
                                    <td colspan="3" class="text-end pe-3"><strong>Final Amount:</strong></td>
                                    <td class="text-end pe-4"><strong class="text-primary fs-4">$<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" /></strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<style>
    .bg-soft-secondary { background-color: rgba(108, 117, 125, 0.1); }
    .text-secondary { color: #64748b; }

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
        padding: 1rem 0.75rem;
    }

    .table tbody td {
        padding: 1rem 0.75rem;
    }

    .btn {
        border-radius: 8px;
        font-weight: 500;
    }

    .badge {
        font-weight: 500;
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function updateStatus(newStatus) {
    Swal.fire({
        title: 'Update Order Status?',
        text: 'Change status to ' + newStatus,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#6366f1',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Yes, update it!'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('${pageContext.request.contextPath}/update-order-status', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'orderId=${order.orderID}&status=' + encodeURIComponent(newStatus)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    Swal.fire('Success!', data.message, 'success').then(() => location.reload());
                } else {
                    Swal.fire('Error!', data.message, 'error');
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire('Error!', 'Failed to update status', 'error');
            });
        }
    });
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
