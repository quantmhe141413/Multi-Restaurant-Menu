<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa Đơn - ${order.orderID}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        @media print {
            .no-print {
                display: none;
            }
        }
        .invoice-container {
            max-width: 800px;
            margin: 2rem auto;
            background: white;
            padding: 2rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .invoice-header {
            border-bottom: 2px solid #333;
            padding-bottom: 1rem;
            margin-bottom: 2rem;
        }
        .invoice-table th {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar (no-print) -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark no-print">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">
                <i class="bi bi-shop"></i> Staff POS
            </a>
            <div class="ms-auto">
                <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/staff/pos?tableId=${order.tableID}">
                    <i class="bi bi-arrow-left"></i> Quay lại POS
                </a>
                <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/staff/dashboard">
                    <i class="bi bi-house"></i> Dashboard
                </a>
            </div>
        </div>
    </nav>

    <!-- Invoice Container -->
    <div class="invoice-container">
        <!-- Restaurant Header -->
        <div class="invoice-header text-center">
            <c:if test="${not empty restaurant.logoUrl}">
                <img src="${restaurant.logoUrl}" alt="${restaurant.name}" style="max-height: 80px; margin-bottom: 1rem;">
            </c:if>
            <h2>${restaurant.name}</h2>
            <p class="mb-0">${restaurant.address}</p>
        </div>

        <!-- Invoice Info -->
        <div class="row mb-4">
            <div class="col-md-6">
                <h5>Thông Tin Hóa Đơn</h5>
                <p class="mb-1"><strong>Số hóa đơn:</strong> ${invoice.invoiceNumber}</p>
                <p class="mb-1"><strong>Ngày:</strong> <fmt:formatDate value="${invoice.issuedDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                <p class="mb-1"><strong>Loại đơn:</strong> 
                    <c:choose>
                        <c:when test="${order.orderType == 'DineIn'}">Ăn tại chỗ</c:when>
                        <c:when test="${order.orderType == 'Pickup'}">Mang đi</c:when>
                        <c:when test="${order.orderType == 'Online'}">Giao hàng</c:when>
                        <c:otherwise>${order.orderType}</c:otherwise>
                    </c:choose>
                </p>
                <c:if test="${not empty order.tableID}">
                    <p class="mb-1"><strong>Bàn:</strong> ${order.tableID}</p>
                </c:if>
            </div>
            <div class="col-md-6">
                <h5>Thông Tin Khách Hàng</h5>
                <p class="mb-1"><strong>Tên:</strong> ${order.customerName}</p>
                <c:if test="${order.orderType == 'Online'}">
                    <p class="mb-1"><strong>Địa chỉ giao hàng:</strong> ${order.deliveryAddress}</p>
                </c:if>
            </div>
        </div>

        <!-- Order Items Table -->
        <table class="table table-bordered invoice-table">
            <thead>
                <tr>
                    <th>Món</th>
                    <th class="text-center">Số lượng</th>
                    <th class="text-end">Đơn giá</th>
                    <th class="text-end">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orderItems}" var="item">
                    <tr>
                        <td>
                            ${item.itemName}
                            <c:if test="${not empty item.note}">
                                <br><small class="text-muted"><i class="bi bi-chat-left-text"></i> ${item.note}</small>
                            </c:if>
                        </td>
                        <td class="text-center">${item.quantity}</td>
                        <td class="text-end"><fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"/> đ</td>
                        <td class="text-end"><fmt:formatNumber value="${item.quantity * item.unitPrice}" type="number" groupingUsed="true"/> đ</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Totals -->
        <div class="row">
            <div class="col-md-6 offset-md-6">
                <table class="table table-sm">
                    <tr>
                        <td><strong>Tạm tính:</strong></td>
                        <td class="text-end"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> đ</td>
                    </tr>
                    <c:if test="${order.discountAmount > 0}">
                        <tr>
                            <td><strong>Giảm giá:</strong></td>
                            <td class="text-end text-success">-<fmt:formatNumber value="${order.discountAmount}" type="number" groupingUsed="true"/> đ</td>
                        </tr>
                    </c:if>
                    <c:if test="${order.deliveryFee > 0}">
                        <tr>
                            <td><strong>Phí giao hàng:</strong></td>
                            <td class="text-end"><fmt:formatNumber value="${order.deliveryFee}" type="number" groupingUsed="true"/> đ</td>
                        </tr>
                    </c:if>
                    <tr class="table-active">
                        <td><strong>Tổng cộng:</strong></td>
                        <td class="text-end"><strong><fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true"/> đ</strong></td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Payment Info -->
        <div class="mt-4">
            <p class="mb-1"><strong>Phương thức thanh toán:</strong> 
                <c:choose>
                    <c:when test="${order.paymentMethod == 'Cash'}">Tiền mặt</c:when>
                    <c:when test="${order.paymentMethod == 'Card'}">Thẻ</c:when>
                    <c:when test="${order.paymentMethod == 'VNPay'}">VNPay</c:when>
                    <c:otherwise>${order.paymentMethod}</c:otherwise>
                </c:choose>
            </p>
            <p class="mb-1"><strong>Trạng thái thanh toán:</strong> 
                <c:choose>
                    <c:when test="${order.paymentStatus == 'Success'}">
                        <span class="badge bg-success">Đã thanh toán</span>
                    </c:when>
                    <c:when test="${order.paymentStatus == 'Pending'}">
                        <span class="badge bg-warning">Chờ thanh toán</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary">${order.paymentStatus}</span>
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <!-- Footer -->
        <div class="text-center mt-5 pt-4 border-top">
            <p class="mb-0">Cảm ơn quý khách đã sử dụng dịch vụ!</p>
        </div>

        <!-- Action Buttons (no-print) -->
        <div class="text-center mt-4 no-print">
            <button class="btn btn-primary" onclick="window.print()">
                <i class="bi bi-printer"></i> In hóa đơn
            </button>
            <a href="${pageContext.request.contextPath}/staff/invoice/print?orderId=${order.orderID}" 
               class="btn btn-success" target="_blank">
                <i class="bi bi-file-pdf"></i> Tải PDF
            </a>
            <a href="${pageContext.request.contextPath}/staff/tables" class="btn btn-secondary">
                <i class="bi bi-table"></i> Quay lại danh sách bàn
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
