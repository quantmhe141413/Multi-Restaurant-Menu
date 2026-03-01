<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - FoodieExpress</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 5%;
        }
        .checkout-header {
            margin-bottom: 2rem;
        }
        .checkout-header h2 {
            color: #2f3542;
            font-weight: 700;
        }
        .checkout-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2rem;
        }
        .delivery-form {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .form-section {
            margin-bottom: 2rem;
        }
        .form-section h5 {
            color: #2f3542;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #495057;
            font-weight: 500;
        }
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            font-size: 1rem;
        }
        .form-control:focus {
            outline: none;
            border-color: #ff4757;
            box-shadow: 0 0 0 0.2rem rgba(255,71,87,0.25);
        }
        .payment-method-section {
            margin-top: 2rem;
        }
        .form-check {
            margin-bottom: 1rem;
            padding: 1rem;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            transition: border-color 0.3s;
        }
        .form-check:has(input:checked) {
            border-color: #ff4757;
            background-color: #fff5f5;
        }
        .form-check-input {
            width: 1.25rem;
            height: 1.25rem;
        }
        .order-summary {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            height: fit-content;
            position: sticky;
            top: 100px;
        }
        .order-summary h5 {
            color: #2f3542;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e9ecef;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .item-info {
            flex: 1;
        }
        .item-name {
            font-weight: 500;
            color: #2f3542;
        }
        .item-quantity {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .item-price {
            color: #2f3542;
            font-weight: 600;
        }
        .order-total {
            border-top: 2px solid #e9ecef;
            padding-top: 1rem;
            margin-top: 1rem;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        .total-label {
            color: #6c757d;
        }
        .total-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #28a745;
        }
        .btn-place-order {
            width: 100%;
            padding: 1rem;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 1.5rem;
        }
        .btn-place-order:hover {
            background-color: #218838;
        }
        .btn-back {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            margin-top: 1rem;
        }
        .btn-back:hover {
            background-color: #5a6268;
            color: white;
        }
        @media (max-width: 992px) {
            .checkout-content {
                grid-template-columns: 1fr;
            }
            .order-summary {
                position: static;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
        <div class="checkout-header">
            <h2><i class="fas fa-shopping-bag"></i> Thanh toán</h2>
        </div>

        <div class="checkout-content">
            <!-- Delivery Form -->
            <div class="delivery-form">
                <form method="POST" action="order" id="checkoutForm">
                    <input type="hidden" name="restaurantId" value="${restaurantId}">
                    <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="COD">
                    
                    <!-- Contact Information -->
                    <div class="form-section">
                        <h5><i class="fas fa-user"></i> Thông tin liên hệ</h5>
                        <div class="form-group">
                            <label for="fullName">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${sessionScope.user.fullName}" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="phone" name="phone" 
                                   pattern="[0-9]{10}" placeholder="0123456789" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="${sessionScope.user.email}">
                        </div>
                    </div>

                    <!-- Delivery Address -->
                    <div class="form-section">
                        <h5><i class="fas fa-map-marker-alt"></i> Địa chỉ giao hàng</h5>
                        <div class="form-group">
                            <label for="address">Địa chỉ cụ thể <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="address" name="address" 
                                   placeholder="Số nhà, tên đường" required>
                        </div>
                        <div class="form-group">
                            <label for="ward">Phường/Xã <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="ward" name="ward" required>
                        </div>
                        <div class="form-group">
                            <label for="district">Quận/Huyện <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="district" name="district" required>
                        </div>
                        <div class="form-group">
                            <label for="city">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="city" name="city" 
                                   value="Hồ Chí Minh" required>
                        </div>
                        <div class="form-group">
                            <label for="note">Ghi chú (tùy chọn)</label>
                            <textarea class="form-control" id="note" name="note" rows="3" 
                                      placeholder="Ghi chú thêm về đơn hàng..."></textarea>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="form-section payment-method-section">
                        <h5><i class="fas fa-credit-card"></i> Phương thức thanh toán</h5>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethodRadio" 
                                   id="paymentCOD" value="COD" checked>
                            <label class="form-check-label" for="paymentCOD">
                                <i class="fas fa-money-bill-wave text-success"></i> 
                                <strong>Thanh toán khi nhận hàng (COD)</strong>
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethodRadio" 
                                   id="paymentVNPay" value="VNPay">
                            <label class="form-check-label" for="paymentVNPay">
                                <i class="fas fa-credit-card text-primary"></i> 
                                <strong>Thanh toán online qua VNPay</strong>
                            </label>
                        </div>
                    </div>

                    <a href="cart" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                    </a>
                </form>
            </div>

            <!-- Order Summary -->
            <div class="order-summary">
                <h5>Đơn hàng của bạn</h5>
                <c:forEach var="entry" items="${cartItems}">
                    <div class="order-item">
                        <div class="item-info">
                            <div class="item-name">${entry.key.itemName}</div>
                            <div class="item-quantity">Số lượng: ${entry.value}</div>
                        </div>
                        <div class="item-price">
                            <fmt:formatNumber value="${entry.key.price * entry.value}" pattern="#,###"/> ₫
                        </div>
                    </div>
                </c:forEach>
                
                <div class="order-total">
                    <div class="total-row">
                        <span class="total-label">Tạm tính:</span>
                        <span><fmt:formatNumber value="${totalAmount}" pattern="#,###"/> ₫</span>
                    </div>
                    <div class="total-row">
                        <span class="total-label">Phí giao hàng:</span>
                        <span>Miễn phí</span>
                    </div>
                    <div class="total-row" style="margin-top: 1rem;">
                        <span style="font-weight: 600; font-size: 1.1rem;">Tổng cộng:</span>
                        <span class="total-amount">
                            <fmt:formatNumber value="${totalAmount}" pattern="#,###"/> ₫
                        </span>
                    </div>
                </div>

                <button type="submit" form="checkoutForm" class="btn-place-order">
                    <i class="fas fa-check-circle"></i> Đặt hàng
                </button>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <!-- Include Confirm Modal Component -->
    <jsp:include page="/views/components/confirm-modal.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update hidden input when payment method changes
        document.querySelectorAll('input[name="paymentMethodRadio"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                document.getElementById('selectedPaymentMethod').value = this.value;
            });
        });

        // Handle checkout form submission with confirm modal
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            var form = this;
            var paymentMethod = document.getElementById('selectedPaymentMethod').value;
            var paymentMethodText = paymentMethod === 'COD' ? 'Thanh toán khi nhận hàng (COD)' : 'VNPay';
            var fullName = document.getElementById('fullName').value;
            var phone = document.getElementById('phone').value;
            var address = document.getElementById('address').value;
            
            // Show confirm modal
            ConfirmModal.show({
                title: 'Xác nhận đặt hàng',
                message: 'Xác nhận đặt hàng cho ' + fullName + ' (' + phone + ') giao đến ' + address + '?\nPhương thức thanh toán: ' + paymentMethodText,
                confirmText: 'Xác nhận đặt hàng',
                cancelText: 'Kiểm tra lại',
                icon: 'fas fa-shopping-cart text-success',
                confirmBtnStyle: 'background-color: #28a745; border: none;',
                onConfirm: function() {
                    form.submit();
                }
            });
        });
    </script>
</body>
</html>
