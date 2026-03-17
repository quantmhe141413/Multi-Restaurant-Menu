<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${item.itemName} - Chi tiết món ăn</title>
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

                    .site-footer p {
                        margin: 0;
                    }

                    /* Item Detail Styles */
                    .item-detail-section {
                        padding: 3rem 0;
                    }

                    .item-image-container {
                        border-radius: 20px;
                        overflow: hidden;
                        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
                    }

                    .item-image-container img {
                        width: 100%;
                        height: 400px;
                        object-fit: cover;
                    }

                    .item-info-card {
                        background: white;
                        border-radius: 20px;
                        padding: 2rem;
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
                        height: 100%;
                    }

                    .item-name {
                        font-size: 2rem;
                        font-weight: 700;
                        color: #2f3542;
                        margin-bottom: 0.5rem;
                    }

                    .item-sku {
                        color: #888;
                        font-size: 0.9rem;
                        margin-bottom: 1rem;
                    }

                    .item-price {
                        font-size: 2rem;
                        font-weight: 700;
                        color: var(--theme-color);
                        margin-bottom: 1.5rem;
                    }

                    .item-description {
                        color: #555;
                        font-size: 1.05rem;
                        line-height: 1.8;
                        margin-bottom: 1.5rem;
                    }

                    .item-meta {
                        list-style: none;
                        padding: 0;
                        margin-bottom: 1.5rem;
                    }

                    .item-meta li {
                        display: flex;
                        align-items: center;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid #f0f0f0;
                        font-size: 1rem;
                    }

                    .item-meta li:last-child {
                        border-bottom: none;
                    }

                    .item-meta li i {
                        width: 30px;
                        color: var(--theme-color);
                        font-size: 1.1rem;
                    }

                    .item-meta li .meta-label {
                        font-weight: 600;
                        color: #555;
                        min-width: 120px;
                    }

                    .item-meta li .meta-value {
                        color: #333;
                    }

                    .rating-stars {
                        color: #ffc107;
                    }

                    .rating-stars .empty {
                        color: #ddd;
                    }

                    .badge-available {
                        background-color: var(--theme-color);
                        color: white;
                        padding: 0.4rem 1rem;
                        border-radius: 25px;
                        font-size: 0.85rem;
                    }

                    .badge-unavailable {
                        background-color: #dc3545;
                        color: white;
                        padding: 0.4rem 1rem;
                        border-radius: 25px;
                        font-size: 0.85rem;
                    }

                    .btn-add-cart {
                        background-color: var(--theme-color);
                        border: none;
                        padding: 0.75rem 2rem;
                        border-radius: 30px;
                        font-size: 1.1rem;
                        font-weight: 600;
                        transition: all 0.3s;
                        color: white;
                    }

                    .btn-add-cart:hover {
                        background-color: #1e7e34;
                        transform: scale(1.05);
                        color: white;
                    }

                    .btn-back-menu {
                        background-color: #f0f0f0;
                        color: #555;
                        border: none;
                        padding: 0.75rem 2rem;
                        border-radius: 30px;
                        font-size: 1rem;
                        transition: all 0.3s;
                        text-decoration: none;
                    }

                    .btn-back-menu:hover {
                        background-color: #e0e0e0;
                        color: #333;
                    }

                    .breadcrumb-custom {
                        background: transparent;
                        padding: 1rem 0;
                    }

                    .breadcrumb-custom a {
                        color: var(--theme-color);
                        text-decoration: none;
                    }

                    .breadcrumb-custom a:hover {
                        text-decoration: underline;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <div class="container">
                    <!-- Breadcrumb -->
                    <nav class="breadcrumb-custom" aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="home"><i class="fas fa-home"></i> Trang chủ</a></li>
                            <c:if test="${not empty restaurant}">
                                <li class="breadcrumb-item"><a
                                        href="menu?restaurantId=${restaurant.restaurantId}">${restaurant.name}</a></li>
                            </c:if>
                            <c:if test="${not empty category}">
                                <li class="breadcrumb-item">${category.categoryName}</li>
                            </c:if>
                            <li class="breadcrumb-item active" aria-current="page">${item.itemName}</li>
                        </ol>
                    </nav>
                </div>

                <!-- Item Detail -->
                <div class="item-detail-section">
                    <div class="container">
                        <div class="row g-4">
                            <!-- Image -->
                            <div class="col-lg-6">
                                <div class="item-image-container">
                                    <c:choose>
                                        <c:when test="${not empty item.imageUrl}">
                                            <img src="${item.imageUrl}" alt="${item.itemName}"
                                                onerror="this.src='${pageContext.request.contextPath}/images/food_default.png'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/food_default.png"
                                                alt="${item.itemName}">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Info -->
                            <div class="col-lg-6">
                                <div class="item-info-card">
                                    <h1 class="item-name">${item.itemName}</h1>
                                    <c:if test="${not empty item.sku}">
                                        <p class="item-sku"><i class="fas fa-barcode"></i> SKU: ${item.sku}</p>
                                    </c:if>

                                    <div class="item-price">
                                        <fmt:formatNumber value="${item.price}" pattern="#,###" /> VND
                                    </div>

                                    <c:if test="${not empty item.description}">
                                        <div class="item-description">
                                            <h6 class="fw-bold mb-2"><i class="fas fa-info-circle text-muted"></i> Mô tả
                                            </h6>
                                            ${item.description}
                                        </div>
                                    </c:if>

                                    <ul class="item-meta">
                                        <c:if test="${not empty restaurant}">
                                            <li>
                                                <i class="fas fa-store"></i>
                                                <span class="meta-label">Nhà hàng:</span>
                                                <span class="meta-value">
                                                    <a href="menu?restaurantId=${restaurant.restaurantId}"
                                                        class="text-decoration-none" style="color: var(--theme-color);">
                                                        ${restaurant.name}
                                                    </a>
                                                </span>
                                            </li>
                                        </c:if>
                                        <c:if test="${not empty category}">
                                            <li>
                                                <i class="fas fa-th-list"></i>
                                                <span class="meta-label">Danh mục:</span>
                                                <span class="meta-value">${category.categoryName}</span>
                                            </li>
                                        </c:if>
                                        <li>
                                            <i class="fas fa-check-circle"></i>
                                            <span class="meta-label">Trạng thái:</span>
                                            <span class="meta-value">
                                                <c:choose>
                                                    <c:when test="${item.isAvailable}">
                                                        <span class="badge-available"><i class="fas fa-check"></i> Còn
                                                            hàng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-unavailable"><i class="fas fa-times"></i> Hết
                                                            hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </li>
                                        <c:if test="${not empty item.averageRating}">
                                            <li>
                                                <i class="fas fa-star"></i>
                                                <span class="meta-label">Đánh giá:</span>
                                                <span class="meta-value">
                                                    <span class="rating-stars">
                                                        <c:forEach begin="1" end="5" var="star">
                                                            <c:choose>
                                                                <c:when test="${star <= item.averageRating}">
                                                                    <i class="fas fa-star"></i>
                                                                </c:when>
                                                                <c:when test="${star - 0.5 <= item.averageRating}">
                                                                    <i class="fas fa-star-half-alt"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="far fa-star empty"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </span>
                                                    <span class="ms-1 text-muted">(
                                                        <fmt:formatNumber value="${item.averageRating}" pattern="#.#" />
                                                        )
                                                    </span>
                                                </span>
                                            </li>
                                        </c:if>
                                    </ul>

                                    <div class="d-flex gap-3 flex-wrap">
                                        <c:if test="${item.isAvailable}">
                                            <button class="btn btn-add-cart" id="addToCartBtn"
                                                data-item-id="${item.itemID}">
                                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                            </button>
                                        </c:if>
                                        <a href="menu?restaurantId=${item.restaurantID}" class="btn btn-back-menu">
                                            <i class="fas fa-arrow-left"></i> Quay lại menu
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <jsp:include page="includes/footer.jsp" />

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const addBtn = document.getElementById('addToCartBtn');
                    if (addBtn) {
                        addBtn.addEventListener('click', function () {
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    const itemId = this.getAttribute('data-item-id');
                                    const restaurantId = ${item.restaurantID};

                                    const form = document.createElement('form');
                                    form.method = 'POST';
                                    form.action = 'cart';

                                    const actionInput = document.createElement('input');
                                    actionInput.type = 'hidden';
                                    actionInput.name = 'action';
                                    actionInput.value = 'add';
                                    form.appendChild(actionInput);

                                    const itemIdInput = document.createElement('input');
                                    itemIdInput.type = 'hidden';
                                    itemIdInput.name = 'itemId';
                                    itemIdInput.value = itemId;
                                    form.appendChild(itemIdInput);

                                    const restaurantIdInput = document.createElement('input');
                                    restaurantIdInput.type = 'hidden';
                                    restaurantIdInput.name = 'restaurantId';
                                    restaurantIdInput.value = restaurantId;
                                    form.appendChild(restaurantIdInput);

                                    document.body.appendChild(form);
                                    form.submit();
                                </c:when>
                                <c:otherwise>
                                    alert('Vui lòng đăng nhập để thêm món vào giỏ hàng!');
                                    window.location.href = 'login';
                                </c:otherwise>
                            </c:choose>
                        });
                    }
                </script>
            </body>

            </html>