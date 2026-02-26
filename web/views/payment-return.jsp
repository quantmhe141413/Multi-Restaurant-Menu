<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán - VNPay</title>
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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
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
        .site-footer__inner {
            max-width: 1400px;
            margin: 0 auto;
        }
        .site-footer p {
            margin: 0;
        }
        .payment-result-container {
            max-width: 800px;
            margin: 3rem auto;
            padding: 2rem;
        }
        .payment-result-card {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .payment-icon {
            font-size: 5rem;
            margin-bottom: 1.5rem;
        }
        .payment-icon.success { color: var(--theme-color); }
        .payment-icon.failed { color: #dc3545; }
        .payment-title {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        .payment-message {
            font-size: 1.1rem;
            color: #6c757d;
            margin-bottom: 2rem;
        }
        .payment-details {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 2rem;
            margin: 2rem 0;
            text-align: left;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #dee2e6;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 500;
            color: #6c757d;
        }
        .detail-value {
            font-weight: 600;
            color: #212529;
        }
        .payment-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            align-items: center;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        .btn-custom {
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-primary-custom {
            background-color: var(--theme-color);
            color: white;
            border: none;
        }
        .btn-primary-custom:hover {
            background-color: #1e7e34;
            color: white;
        }
        .btn-secondary-custom {
            background-color: white;
            color: #6c757d;
            border: 2px solid #dee2e6;
        }
        .btn-secondary-custom:hover {
            background-color: #f8f9fa;
            color: #495057;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <%
        String paymentStatus = (String) request.getAttribute("paymentStatus");
        String message = (String) request.getAttribute("message");
        Boolean isValidSignature = (Boolean) request.getAttribute("isValidSignature");

        String vnp_TxnRef = (String) request.getAttribute("vnp_TxnRef");
        String vnp_Amount = (String) request.getAttribute("vnp_Amount");
        String vnp_OrderInfo = (String) request.getAttribute("vnp_OrderInfo");
        String vnp_ResponseCode = (String) request.getAttribute("vnp_ResponseCode");
        String vnp_TransactionNo = (String) request.getAttribute("vnp_TransactionNo");
        String vnp_BankCode = (String) request.getAttribute("vnp_BankCode");
        String vnp_PayDate = (String) request.getAttribute("vnp_PayDate");

        boolean isSuccess = "success".equals(paymentStatus);

        long amountInVND = 0;
        if (vnp_Amount != null && !vnp_Amount.isEmpty()) {
            try {
                amountInVND = Long.parseLong(vnp_Amount) / 100;
            } catch (NumberFormatException e) {
            }
        }

        // Format payment date
        String formattedPayDate = "";
        if (vnp_PayDate != null && vnp_PayDate.length() == 14) {
            try {
                formattedPayDate = vnp_PayDate.substring(6, 8) + "/" +
                                  vnp_PayDate.substring(4, 6) + "/" +
                                  vnp_PayDate.substring(0, 4) + " " +
                                  vnp_PayDate.substring(8, 10) + ":" +
                                  vnp_PayDate.substring(10, 12) + ":" +
                                  vnp_PayDate.substring(12, 14);
            } catch (Exception e) {
                formattedPayDate = vnp_PayDate;
            }
        }
    %>

    <div class="payment-result-container">
        <div class="payment-result-card">
            <!-- Payment Icon -->
            <div class="payment-icon <%= isSuccess ? "success" : "failed" %>">
                <% if (isSuccess) { %>
                    <i class="fa-solid fa-circle-check"></i>
                <% } else { %>
                    <i class="fa-solid fa-circle-xmark"></i>
                <% } %>
            </div>

            <!-- Payment Title -->
            <h1 class="payment-title" style="color: <%= isSuccess ? "var(--theme-color)" : "#dc3545" %>;">
                <%= isSuccess ? "Thanh toán thành công!" : "Thanh toán thất bại" %>
            </h1>

            <!-- Payment Message -->
            <p class="payment-message">
                <%= message != null ? message : (isSuccess ? "Đơn hàng của bạn đã được thanh toán thành công." : "Thanh toán của bạn không thể hoàn tất.") %>
            </p>

            <!-- Payment Details -->
            <div class="payment-details">
                <h4 style="margin-top: 0; margin-bottom: 1.5rem; color: #212529;">Chi tiết giao dịch</h4>

                <div class="detail-row">
                    <span class="detail-label">Mã giao dịch:</span>
                    <span class="detail-value"><%= vnp_TxnRef != null ? vnp_TxnRef : "-" %></span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Số tiền:</span>
                    <span class="detail-value" style="color: var(--theme-color); font-size: 1.2rem;">
                        <fmt:formatNumber value="<%= amountInVND %>" pattern="#,###"/> VND
                    </span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Mô tả:</span>
                    <span class="detail-value"><%= vnp_OrderInfo != null ? vnp_OrderInfo : "-" %></span>
                </div>

                <% if (vnp_TransactionNo != null && !vnp_TransactionNo.isEmpty()) { %>
                <div class="detail-row">
                    <span class="detail-label">Mã GD VNPay:</span>
                    <span class="detail-value"><%= vnp_TransactionNo %></span>
                </div>
                <% } %>

                <% if (vnp_BankCode != null && !vnp_BankCode.isEmpty()) { %>
                <div class="detail-row">
                    <span class="detail-label">Ngân hàng:</span>
                    <span class="detail-value"><%= vnp_BankCode %></span>
                </div>
                <% } %>

                <% if (!formattedPayDate.isEmpty()) { %>
                <div class="detail-row">
                    <span class="detail-label">Thời gian:</span>
                    <span class="detail-value"><%= formattedPayDate %></span>
                </div>
                <% } %>

                <div class="detail-row">
                    <span class="detail-label">Mã phản hồi:</span>
                    <span class="detail-value"><%= vnp_ResponseCode != null ? vnp_ResponseCode : "-" %></span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Trạng thái:</span>
                    <span class="detail-value">
                        <span class="badge <%= isSuccess ? "bg-success" : "bg-danger" %>">
                            <%= isSuccess ? "Thành công" : "Thất bại" %>
                        </span>
                    </span>
                </div>

                <% if (isValidSignature != null && !isValidSignature) { %>
                <div class="detail-row">
                    <span class="detail-label" style="color: #dc3545;">Cảnh báo bảo mật:</span>
                    <span class="detail-value" style="color: #dc3545;">Chữ ký không hợp lệ</span>
                </div>
                <% } %>
            </div>

            <!-- Action Buttons -->
            <div class="payment-actions">
                <a href="<%= request.getContextPath() %>/home" class="btn-custom btn-primary-custom">
                    <i class="fas fa-home"></i> Về trang chủ
                </a>
                <% if (!isSuccess) { %>
                <a href="<%= request.getContextPath() %>/cart" class="btn-custom btn-secondary-custom">
                    <i class="fas fa-shopping-cart"></i> Quay lại giỏ hàng
                </a>
                <% } %>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
