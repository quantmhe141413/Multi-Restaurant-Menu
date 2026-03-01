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

                    .btn-review {
                        background-color: #ffc107;
                        color: #333;
                        border: none;
                        padding: 0.5rem 1.2rem;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: background-color 0.3s;
                    }

                    .btn-review:hover {
                        background-color: #e0a800;
                    }

                    .btn-reviewed {
                        background-color: #d1e7dd;
                        color: #0f5132;
                        border: none;
                        padding: 0.5rem 1.2rem;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: default;
                    }

                    .review-form {
                        background: #f8f9fa;
                        border-radius: 10px;
                        padding: 1.5rem;
                        margin-top: 1rem;
                        border: 1px solid #e9ecef;
                        display: none;
                    }

                    .review-form.show {
                        display: block;
                    }

                    .star-rating {
                        display: flex;
                        gap: 0.25rem;
                        flex-direction: row-reverse;
                        justify-content: flex-end;
                    }

                    .star-rating input {
                        display: none;
                    }

                    .star-rating label {
                        font-size: 1.8rem;
                        color: #ddd;
                        cursor: pointer;
                        transition: color 0.2s;
                    }

                    .star-rating input:checked~label,
                    .star-rating label:hover,
                    .star-rating label:hover~label {
                        color: #ffc107;
                    }

                    .alert {
                        border-radius: 8px;
                        padding: 1rem 1.5rem;
                        margin-bottom: 1.5rem;
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

                                    <!-- Review Section - chỉ hiển thị cho đơn hàng Completed -->
                                    <c:if test="${order.orderStatus == 'Completed'}">
                                        <div
                                            style="border-top: 1px solid #e9ecef; margin-top: 1rem; padding-top: 1rem;">
                                            <c:choose>
                                                <c:when test="${reviewedOrders.contains(order.orderID)}">
                                                    <button class="btn-reviewed" disabled>
                                                        <i class="fas fa-check-circle"></i> Đã đánh giá đơn hàng này
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-review"
                                                        onclick="toggleReviewForm(${order.orderID})">
                                                        <i class="fas fa-star"></i> Đánh giá nhà hàng
                                                    </button>
                                                    <div class="review-form" id="reviewForm-${order.orderID}">
                                                        <form action="review" method="POST">
                                                            <input type="hidden" name="orderId"
                                                                value="${order.orderID}" />
                                                            <input type="hidden" name="restaurantId"
                                                                value="${order.restaurantID}" />
                                                            <h6 style="font-weight: 600; margin-bottom: 1rem;">
                                                                <i class="fas fa-star" style="color: #ffc107;"></i> Đánh
                                                                giá ${restaurantMap[order.restaurantID].name}
                                                            </h6>
                                                            <div style="margin-bottom: 1rem;">
                                                                <label
                                                                    style="font-weight: 500; margin-bottom: 0.5rem; display: block;">Số
                                                                    sao:</label>
                                                                <div class="star-rating">
                                                                    <input type="radio" id="star5-${order.orderID}"
                                                                        name="rating" value="5" required>
                                                                    <label for="star5-${order.orderID}"><i
                                                                            class="fas fa-star"></i></label>
                                                                    <input type="radio" id="star4-${order.orderID}"
                                                                        name="rating" value="4">
                                                                    <label for="star4-${order.orderID}"><i
                                                                            class="fas fa-star"></i></label>
                                                                    <input type="radio" id="star3-${order.orderID}"
                                                                        name="rating" value="3">
                                                                    <label for="star3-${order.orderID}"><i
                                                                            class="fas fa-star"></i></label>
                                                                    <input type="radio" id="star2-${order.orderID}"
                                                                        name="rating" value="2">
                                                                    <label for="star2-${order.orderID}"><i
                                                                            class="fas fa-star"></i></label>
                                                                    <input type="radio" id="star1-${order.orderID}"
                                                                        name="rating" value="1">
                                                                    <label for="star1-${order.orderID}"><i
                                                                            class="fas fa-star"></i></label>
                                                                </div>
                                                            </div>
                                                            <div style="margin-bottom: 1rem;">
                                                                <label for="comment-${order.orderID}"
                                                                    style="font-weight: 500; margin-bottom: 0.5rem; display: block;">Nhận
                                                                    xét (tùy chọn):</label>
                                                                <textarea name="comment" id="comment-${order.orderID}"
                                                                    rows="3" maxlength="255"
                                                                    placeholder="Chia sẻ trải nghiệm của bạn..."
                                                                    style="width: 100%; border: 1px solid #ddd; border-radius: 8px; padding: 0.75rem; outline: none; resize: vertical;"></textarea>
                                                            </div>
                                                            <div style="display: flex; gap: 0.5rem;">
                                                                <button type="submit" class="btn btn-success"
                                                                    style="border-radius: 8px; padding: 0.5rem 1.5rem; font-weight: 600;">
                                                                    <i class="fas fa-paper-plane"></i> Gửi đánh giá
                                                                </button>
                                                                <button type="button" class="btn btn-secondary"
                                                                    style="border-radius: 8px; padding: 0.5rem 1.5rem;"
                                                                    onclick="toggleReviewForm(${order.orderID})">
                                                                    Hủy
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <jsp:include page="includes/footer.jsp" />

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function toggleReviewForm(orderId) {
                        var form = document.getElementById('reviewForm-' + orderId);
                        if (form) {
                            form.classList.toggle('show');
                        }
                    }
                </script>
            </body>

            </html>