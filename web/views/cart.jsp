<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - FoodieExpress</title>
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
        .cart-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .cart-header {
            background: linear-gradient(135deg, var(--theme-color) 0%, #2c3e50 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        .cart-item {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .cart-summary {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: sticky;
            top: 100px;
        }
        .btn-checkout {
            background-color: var(--theme-color);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            color: white;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
        }
        .btn-checkout:hover {
            background-color: #1e7e34;
            transform: scale(1.02);
        }
        .quantity-input {
            width: 80px;
            text-align: center;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            padding: 0.5rem;
        }
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 15px;
        }
        .empty-cart i {
            font-size: 5rem;
            color: #ccc;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <!-- Toast Messages -->
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3" style="z-index: 9999;" role="alert">
            ${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3" style="z-index: 9999;" role="alert">
            ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session" />
    </c:if>

    <div class="cart-container">
        <div class="cart-header">
            <h1><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h1>
            <p class="mb-0">Quản lý các món ăn bạn muốn đặt</p>
        </div>

        <c:choose>
            <c:when test="${empty cartItems or cartItems.size() == 0}">
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Giỏ hàng trống</h3>
                    <p>Bạn chưa có món nào trong giỏ hàng. Hãy thêm món từ menu nhà hàng!</p>
                    <a href="home" class="btn btn-success btn-lg">
                        <i class="fas fa-utensils"></i> Xem nhà hàng
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-lg-8">
                        <c:forEach var="entry" items="${cartItems}">
                            <c:set var="item" value="${entry.key}" />
                            <c:set var="quantity" value="${entry.value}" />
                            <div class="cart-item">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <img src="https://via.placeholder.com/150?text=${item.itemName}" 
                                             alt="${item.itemName}" 
                                             class="img-fluid rounded">
                                    </div>
                                    <div class="col-md-4">
                                        <h5 class="mb-1">${item.itemName}</h5>
                                        <c:if test="${not empty item.description}">
                                            <p class="text-muted small mb-0">${item.description}</p>
                                        </c:if>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <span class="text-muted">Giá:</span>
                                        <div class="fw-bold text-success">
                                            <fmt:formatNumber value="${item.price}" pattern="#,###"/> VND
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <form method="POST" action="cart" class="d-inline">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="itemId" value="${item.itemID}">
                                            <input type="number" 
                                                   name="quantity" 
                                                   value="${quantity}" 
                                                   min="1" 
                                                   max="99"
                                                   class="quantity-input"
                                                   onchange="this.form.submit()">
                                        </form>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <div class="mb-2">
                                            <span class="fw-bold text-success">
                                                <fmt:formatNumber value="${item.price * quantity}" pattern="#,###"/> VND
                                            </span>
                                        </div>
                                        <form method="POST" action="cart" class="d-inline">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="itemId" value="${item.itemID}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div class="text-end mt-3">
                            <form method="POST" action="cart" class="d-inline">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')">
                                    <i class="fas fa-trash-alt"></i> Xóa toàn bộ
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <div class="cart-summary">
                            <h4 class="mb-4">Tóm tắt đơn hàng</h4>
                            
                            <div class="d-flex justify-content-between mb-3">
                                <span>Tạm tính:</span>
                                <span><fmt:formatNumber value="${totalAmount}" pattern="#,###"/> VND</span>
                            </div>
                            
                            <c:set var="restaurantId" value="0" />
                            <c:forEach var="entry" items="${cartItems}">
                                <c:if test="${restaurantId == 0}">
                                    <c:set var="restaurantId" value="${entry.key.restaurantID}" />
                                </c:if>
                            </c:forEach>
                            
                            <hr>
                            
                            <div class="d-flex justify-content-between mb-4">
                                <span class="fw-bold">Tổng cộng:</span>
                                <span class="fw-bold text-success fs-5">
                                    <fmt:formatNumber value="${totalAmount}" pattern="#,###"/> VND
                                </span>
                            </div>
                            
                            <form method="POST" action="order">
                                <input type="hidden" name="restaurantId" value="${restaurantId}">
                                <button type="submit" class="btn btn-checkout">
                                    <i class="fas fa-credit-card"></i> Đặt hàng
                                </button>
                            </form>
                            
                            <a href="home" class="btn btn-outline-secondary w-100 mt-3">
                                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
