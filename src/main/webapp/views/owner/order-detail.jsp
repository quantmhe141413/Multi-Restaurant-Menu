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
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center mb-4">
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
                    <a href="${pageContext.request.contextPath}/order-management" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>

            <div class="row">
                <!-- Order Status Card -->
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-header" style="background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;">
                            <h5 class="mb-0"><i class="fas fa-info-circle"></i> Order Status</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="text-muted small">Current Status</label>
                                <div id="current-status-badge">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Preparing'}">
                                            <span class="badge bg-warning text-dark fs-6"><i class="fas fa-fire-alt"></i> Preparing</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Delivering'}">
                                            <span class="badge bg-info text-dark fs-6"><i class="fas fa-truck"></i> Delivering</span>
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

                            <c:if test="${order.orderStatus != 'Completed' && order.orderStatus != 'Cancelled'}">
                                <hr>
                                <label class="text-muted small mb-2">Update Status</label>
                                <div class="d-grid gap-2">
                                    <c:if test="${order.orderStatus == 'Preparing'}">
                                        <button class="btn btn-info" onclick="updateStatus('Delivering')">
                                            <i class="fas fa-truck"></i> Mark as Delivering
                                        </button>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'Delivering'}">
                                        <button class="btn btn-success" onclick="updateStatus('Completed')">
                                            <i class="fas fa-check-circle"></i> Mark as Delivered
                                        </button>
                                    </c:if>
                                    <button class="btn btn-outline-danger btn-sm" onclick="updateStatus('Cancelled')">
                                        <i class="fas fa-times"></i> Cancel Order
                                    </button>
                                </div>
                            </c:if>

                            <hr>
                            <div class="small">
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="text-muted">Order Type:</span>
                                    <span class="badge bg-secondary">${order.orderType}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="text-muted">Payment:</span>
                                    <span class="badge bg-${order.paymentStatus == 'Success' ? 'success' : 'warning'}">${order.paymentStatus}</span>
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
                <div class="col-md-8 mb-4">
                    <div class="card">
                        <div class="card-header" style="background:#f8fafc;">
                            <h5 class="mb-0"><i class="fas fa-user text-primary"></i> Customer Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-2"><strong>Name:</strong> ${order.customerName}</p>
                                    <p class="mb-2"><strong>Order Date:</strong> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-2"><strong>Total Amount:</strong> <span class="text-success fw-bold">$<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" /></span></p>
                                    <p class="mb-0"><strong>Delivery Fee:</strong> $<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00" /></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Items Card -->
            <div class="card">
                <div class="card-header" style="background:#f8fafc;">
                    <h5 class="mb-0"><i class="fas fa-utensils text-primary"></i> Order Items</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th class="text-center">Quantity</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderItems}">
                                    <c:set var="menuItem" value="${menuItems[item.itemID]}" />
                                    <tr>
                                        <td>
                                            <strong>${menuItem != null ? menuItem.itemName : 'Unknown Item'}</strong>
                                            <c:if test="${not empty item.note}">
                                                <br><small class="text-muted"><i class="fas fa-sticky-note"></i> ${item.note}</small>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary">${item.quantity}</span>
                                        </td>
                                        <td class="text-end">$<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00" /></td>
                                        <td class="text-end">
                                            <strong>$<fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,##0.00" /></strong>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="3" class="text-end"><strong>Total Amount:</strong></td>
                                    <td class="text-end"><strong class="text-success fs-5">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></strong></td>
                                </tr>
                                <c:if test="${order.discountAmount > 0}">
                                    <tr>
                                        <td colspan="3" class="text-end text-muted">Discount:</td>
                                        <td class="text-end text-danger">-$<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0.00" /></td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <td colspan="3" class="text-end text-muted">Delivery Fee:</td>
                                    <td class="text-end">+$<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00" /></td>
                                </tr>
                                <tr class="table-primary">
                                    <td colspan="3" class="text-end"><strong>Final Amount:</strong></td>
                                    <td class="text-end"><strong class="text-primary fs-4">$<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" /></strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function updateStatus(newStatus) {
    if (!confirm('Are you sure you want to update the order status to ' + newStatus + '?')) {
        return;
    }

    fetch('${pageContext.request.contextPath}/update-order-status', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'orderId=${order.orderID}&status=' + encodeURIComponent(newStatus)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            if (window.iziToast) {
                iziToast.success({title: 'Success', message: data.message, position: 'topRight'});
            }
            setTimeout(() => location.reload(), 1000);
        } else {
            if (window.iziToast) {
                iziToast.error({title: 'Error', message: data.message, position: 'topRight'});
            } else {
                alert('Error: ' + data.message);
            }
        }
    })
    .catch(err => {
        console.error(err);
        if (window.iziToast) {
            iziToast.error({title: 'Error', message: 'Failed to update status', position: 'topRight'});
        } else {
            alert('Failed to update status');
        }
    });
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
