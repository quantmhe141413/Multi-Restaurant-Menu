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
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
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
                        box-shadow: 0 0 0 0.2rem rgba(255, 71, 87, 0.25);
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
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
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
                                            pattern="[0-9]{10}" placeholder="0123456789"
                                            value="${sessionScope.user.phone}" required>
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
                                        <label for="city">Khu vực giao hàng <span class="text-danger">*</span></label>
                                        <select class="form-control" id="zoneId" name="zoneId" required>
                                            <option value="">-- Chọn khu vực giao hàng --</option>
                                            <c:forEach var="zone" items="${deliveryZones}">
                                                <option value="${zone.zoneId}">${zone.zoneName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <input type="hidden" id="deliveryFeeInput" name="deliveryFee" value="0">
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
                                        <fmt:formatNumber value="${entry.key.price * entry.value}" pattern="#,###" /> ₫
                                    </div>
                                </div>
                            </c:forEach>

                            <div class="order-total">
                                <div class="total-row">
                                    <span class="total-label">Tạm tính:</span>
                                    <span>
                                        <fmt:formatNumber value="${totalAmount}" pattern="#,###" /> ₫
                                    </span>
                                </div>
                                <!-- Discount row (hidden by default, shown when a valid code is applied) -->
                                <div class="total-row" id="discountRow"
                                    style="display: ${not empty bestDiscount ? 'flex' : 'none'};">
                                    <span class="total-label">Giảm giá:</span>
                                    <span id="discountAmountText" style="color: #ff4757; font-weight: 600;">
                                        <c:choose>
                                            <c:when test="${not empty bestDiscount}">-
                                                <fmt:formatNumber value="${maxDiscountGained}" pattern="#,###" /> ₫
                                            </c:when>
                                            <c:otherwise>- 0 ₫</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="total-row" id="deliveryFeeRow">
                                    <span class="total-label">Phí giao hàng:</span>
                                    <span id="deliveryFeeText">---</span>
                                </div>
                                <div class="total-row" style="margin-top: 1rem;">
                                    <span style="font-weight: 600; font-size: 1.1rem;">Tổng cộng:</span>
                                    <span class="total-amount" id="finalAmountText"
                                        data-original-total="${totalAmount}">
                                        <fmt:formatNumber value="${totalAmount - maxDiscountGained}" pattern="#,###" />
                                        ₫
                                    </span>
                                </div>
                            </div>

                            <!-- Discount code section -->
                            <div class="mt-4">
                                <label class="form-label" style="font-weight: 500;">
                                    <i class="fas fa-ticket-alt text-danger"></i> Ưu đãi của bạn
                                </label>

                                <c:if test="${not empty bestDiscount}">
                                    <div class="alert alert-success py-2 mb-3 mt-2" id="autoAppliedAlert">
                                        <strong>Đã áp dụng tốt nhất:</strong> ${bestDiscount.code}
                                        (-
                                        <fmt:formatNumber value="${maxDiscountGained}" pattern="#,###" /> ₫)
                                    </div>
                                </c:if>

                                <button type="button" class="btn btn-outline-primary w-100 mb-2 mt-2"
                                    data-bs-toggle="modal" data-bs-target="#voucherModal">
                                    <i class="fas fa-tags"></i> Tìm hoặc Chọn mã khác
                                </button>
                                <small id="discountMessage" class="form-text text-muted"></small>
                            </div>

                            <!-- Hidden fields to send discount info to server -->
                            <input type="hidden" form="checkoutForm" name="discountId" id="discountId"
                                value="${not empty bestDiscount ? bestDiscount.discountID : ''}">
                            <input type="hidden" form="checkoutForm" name="discountAmount" id="discountAmount"
                                value="${maxDiscountGained}">
                            <input type="hidden" form="checkoutForm" name="finalAmount" id="finalAmount"
                                value="${totalAmount - maxDiscountGained}">

                            <button type="submit" form="checkoutForm" class="btn-place-order mt-4">
                                <i class="fas fa-check-circle"></i> Đặt hàng
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Voucher Modal -->
                <div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="voucherModalLabel"><i
                                        class="fas fa-ticket-alt text-danger"></i> Ví Voucher</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body bg-light">
                                <!-- Manual input -->
                                <div class="input-group mb-4">
                                    <input type="text" id="discountCode" class="form-control"
                                        placeholder="Nhập mã ưu đãi hoặc mã nội bộ...">
                                    <button type="button" id="applyDiscountBtn" class="btn btn-primary"
                                        data-bs-dismiss="modal">Áp dụng</button>
                                </div>

                                <c:if test="${not empty usableVouchers}">
                                    <h6 class="mb-3 text-success"><i class="fas fa-check-circle"></i> Có thể sử dụng
                                        (${usableVouchers.size()})</h6>
                                    <c:forEach var="v" items="${usableVouchers}">
                                        <div class="card mb-3 border-success shadow-sm">
                                            <div class="card-body d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="card-title text-success mb-1">${v.code}</h5>
                                                    <p class="card-text mb-0 fs-6">
                                                        <c:choose>
                                                            <c:when test="${v.discountType == 'Percentage'}">
                                                                Giảm
                                                                <fmt:formatNumber value="${v.discountValue}"
                                                                    pattern="#,###" />%
                                                                <c:if test="${not empty v.maxDiscountAmount}">
                                                                    <br><small class="text-muted">(Tối đa
                                                                        <fmt:formatNumber value="${v.maxDiscountAmount}"
                                                                            pattern="#,###" /> đ)
                                                                    </small>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Giảm thẳng
                                                                <fmt:formatNumber value="${v.discountValue}"
                                                                    pattern="#,###" /> ₫
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                    <small class="text-secondary d-block mt-1">Đơn tối thiểu
                                                        <fmt:formatNumber value="${v.minOrderAmount}" pattern="#,###" />
                                                        ₫
                                                    </small>
                                                </div>
                                                <button type="button"
                                                    class="btn btn-success btn-sm select-voucher-btn shadow-sm"
                                                    data-code="${v.code}" data-bs-dismiss="modal">Dùng ngay</button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>

                                <c:if test="${not empty unusableVouchers}">
                                    <h6 class="mb-3 text-secondary mt-4"><i class="fas fa-times-circle"></i> Chưa đủ
                                        điều kiện (${unusableVouchers.size()})</h6>
                                    <c:forEach var="uv" items="${unusableVouchers}">
                                        <div class="card mb-3 border-secondary"
                                            style="background-color: #f1f3f5; opacity: 0.85;">
                                            <div class="card-body">
                                                <h5 class="card-title text-secondary mb-1">${uv.code}</h5>
                                                <p class="card-text mb-0 fs-6">
                                                    <c:choose>
                                                        <c:when test="${uv.discountType == 'Percentage'}">Giảm
                                                            <fmt:formatNumber value="${uv.discountValue}"
                                                                pattern="#,###" />%
                                                        </c:when>
                                                        <c:otherwise>Giảm
                                                            <fmt:formatNumber value="${uv.discountValue}"
                                                                pattern="#,###" /> ₫
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <small class="text-danger fw-bold d-block mt-1">
                                                    <c:choose>
                                                        <c:when test="${uv.quantity <= 0}">Đã hết lượt sử dụng</c:when>
                                                        <c:when test="${uv.usageLimitPerUser > 0}">Bạn đã dùng vượt giới
                                                            hạn</c:when>
                                                        <c:otherwise>Cần mua thêm
                                                            <fmt:formatNumber value="${uv.minOrderAmount - totalAmount}"
                                                                pattern="#,###" /> ₫ để sử dụng mã này
                                                        </c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <jsp:include page="includes/footer.jsp" />

                <!-- Include Confirm Modal Component -->
                <jsp:include page="/views/components/confirm-modal.jsp" />

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Helper to format number as VND string
                    function formatCurrencyVND(amount) {
                        return amount.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' }).replace('₫', '').trim() + ' ₫';
                    }

                    // Handle Delivery Zone change
                    document.getElementById('zoneId').addEventListener('change', function () {
                        var zoneId = this.value;
                        var originalTotal = parseFloat(document.getElementById('finalAmountText').getAttribute('data-original-total')) || 0;
                        var deliveryFeeText = document.getElementById('deliveryFeeText');
                        var deliveryFeeInput = document.getElementById('deliveryFeeInput');
                        var finalAmountText = document.getElementById('finalAmountText');
                        var finalAmountInput = document.getElementById('finalAmount');
                        var currentDiscount = parseFloat(document.getElementById('discountAmount').value) || 0;

                        if (!zoneId) {
                            deliveryFeeText.textContent = '---';
                            deliveryFeeInput.value = 0;
                            var newTotal = originalTotal - currentDiscount;
                            finalAmountText.textContent = formatCurrencyVND(newTotal);
                            finalAmountInput.value = newTotal;
                            return;
                        }

                        fetch('${pageContext.request.contextPath}/api/calculate-delivery-fee?zoneId=' + encodeURIComponent(zoneId) + '&totalAmount=' + encodeURIComponent(originalTotal))
                            .then(res => {
                                if (!res.ok) throw new Error('HTTP ' + res.status);
                                return res.json();
                            })
                            .then(data => {
                                if (data.success) {
                                    var fee = parseFloat(data.fee);
                                    if (fee === 0) {
                                        deliveryFeeText.textContent = 'Miễn phí';
                                    } else {
                                        deliveryFeeText.textContent = formatCurrencyVND(fee);
                                    }
                                    deliveryFeeInput.value = fee;
                                    var newTotal = originalTotal - currentDiscount + fee;
                                    finalAmountText.textContent = formatCurrencyVND(newTotal);
                                    finalAmountInput.value = newTotal;
                                } else {
                                    alert(data.message);
                                    document.getElementById('zoneId').value = '';
                                    deliveryFeeText.textContent = '---';
                                    deliveryFeeInput.value = 0;
                                    var newTotal = originalTotal - currentDiscount;
                                    finalAmountText.textContent = formatCurrencyVND(newTotal);
                                    finalAmountInput.value = newTotal;
                                }
                            })
                            .catch(err => {
                                console.error('Error fetching delivery fee:', err);
                            });
                    });

                    // Update hidden input when payment method changes
                    document.querySelectorAll('input[name="paymentMethodRadio"]').forEach(function (radio) {
                        radio.addEventListener('change', function () {
                            document.getElementById('selectedPaymentMethod').value = this.value;
                        });
                    });

                    // Handle checkout form submission with confirm modal
                    document.getElementById('checkoutForm').addEventListener('submit', function (e) {
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
                            onConfirm: function () {
                                form.submit();
                            }
                        });
                    });

                    // Handle apply discount code
                    document.getElementById('applyDiscountBtn').addEventListener('click', function () {
                        var codeInput = document.getElementById('discountCode');
                        var code = codeInput ? codeInput.value.trim() : '';
                        applyDiscountCode(code);
                    });

                    document.querySelectorAll('.select-voucher-btn').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            var code = this.getAttribute('data-code');
                            applyDiscountCode(code);
                        });
                    });

                    function applyDiscountCode(code) {
                        var restaurantId = '${restaurantId}';
                        var originalTotal = parseFloat(document.getElementById('finalAmountText').getAttribute('data-original-total')) || 0;

                        var messageEl = document.getElementById('discountMessage');
                        var discountRow = document.getElementById('discountRow');
                        var discountAmountText = document.getElementById('discountAmountText');
                        var finalAmountText = document.getElementById('finalAmountText');
                        var discountIdInput = document.getElementById('discountId');
                        var discountAmountInput = document.getElementById('discountAmount');
                        var finalAmountInput = document.getElementById('finalAmount');
                        var autoAppliedAlert = document.getElementById('autoAppliedAlert');

                        if (!code) {
                            messageEl.textContent = 'Vui lòng chọn hoặc nhập mã ưu đãi.';
                            messageEl.className = 'form-text text-danger';
                            return;
                        }

                        fetch('${pageContext.request.contextPath}/apply-discount', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                            },
                            body: new URLSearchParams({
                                discountCode: code,
                                restaurantId: restaurantId,
                                totalAmount: originalTotal
                            })
                        }).then(function (res) {
                            return res.json();
                        }).then(function (data) {
                            if (autoAppliedAlert) { autoAppliedAlert.style.display = 'none'; }

                            if (!data.valid) {
                                // Reset discount info
                                discountRow.style.display = 'none';
                                discountAmountText.textContent = '- 0 ₫';
                                finalAmountText.textContent = formatCurrencyVND(originalTotal);
                                finalAmountInput.value = originalTotal;
                                discountIdInput.value = '';
                                discountAmountInput.value = 0;

                                messageEl.textContent = data.message || 'Mã ưu đãi không hợp lệ.';
                                messageEl.className = 'form-text text-danger mt-2';
                            } else {
                                // Apply discount
                                discountRow.style.display = 'flex';
                                discountAmountText.textContent = '- ' + formatCurrencyVND(data.discountAmount);

                                var currentDeliveryFee = parseFloat(document.getElementById('deliveryFeeInput').value) || 0;
                                var newFinalAmount = data.finalAmount + currentDeliveryFee;
                                finalAmountText.textContent = formatCurrencyVND(newFinalAmount);

                                discountIdInput.value = data.discountID;
                                discountAmountInput.value = data.discountAmount;
                                finalAmountInput.value = newFinalAmount;

                                messageEl.innerHTML = '<i class="fas fa-check-circle"></i> ' + (data.message || 'Áp dụng mã ưu đãi thành công!');
                                messageEl.className = 'form-text text-success mt-2 fw-bold';
                            }
                        }).catch(function () {
                            messageEl.textContent = 'Không thể áp dụng mã ưu đãi. Vui lòng thử lại.';
                            messageEl.className = 'form-text text-danger mt-2';
                        });
                    }
                </script>
            </body>

            </html>