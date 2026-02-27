<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${restaurant.name} - Menu</title>
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

                    .restaurant-header {
                        background: linear-gradient(135deg, var(--theme-color) 0%, #2c3e50 100%);
                        color: white;
                        padding: 2rem 0;
                        margin-bottom: 2rem;
                    }

                    .restaurant-logo {
                        width: 100px;
                        height: 100px;
                        object-fit: cover;
                        border-radius: 50%;
                        border: 4px solid white;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    }

                    .restaurant-info h1 {
                        font-weight: bold;
                        margin-bottom: 0.5rem;
                    }

                    .badge-status {
                        padding: 0.5rem 1rem;
                        font-size: 0.9rem;
                    }

                    .category-section {
                        margin-bottom: 3rem;
                    }

                    .category-title {
                        color: var(--theme-color);
                        font-weight: bold;
                        font-size: 1.8rem;
                        margin-bottom: 1.5rem;
                        padding-bottom: 0.5rem;
                        border-bottom: 3px solid var(--theme-color);
                    }

                    .menu-item-card {
                        border: none;
                        border-radius: 15px;
                        overflow: hidden;
                        transition: transform 0.3s, box-shadow 0.3s;
                        height: 100%;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .menu-item-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
                    }

                    .menu-item-image {
                        width: 100%;
                        height: 200px;
                        object-fit: cover;
                    }

                    .menu-item-body {
                        padding: 1.25rem;
                    }

                    .menu-item-name {
                        font-weight: bold;
                        font-size: 1.2rem;
                        color: #333;
                        margin-bottom: 0.5rem;
                    }

                    .menu-item-description {
                        color: #666;
                        font-size: 0.9rem;
                        margin-bottom: 1rem;
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }

                    .menu-item-price {
                        color: var(--theme-color);
                        font-weight: bold;
                        font-size: 1.3rem;
                    }

                    .add-to-cart-btn {
                        background-color: var(--theme-color);
                        border: none;
                        padding: 0.5rem 1.5rem;
                        border-radius: 25px;
                        transition: all 0.3s;
                    }

                    .add-to-cart-btn:hover {
                        background-color: #1e7e34;
                        transform: scale(1.05);
                    }

                    .no-items-message {
                        text-align: center;
                        padding: 3rem;
                        color: #666;
                        font-size: 1.1rem;
                    }

                    .back-btn {
                        background-color: white;
                        color: var(--theme-color);
                        border: 2px solid white;
                    }

                    .back-btn:hover {
                        background-color: rgba(255, 255, 255, 0.9);
                    }

                    .filter-bar {
                        background: white;
                        padding: 1rem 1.5rem;
                        border-radius: 15px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        margin-bottom: 2rem;
                    }

                    .filter-bar h5 {
                        color: var(--theme-color);
                        margin-bottom: 1rem;
                        font-weight: 600;
                    }

                    .filter-group {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        align-items: center;
                    }

                    .filter-item {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .filter-item label {
                        font-weight: 500;
                        color: #555;
                        white-space: nowrap;
                    }

                    .filter-item select,
                    .filter-item input {
                        padding: 0.5rem 1rem;
                        border: 2px solid #e0e0e0;
                        border-radius: 25px;
                        outline: none;
                        transition: border-color 0.3s;
                    }

                    .filter-item select:focus,
                    .filter-item input:focus {
                        border-color: var(--theme-color);
                    }

                    .filter-reset-btn {
                        background: #f0f0f0;
                        border: none;
                        padding: 0.5rem 1rem;
                        border-radius: 25px;
                        cursor: pointer;
                        transition: background 0.3s;
                    }

                    .filter-reset-btn:hover {
                        background: #e0e0e0;
                    }

                    .menu-item-card.hidden {
                        display: none !important;
                    }

                    .no-results {
                        text-align: center;
                        padding: 2rem;
                        color: #888;
                        display: none;
                    }

                    .no-results.show {
                        display: block;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <!-- Toast Messages -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3"
                        style="z-index: 9999;" role="alert">
                        ${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3"
                        style="z-index: 9999;" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <!-- Restaurant Header -->
                <div class="restaurant-header">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-auto">
                                <c:choose>
                                    <c:when test="${not empty restaurant.logoUrl}">
                                        <img src="${restaurant.logoUrl}" alt="${restaurant.name}"
                                            class="restaurant-logo">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/100?text=Logo" alt="${restaurant.name}"
                                            class="restaurant-logo">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col">
                                <div class="restaurant-info">
                                    <h1>${restaurant.name}</h1>
                                    <p class="mb-2">
                                        <i class="fas fa-map-marker-alt"></i> ${restaurant.address}
                                    </p>
                                    <div>
                                        <c:choose>
                                            <c:when test="${restaurant.isOpen}">
                                                <span class="badge bg-success badge-status">
                                                    <i class="fas fa-door-open"></i> Đang mở cửa
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger badge-status">
                                                    <i class="fas fa-door-closed"></i> Đã đóng cửa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="badge bg-light text-dark badge-status ms-2">
                                            <i class="fas fa-shipping-fast"></i> Phí giao hàng:
                                            <fmt:formatNumber value="${restaurant.deliveryFee}" pattern="#,###" /> VND
                                        </span>
                                        <c:if test="${not empty avgRating}">
                                            <span class="badge bg-warning text-dark badge-status ms-2">
                                                <i class="fas fa-star"></i>
                                                <fmt:formatNumber value="${avgRating}" pattern="#.#" />/5
                                                <span style="font-weight:normal">(${reviewCount} đánh giá)</span>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="col-auto">
                                <a href="home" class="btn back-btn">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filter Bar -->
                <div class="container">
                    <div class="filter-bar">
                        <h5><i class="fas fa-filter"></i> Lọc món ăn</h5>
                        <div class="filter-group">
                            <div class="filter-item">
                                <label for="priceFilter"><i class="fas fa-tag"></i> Giá:</label>
                                <select id="priceFilter" onchange="applyFilters()">
                                    <option value="all">Tất cả</option>
                                    <option value="0-30000">Dưới 30,000 VND</option>
                                    <option value="30000-50000">30,000 - 50,000 VND</option>
                                    <option value="50000-100000">50,000 - 100,000 VND</option>
                                    <option value="100000-999999999">Trên 100,000 VND</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label for="sortPrice"><i class="fas fa-sort"></i> Sắp xếp:</label>
                                <select id="sortPrice" onchange="applyFilters()">
                                    <option value="default">Mặc định</option>
                                    <option value="price-asc">Giá thấp → cao</option>
                                    <option value="price-desc">Giá cao → thấp</option>
                                    <option value="name-asc">Tên A → Z</option>
                                </select>
                            </div>
                            <button class="filter-reset-btn" onclick="resetFilters()">
                                <i class="fas fa-redo"></i> Đặt lại
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Menu Content -->
                <div class="container mb-5">
                    <div id="noResults" class="no-results">
                        <i class="fas fa-search fa-2x mb-2"></i>
                        <p>Không tìm thấy món ăn phù hợp với bộ lọc.</p>
                    </div>

                    <c:if test="${empty categories}">
                        <div class="no-items-message">
                            <i class="fas fa-utensils fa-3x mb-3"></i>
                            <h3>Chưa có menu</h3>
                            <p>Nhà hàng này chưa cập nhật menu. Vui lòng quay lại sau!</p>
                        </div>
                    </c:if>

                    <c:forEach var="category" items="${categories}">
                        <div class="category-section" id="category-${category.categoryID}">
                            <h2 class="category-title">
                                <i class="fas fa-utensils"></i> ${category.categoryName}
                            </h2>

                            <div class="row g-4">
                                <c:set var="categoryItems" value="${itemsByCategory[category.categoryID]}" />
                                <c:if test="${empty categoryItems}">
                                    <div class="col-12">
                                        <p class="text-muted">Chưa có món ăn trong danh mục này.</p>
                                    </div>
                                </c:if>

                                <c:forEach var="item" items="${categoryItems}">
                                    <div class="col-md-6 col-lg-4 menu-item-wrapper" data-price="${item.price}"
                                        data-name="${item.itemName}">
                                        <div class="card menu-item-card">
                                            <a href="menu-item-detail?itemId=${item.itemID}"
                                                class="text-decoration-none">
                                                <c:choose>
                                                    <c:when test="${not empty item.imageUrl}">
                                                        <img src="${item.imageUrl}" alt="${item.itemName}"
                                                            class="menu-item-image"
                                                            onerror="this.src='${pageContext.request.contextPath}/images/food_default.png'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/images/food_default.png"
                                                            alt="${item.itemName}" class="menu-item-image">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="menu-item-body">
                                                    <h5 class="menu-item-name">${item.itemName}</h5>
                                                    <c:if test="${not empty item.description}">
                                                        <p class="menu-item-description">${item.description}</p>
                                                    </c:if>
                                                </div>
                                            </a>
                                            <div class="menu-item-body pt-0">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="menu-item-price">
                                                        <fmt:formatNumber value="${item.price}" pattern="#,###" /> VND
                                                    </span>
                                                    <button class="btn btn-success add-to-cart-btn"
                                                        data-item-id="${item.itemID}">
                                                        <i class="fas fa-cart-plus"></i> Thêm
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Reviews Section -->
                <div class="container mb-5">
                    <div
                        style="background: white; border-radius: 15px; padding: 2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                        <h2 style="color: #28a745; font-weight: bold; margin-bottom: 1.5rem;">
                            <i class="fas fa-comments"></i> Đánh giá từ khách hàng
                            <c:if test="${not empty avgRating}">
                                <span style="font-size: 1rem; color: #ffc107; margin-left: 1rem;">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= avgRating}"><i class="fas fa-star"></i></c:when>
                                            <c:when test="${star - 0.5 <= avgRating}"><i
                                                    class="fas fa-star-half-alt"></i></c:when>
                                            <c:otherwise><i class="far fa-star" style="color: #ddd;"></i></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <span style="color: #666; font-weight: normal;">(
                                        <fmt:formatNumber value="${avgRating}" pattern="#.#" />/5 - ${reviewCount} đánh
                                        giá)
                                    </span>
                                </span>
                            </c:if>
                        </h2>
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <div style="text-align: center; padding: 2rem; color: #888;">
                                    <i class="far fa-comment-dots fa-3x" style="margin-bottom: 1rem;"></i>
                                    <p>Chưa có đánh giá nào cho nhà hàng này.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div>
                                    <c:forEach var="review" items="${reviews}">
                                        <div style="border-bottom: 1px solid #f0f0f0; padding: 1.25rem 0;">
                                            <div
                                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                                <div>
                                                    <strong style="font-size: 1.05rem; color: #333;">
                                                        <i class="fas fa-user-circle" style="color: #28a745;"></i>
                                                        ${reviewerNames[review.customerID]}
                                                    </strong>
                                                    <span style="margin-left: 0.75rem; color: #ffc107;">
                                                        <c:forEach begin="1" end="5" var="s">
                                                            <c:choose>
                                                                <c:when test="${s <= review.rating}"><i
                                                                        class="fas fa-star"></i></c:when>
                                                                <c:otherwise><i class="far fa-star"
                                                                        style="color: #ddd;"></i></c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </span>
                                                </div>
                                                <span style="color: #999; font-size: 0.85rem;">
                                                    <i class="far fa-clock"></i>
                                                    <fmt:formatDate value="${review.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </div>
                                            <c:if test="${not empty review.comment}">
                                                <p style="color: #555; margin: 0.5rem 0 0 0; line-height: 1.6;">
                                                    ${review.comment}</p>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <jsp:include page="includes/footer.jsp" />

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
                        btn.addEventListener('click', function () {
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    const itemId = this.getAttribute('data-item-id');
                                    const restaurantId = ${restaurant.restaurantId};

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
                    });

                    function applyFilters() {
                        const priceFilter = document.getElementById('priceFilter').value;
                        const sortOption = document.getElementById('sortPrice').value;
                        const items = document.querySelectorAll('.menu-item-wrapper');
                        let visibleCount = 0;

                        let itemsArray = Array.from(items);

                        if (sortOption !== 'default') {
                            itemsArray.sort((a, b) => {
                                if (sortOption === 'price-asc') {
                                    return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                                } else if (sortOption === 'price-desc') {
                                    return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                                } else if (sortOption === 'name-asc') {
                                    return a.dataset.name.localeCompare(b.dataset.name, 'vi');
                                }
                                return 0;
                            });

                            itemsArray.forEach(item => {
                                item.parentNode.appendChild(item);
                            });
                        }

                        items.forEach(item => {
                            const price = parseFloat(item.dataset.price);
                            let show = true;

                            if (priceFilter !== 'all') {
                                const [min, max] = priceFilter.split('-').map(Number);
                                if (price < min || price > max) {
                                    show = false;
                                }
                            }

                            if (show) {
                                item.classList.remove('hidden');
                                item.style.display = '';
                                visibleCount++;
                            } else {
                                item.classList.add('hidden');
                                item.style.display = 'none';
                            }
                        });

                        const noResults = document.getElementById('noResults');
                        if (visibleCount === 0) {
                            noResults.classList.add('show');
                        } else {
                            noResults.classList.remove('show');
                        }

                        document.querySelectorAll('.category-section').forEach(section => {
                            const visibleItems = section.querySelectorAll('.menu-item-wrapper:not(.hidden)');
                            if (visibleItems.length === 0) {
                                section.style.display = 'none';
                            } else {
                                section.style.display = '';
                            }
                        });
                    }

                    function resetFilters() {
                        document.getElementById('priceFilter').value = 'all';
                        document.getElementById('sortPrice').value = 'default';
                        applyFilters();
                    }
                </script>
            </body>

            </html>