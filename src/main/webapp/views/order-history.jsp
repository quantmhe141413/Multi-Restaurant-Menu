<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Lịch sử đơn hàng - FoodieExpress</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    :root {
                        --theme-color: #28a745;
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        background-color: #f8f9fa;
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
                    }

                    .site-header {
                        background-color: white;
                        padding: 1rem 5%;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        position: sticky;
                        top: 0;
                        z-index: 1000;
                    }

                    .site-header__bar {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        max-width: 1400px;
                        margin: 0 auto;
                    }

                    .logo {
                        font-size: 1.5rem;
                        font-weight: bold;
                        color: #ff4757;
                        text-decoration: none;
                        transition: opacity 0.3s;
                    }

                    .logo:hover {
                        opacity: 0.8;
                    }

                    .nav-links {
                        display: flex;
                        align-items: center;
                        gap: 1.5rem;
                    }

                    .nav-links a {
                        text-decoration: none;
                        color: #2f3542;
                        font-weight: 500;
                        transition: color 0.3s;
                    }

                    .nav-links a:hover {
                        color: #ff4757;
                    }

                    .nav-user {
                        color: #57606f;
                    }

                    .nav-action {
                        color: #ff4757 !important;
                        font-weight: 600 !important;
                    }

                    .site-footer {
                        background-color: #2f3542;
                        color: white;
                        padding: 2rem 5%;
                        margin-top: 4rem;
                        text-align: center;
                    }

                    .site-footer__inner {
                        max-width: 1400px;
                        margin: 0 auto;
                    }

                    .site-footer__text {
                        margin: 0;
                    }

                    .container {
                        max-width: 1400px;
                        margin: 2rem auto;
                        padding: 0 5%;
                    }

                    .page-title {
                        font-size: 2rem;
                        font-weight: 700;
                        color: #2f3542;
                        margin-bottom: 1.5rem;
                    }

                    .order-card {
                        background: white;
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 1.5rem;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .order-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
                    }

                    .order-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding-bottom: 1rem;
                        border-bottom: 1px solid #e9ecef;
                        margin-bottom: 1rem;
                    }

                    .order-id {
                        font-size: 1.1rem;
                        font-weight: 600;
                        color: #2f3542;
                    }

                    .order-date {
                        color: #6c757d;
                        font-size: 0.9rem;
                    }

                    .order-status {
                        display: inline-block;
                        padding: 0.35rem 0.85rem;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        font-weight: 600;
                    }

                    .status-preparing {
                        background-color: #fff3cd;
                        color: #856404;
                    }

                    .status-delivering {
                        background-color: #cfe2ff;
                        color: #084298;
                    }

                    .status-completed {
                        background-color: #d1e7dd;
                        color: #0f5132;
                    }

                    .status-cancelled {
                        background-color: #f8d7da;
                        color: #842029;
                    }

                    .restaurant-name {
                        font-weight: 600;
                        color: #ff4757;
                        margin-bottom: 1rem;
                        font-size: 1.05rem;
                    }

                    .order-items {
                        margin: 1rem 0;
                    }

                    .order-item {
                        display: flex;
                        gap: 1rem;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid #f1f3f5;
                    }

                    .order-item:last-child {
                        border-bottom: none;
                    }

                    .item-image {
                        width: 60px;
                        height: 60px;
                        border-radius: 8px;
                        object-fit: cover;
                    }

                    .item-details {
                        flex: 1;
                    }

                    .item-name {
                        font-weight: 600;
                        color: #2f3542;
                        margin-bottom: 0.25rem;
                    }

                    .item-quantity {
                        color: #6c757d;
                        font-size: 0.9rem;
                    }

                    .item-price {
                        font-weight: 600;
                        color: #2f3542;
                        align-self: center;
                    }

                    .order-footer {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding-top: 1rem;
                        border-top: 1px solid #e9ecef;
                        margin-top: 1rem;
                    }

                    .payment-info {
                        display: flex;
                        flex-direction: column;
                        gap: 0.25rem;
                    }

                    .payment-method {
                        font-size: 0.9rem;
                        color: #6c757d;
                    }

                    .payment-status {
                        display: inline-block;
                        padding: 0.25rem 0.65rem;
                        border-radius: 15px;
                        font-size: 0.8rem;
                        font-weight: 600;
                    }

                    .payment-pending {
                        background-color: #fff3cd;
                        color: #856404;
                    }

                    .payment-success {
                        background-color: #d1e7dd;
                        color: #0f5132;
                    }

                    .payment-failed {
                        background-color: #f8d7da;
                        color: #842029;
                    }

                    .order-total {
                        text-align: right;
                    }

                    .total-label {
                        color: #6c757d;
                        font-size: 0.9rem;
                        margin-bottom: 0.25rem;
                    }

                    .total-amount {
                        font-size: 1.3rem;
                        font-weight: 700;
                        color: #28a745;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 3rem 1rem;
                    }

                    .empty-state i {
                        font-size: 4rem;
                        color: #dee2e6;
                        margin-bottom: 1rem;
                    }

                    .empty-state h3 {
                        color: #6c757d;
                        margin-bottom: 1rem;
                    }

                    .btn-primary-custom {
                        background-color: #ff4757;
                        border: none;
                        color: white;
                        padding: 0.75rem 2rem;
                        border-radius: 8px;
                        font-weight: 600;
                        text-decoration: none;
                        display: inline-block;
                        transition: background-color 0.3s;
                    }

                    .btn-primary-custom:hover {
                        background-color: #e83845;
                        color: white;
                    }

                    .alert {
                        border-radius: 8px;
                        padding: 1rem 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .rating-stars {
                        display: flex;
                        gap: 0.5rem;
                        font-size: 2rem;
                        justify-content: center;
                        margin: 1rem 0;
                    }

                    .rating-stars i {
                        cursor: pointer;
                        color: #ddd;
                        transition: color 0.2s;
                    }

                    .rating-stars i.active,
                    .rating-stars i:hover {
                        color: #ffc107;
                    }

                    .review-textarea {
                        width: 100%;
                        min-height: 120px;
                        padding: 0.75rem;
                        border: 1px solid #dee2e6;
                        border-radius: 8px;
                        resize: vertical;
                        font-family: inherit;
                    }

                    .review-textarea:focus {
                        outline: none;
                        border-color: #ffc107;
                        box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
                    }

                    /* Pagination Styles */
                    .pagination {
                        margin: 2rem 0;
                    }

                    .pagination .page-link {
                        color: #ff4757;
                        border: 1px solid #dee2e6;
                        padding: 0.5rem 0.75rem;
                        margin: 0 0.25rem;
                        border-radius: 5px;
                        transition: all 0.3s;
                    }

                    .pagination .page-link:hover {
                        background-color: #ff4757;
                        color: white;
                        border-color: #ff4757;
                    }

                    .pagination .page-item.active .page-link {
                        background-color: #ff4757;
                        border-color: #ff4757;
                        color: white;
                    }

                    .pagination .page-item.disabled .page-link {
                        color: #6c757d;
                        pointer-events: none;
                        background-color: #fff;
                        border-color: #dee2e6;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <div class="container">
                    <h1 class="page-title">Lịch sử đơn hàng</h1>

                    <!-- Thông báo -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="success" scope="session" />
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="error" scope="session" />
                    </c:if>

                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="empty-state">
                                <i class="fas fa-shopping-bag"></i>
                                <h3>Chưa có đơn hàng nào</h3>
                                <p class="text-muted">Hãy bắt đầu khám phá và đặt món yêu thích của bạn!</p>
                                <a href="home" class="btn-primary-custom mt-3">
                                    <i class="fas fa-home"></i> Về trang chủ
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}">
                                <div class="order-card">
                                    <div class="order-header">
                                        <div>
                                            <div class="order-id">Đơn hàng #${order.orderID}</div>
                                            <div class="order-date">
                                                <i class="far fa-clock"></i>
                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </div>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${order.orderStatus == 'Preparing'}">
                                                    <span class="order-status status-preparing">
                                                        <i class="fas fa-clock"></i> Đang chuẩn bị
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Delivering'}">
                                                    <span class="order-status status-delivering">
                                                        <i class="fas fa-shipping-fast"></i> Đang giao
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Completed'}">
                                                    <span class="order-status status-completed">
                                                        <i class="fas fa-check-circle"></i> Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Cancelled'}">
                                                    <span class="order-status status-cancelled">
                                                        <i class="fas fa-times-circle"></i> Đã hủy
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="restaurant-name">
                                        <i class="fas fa-store"></i>
                                        ${restaurantMap[order.restaurantID].name}
                                    </div>

                                    <div class="order-items">
                                        <c:forEach var="item" items="${orderItemsMap[order.orderID]}">
                                            <div class="order-item">
                                                <c:set var="menuItem" value="${menuItemMap[item.itemID]}" />
                                                <c:choose>
                                                    <c:when test="${not empty menuItem.imageUrl}">
                                                        <img src="${menuItem.imageUrl}" alt="${menuItem.itemName}"
                                                            class="item-image"
                                                            onerror="this.src='${pageContext.request.contextPath}/images/food_default.png'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/images/food_default.png"
                                                            alt="${menuItem.itemName}" class="item-image">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="item-details">
                                                    <div class="item-name">${menuItem.itemName}</div>
                                                    <div class="item-quantity">Số lượng: ${item.quantity}</div>
                                                </div>
                                                <div class="item-price">
                                                    <fmt:formatNumber value="${item.unitPrice * item.quantity}"
                                                        pattern="#,###" /> VND
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <div class="order-footer">
                                        <div class="payment-info">
                                            <div class="payment-method">
                                                <i class="fas fa-credit-card"></i>
                                                <c:choose>
                                                    <c:when test="${order.paymentMethod == 'COD'}">
                                                        Thanh toán khi nhận hàng
                                                    </c:when>
                                                    <c:when test="${order.paymentMethod == 'VNPay'}">
                                                        VNPay
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${order.paymentMethod}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${order.paymentStatus == 'Pending'}">
                                                        <span class="payment-status payment-pending">
                                                            <i class="fas fa-clock"></i> Chưa thanh toán
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.paymentStatus == 'Success'}">
                                                        <span class="payment-status payment-success">
                                                            <i class="fas fa-check-circle"></i> Đã thanh toán
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.paymentStatus == 'Failed'}">
                                                        <span class="payment-status payment-failed">
                                                            <i class="fas fa-times-circle"></i> Thanh toán thất bại
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="order-total">
                                            <div class="total-label">Tổng cộng</div>
                                            <div class="total-amount">
                                                <fmt:formatNumber value="${order.finalAmount}" pattern="#,###" /> VND
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Review & complaint for completed orders -->
                                    <c:if test="${order.orderStatus == 'Completed'}">
                                        <div class="mt-3 d-flex flex-wrap justify-content-end gap-2">
                                            <c:choose>
                                                <c:when test="${reviewedOrdersMap[order.orderID]}">
                                                    <button type="button" class="btn btn-secondary" disabled>
                                                        <i class="fas fa-check"></i> Đã đánh giá
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-warning"
                                                        onclick="openReviewModal(${order.orderID}, ${order.restaurantID}, '${restaurantMap[order.restaurantID].name}')">
                                                        <i class="fas fa-star"></i> Đánh giá đơn hàng
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${complainedOrdersMap[order.orderID]}">
                                                    <button type="button" class="btn btn-secondary" disabled>
                                                        <i class="fas fa-check"></i> Đã gửi khiếu nại
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-outline-danger"
                                                        onclick="openComplaintModal(${order.orderID}, '${restaurantMap[order.restaurantID].name}')">
                                                        <i class="fas fa-triangle-exclamation"></i> Khiếu nại
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Order history pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <!-- Previous button -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>

                                <!-- Page numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${currentPage == i}">
                                            <li class="page-item active">
                                                <span class="page-link">${i}</span>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${i}">${i}</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <!-- Next button -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                            <p class="text-center text-muted">
                                Trang ${currentPage} / ${totalPages} (Tổng ${totalOrders} đơn hàng)
                            </p>
                        </nav>
                    </c:if>
                </div>

                <!-- Review Modal -->
                <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="reviewModalLabel">
                                    <i class="fas fa-star text-warning"></i> Đánh giá đơn hàng
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="reviewForm" action="review" method="POST">
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="orderId" id="reviewOrderId">
                                    <input type="hidden" name="restaurantId" id="reviewRestaurantId">
                                    <input type="hidden" name="rating" id="reviewRating" value="5">

                                    <div class="mb-3">
                                        <h6 class="text-center mb-2">Nhà hàng: <span id="reviewRestaurantName"
                                                class="text-primary"></span></h6>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label text-center d-block">Đánh giá của bạn</label>
                                        <div class="rating-stars" id="ratingStars">
                                            <i class="fas fa-star" data-rating="1"></i>
                                            <i class="fas fa-star" data-rating="2"></i>
                                            <i class="fas fa-star" data-rating="3"></i>
                                            <i class="fas fa-star" data-rating="4"></i>
                                            <i class="fas fa-star" data-rating="5"></i>
                                        </div>
                                        <p class="text-center text-muted small">Nhấn vào sao để đánh giá</p>
                                    </div>

                                    <div class="mb-3">
                                        <label for="reviewComment" class="form-label">Nhận xét của bạn</label>
                                        <textarea class="review-textarea" id="reviewComment" name="comment"
                                            placeholder="Chia sẻ trải nghiệm của bạn về đơn hàng này..."
                                            required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                        <i class="fas fa-times"></i> Hủy
                                    </button>
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fas fa-paper-plane"></i> Gửi đánh giá
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Complaint modal (styled like review) -->
                <div class="modal fade" id="complaintModal" tabindex="-1" aria-labelledby="complaintModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header border-danger">
                                <h5 class="modal-title text-danger" id="complaintModalLabel">
                                    <i class="fas fa-triangle-exclamation"></i> Khiếu nại đơn hàng
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="complaintForm" action="${pageContext.request.contextPath}/submit-complaint" method="POST">
                                <div class="modal-body">
                                    <input type="hidden" name="orderId" id="complaintOrderId">
                                    <div class="mb-3">
                                        <h6 class="text-center mb-2">Nhà hàng: <span id="complaintRestaurantName"
                                                class="text-primary"></span></h6>
                                        <p class="text-muted small text-center mb-0">Mô tả vấn đề (tối đa 255 ký tự). Khiếu nại
                                            được gửi riêng cho admin, khác với đánh giá công khai.</p>
                                    </div>
                                    <div class="mb-3">
                                        <label for="complaintDescription" class="form-label">Nội dung khiếu nại <span
                                                class="text-danger">*</span></label>
                                        <textarea class="review-textarea" id="complaintDescription" name="description"
                                            maxlength="255" rows="4"
                                            placeholder="Mô tả chi tiết vấn đề với đơn hàng này..." required></textarea>
                                        <div class="form-text text-end"><span id="complaintCharCount">0</span>/255</div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                        <i class="fas fa-times"></i> Hủy
                                    </button>
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-paper-plane"></i> Gửi khiếu nại
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="includes/footer.jsp" />

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    let selectedRating = 5;

                    function openComplaintModal(orderId, restaurantName) {
                        document.getElementById('complaintOrderId').value = orderId;
                        document.getElementById('complaintRestaurantName').textContent = restaurantName;
                        const ta = document.getElementById('complaintDescription');
                        ta.value = '';
                        document.getElementById('complaintCharCount').textContent = '0';
                        const modal = new bootstrap.Modal(document.getElementById('complaintModal'));
                        modal.show();
                    }

                    function openReviewModal(orderId, restaurantId, restaurantName) {
                        document.getElementById('reviewOrderId').value = orderId;
                        document.getElementById('reviewRestaurantId').value = restaurantId;
                        document.getElementById('reviewRestaurantName').textContent = restaurantName;
                        document.getElementById('reviewRating').value = 5;
                        document.getElementById('reviewComment').value = '';

                        // Reset stars to 5
                        selectedRating = 5;
                        updateStars(5);

                        const modal = new bootstrap.Modal(document.getElementById('reviewModal'));
                        modal.show();
                    }

                    function updateStars(rating) {
                        const stars = document.querySelectorAll('#ratingStars i');
                        stars.forEach((star, index) => {
                            if (index < rating) {
                                star.classList.add('active');
                            } else {
                                star.classList.remove('active');
                            }
                        });
                    }

                    // Star rating click handler
                    document.addEventListener('DOMContentLoaded', function () {
                        const stars = document.querySelectorAll('#ratingStars i');

                        stars.forEach(star => {
                            star.addEventListener('click', function () {
                                selectedRating = parseInt(this.getAttribute('data-rating'));
                                document.getElementById('reviewRating').value = selectedRating;
                                updateStars(selectedRating);
                            });

                            star.addEventListener('mouseenter', function () {
                                const hoverRating = parseInt(this.getAttribute('data-rating'));
                                updateStars(hoverRating);
                            });
                        });

                        document.getElementById('ratingStars').addEventListener('mouseleave', function () {
                            updateStars(selectedRating);
                        });

                        // Initialize all stars as active (5 stars)
                        updateStars(5);

                        const complaintTa = document.getElementById('complaintDescription');
                        const complaintCnt = document.getElementById('complaintCharCount');
                        if (complaintTa && complaintCnt) {
                            complaintTa.addEventListener('input', function () {
                                complaintCnt.textContent = String(complaintTa.value.length);
                            });
                        }
                    });
                </script>
            </body>

            </html>