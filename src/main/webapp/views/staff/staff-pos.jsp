<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gọi món – Bàn ${table.tableNumber}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f2f5;
            -webkit-font-smoothing: antialiased;
            color: #0f172a;
        }

        /* ── Header ─────────────────────────────── */
        .header {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 0 2rem;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 200;
            box-shadow: 0 2px 16px rgba(0,0,0,0.25);
        }
        .header-left { display: flex; align-items: center; gap: 1rem; }
        .header-badge {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.75rem;
            border-radius: 999px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }
        .header-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: white;
        }
        .btn-back {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: rgba(255,255,255,0.08);
            color: #cbd5e1;
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-back:hover {
            background: rgba(255,255,255,0.16);
            color: white;
        }

        /* ── Layout ─────────────────────────────── */
        .pos-layout {
            display: grid;
            grid-template-columns: 1fr 420px;
            height: calc(100vh - 64px);
        }

        /* ── Menu Section ───────────────────────── */
        .menu-section {
            background: #f0f2f5;
            overflow-y: auto;
            padding: 1.5rem 2rem;
        }
        .menu-section::-webkit-scrollbar { width: 6px; }
        .menu-section::-webkit-scrollbar-track { background: transparent; }
        .menu-section::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

        /* Search */
        .search-wrap {
            position: relative;
            margin-bottom: 1.25rem;
        }
        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
        }
        #searchInput {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 0.9375rem;
            font-family: inherit;
            background: white;
            transition: all 0.2s;
            color: #0f172a;
        }
        #searchInput:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
        }
        #searchInput::placeholder { color: #94a3b8; }

        /* Category tabs */
        .category-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        .category-tab {
            padding: 0.5rem 1.125rem;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 999px;
            cursor: pointer;
            font-size: 0.875rem;
            font-weight: 600;
            color: #64748b;
            transition: all 0.2s;
            white-space: nowrap;
            font-family: inherit;
        }
        .category-tab:hover {
            border-color: #3b82f6;
            color: #3b82f6;
            background: #eff6ff;
        }
        .category-tab.active {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border-color: transparent;
            box-shadow: 0 3px 10px rgba(59,130,246,0.35);
        }

        /* Menu grid */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 1rem;
        }
        .menu-item {
            background: white;
            border: 2px solid #f1f5f9;
            border-radius: 16px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.25s cubic-bezier(0.4,0,0.2,1);
            position: relative;
        }
        .menu-item:hover {
            border-color: #3b82f6;
            box-shadow: 0 8px 24px rgba(59,130,246,0.15);
            transform: translateY(-3px);
        }
        .item-image {
            width: 100%;
            height: 130px;
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            border-bottom: 1px solid #f1f5f9;
        }
        .item-content { padding: 0.875rem; }
        .item-name {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-size: 0.9375rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .item-price {
            color: #059669;
            font-weight: 700;
            font-size: 1rem;
        }
        .item-add-btn {
            position: absolute;
            bottom: 0.75rem;
            right: 0.75rem;
            width: 28px;
            height: 28px;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.125rem;
            font-weight: 700;
            opacity: 0;
            transform: scale(0.8);
            transition: all 0.2s;
            line-height: 1;
        }
        .menu-item:hover .item-add-btn {
            opacity: 1;
            transform: scale(1);
        }

        /* ── Cart Section ───────────────────────── */
        .cart-section {
            background: white;
            border-left: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            box-shadow: -4px 0 20px rgba(0,0,0,0.05);
        }
        .cart-header {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, #0f172a, #1e293b);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .cart-title {
            font-size: 1rem;
            font-weight: 700;
            color: white;
            display: flex;
            align-items: center;
            gap: 0.625rem;
        }
        .cart-count {
            background: #3b82f6;
            color: white;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.2rem 0.55rem;
            border-radius: 999px;
            min-width: 22px;
            text-align: center;
        }
        .cart-table-badge {
            font-size: 0.75rem;
            color: #94a3b8;
            font-weight: 500;
        }
        .cart-items {
            flex: 1;
            overflow-y: auto;
            padding: 1rem 1.25rem;
            background: #fafafa;
        }
        .cart-items::-webkit-scrollbar { width: 4px; }
        .cart-items::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 2px; }

        .empty-cart {
            text-align: center;
            padding: 3.5rem 1rem;
            color: #94a3b8;
            font-size: 0.9375rem;
        }
        .empty-cart-icon { font-size: 3rem; margin-bottom: 0.75rem; display: block; opacity: 0.4; }

        .cart-item {
            background: white;
            border: 1.5px solid #f1f5f9;
            border-radius: 12px;
            padding: 0.875rem 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.2s;
        }
        .cart-item:hover { border-color: #dbeafe; box-shadow: 0 2px 8px rgba(59,130,246,0.08); }
        .cart-item-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.625rem;
        }
        .cart-item-name {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.9rem;
            line-height: 1.4;
            flex: 1;
            margin-right: 0.5rem;
        }
        .cart-item-note {
            font-size: 0.75rem;
            color: #94a3b8;
            font-style: italic;
            margin-bottom: 0.5rem;
        }
        .btn-remove {
            background: #fff5f5;
            border: none;
            color: #ef4444;
            cursor: pointer;
            width: 22px;
            height: 22px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            transition: all 0.15s;
            flex-shrink: 0;
        }
        .btn-remove:hover { background: #fee2e2; }
        .cart-item-controls {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .qty-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.25rem 0.5rem;
        }
        .btn-qty {
            width: 28px;
            height: 28px;
            border: none;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s;
            font-family: inherit;
        }
        .btn-qty:hover { background: #dbeafe; }
        .btn-qty:active { transform: scale(0.92); }
        .qty-value {
            min-width: 28px;
            text-align: center;
            font-weight: 700;
            color: #0f172a;
            font-size: 0.9375rem;
        }
        .item-total {
            color: #059669;
            font-weight: 700;
            font-size: 0.9375rem;
        }

        /* Cart Footer */
        .cart-footer {
            border-top: 2px solid #f1f5f9;
            padding: 1.25rem 1.5rem;
            background: white;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .total-label { font-size: 0.875rem; color: #64748b; font-weight: 500; }
        .total-amount {
            font-size: 1.5rem;
            font-weight: 800;
            color: #059669;
            letter-spacing: -0.02em;
        }
        .btn-confirm {
            width: 100%;
            padding: 0.9375rem;
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            font-family: inherit;
            letter-spacing: 0.01em;
            box-shadow: 0 4px 14px rgba(5,150,105,0.35);
        }
        .btn-confirm:hover:not(:disabled) {
            background: linear-gradient(135deg, #047857, #065f46);
            box-shadow: 0 6px 18px rgba(5,150,105,0.45);
            transform: translateY(-1px);
        }
        .btn-confirm:active:not(:disabled) { transform: scale(0.98); }
        .btn-confirm:disabled {
            background: linear-gradient(135deg, #cbd5e1, #94a3b8);
            box-shadow: none;
            cursor: not-allowed;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            inset: 0;
            background: rgba(15,23,42,0.6);
            backdrop-filter: blur(4px);
        }
        .modal.show { display: flex; align-items: center; justify-content: center; }
        .modal-content {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 420px;
            padding: 2rem;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: popIn 0.25s cubic-bezier(0.34,1.56,0.64,1);
        }
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.85); }
            to   { opacity: 1; transform: scale(1); }
        }
        .modal-item-emoji {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            margin-bottom: 1rem;
        }
        .modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 0.375rem;
        }
        .modal-price {
            color: #059669;
            font-weight: 700;
            font-size: 1.125rem;
            margin-bottom: 1.5rem;
        }
        .form-group { margin-bottom: 1.125rem; }
        .form-label {
            display: block;
            font-size: 0.8125rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .modal-qty-control {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.5rem 0.75rem;
            justify-content: center;
        }
        .modal-btn-qty {
            width: 38px;
            height: 38px;
            border: none;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1.25rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s;
            font-family: inherit;
        }
        .modal-btn-qty:hover { background: linear-gradient(135deg, #2563eb, #1d4ed8); }
        .modal-btn-qty:active { transform: scale(0.92); }
        .modal-qty-value {
            min-width: 40px;
            text-align: center;
            font-weight: 800;
            color: #0f172a;
            font-size: 1.25rem;
        }
        .form-input {
            width: 100%;
            padding: 0.7rem 0.9rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            transition: all 0.2s;
            color: #0f172a;
        }
        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
        }
        .modal-actions { display: flex; gap: 0.75rem; margin-top: 1.5rem; }
        .btn-modal {
            flex: 1;
            padding: 0.8125rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            font-size: 0.9375rem;
            transition: all 0.2s;
            font-family: inherit;
        }
        .btn-cancel {
            background: #f1f5f9;
            color: #64748b;
            border: 2px solid #e2e8f0;
        }
        .btn-cancel:hover { background: #e2e8f0; }
        .btn-add {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            box-shadow: 0 4px 12px rgba(59,130,246,0.35);
        }
        .btn-add:hover { background: linear-gradient(135deg, #2563eb, #1d4ed8); }

        /* Toast */
        .toast {
            position: fixed;
            top: 80px;
            right: 1.5rem;
            background: white;
            border-radius: 14px;
            padding: 1rem 1.25rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 0.875rem;
            z-index: 9999;
            animation: slideInRight 0.3s ease-out;
            min-width: 280px;
            border-left: 4px solid;
        }
        .toast.success { border-left-color: #10b981; }
        .toast.error   { border-left-color: #ef4444; }
        .toast-icon { font-size: 1.25rem; }
        .toast-text { font-size: 0.875rem; font-weight: 600; color: #0f172a; }
        .toast.hide { animation: slideOutRight 0.3s ease-out forwards; }
        @keyframes slideInRight {
            from { transform: translateX(120%); opacity: 0; }
            to   { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideOutRight {
            from { transform: translateX(0); opacity: 1; }
            to   { transform: translateX(120%); opacity: 0; }
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .pos-layout { grid-template-columns: 1fr; height: auto; }
            .cart-section { border-left: none; border-top: 2px solid #f1f5f9; min-height: 400px; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <span class="header-badge">POS</span>
            <span class="header-title">Gọi món &mdash; Bàn ${table.tableNumber}</span>
        </div>
        <a href="${pageContext.request.contextPath}/staff/home" class="btn-back">
            &#8592; Quay lại
        </a>
    </div>

    <div class="pos-layout">
        <!-- ══ Menu Section ══ -->
        <div class="menu-section">
            <!-- Search -->
            <div class="search-wrap">
                <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                </svg>
                <input type="text" id="searchInput" placeholder="Tìm kiếm món ăn..." onkeyup="filterItems()">
            </div>

            <!-- Category Tabs -->
            <div class="category-tabs" id="categoryTabs">
                <div class="category-tab active" data-category="all">🍽️ Tất cả</div>
                <c:forEach items="${categories}" var="category">
                    <div class="category-tab" data-category="${category.categoryID}">
                        ${category.categoryName}
                    </div>
                </c:forEach>
            </div>

            <!-- Menu Grid -->
            <div class="menu-grid" id="all-items">
                <c:forEach items="${categories}" var="category">
                    <c:forEach items="${itemsByCategory[category.categoryID]}" var="item">
                        <div class="menu-item"
                             data-item-id="${item.itemID}"
                             data-item-name="${fn:escapeXml(item.itemName)}"
                             data-item-price="${item.price}"
                             data-category-id="${category.categoryID}">
                            <div class="item-image">🍽️</div>
                            <div class="item-content">
                                <div class="item-name">${item.itemName}</div>
                                <div class="item-price">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ
                                </div>
                            </div>
                            <div class="item-add-btn">+</div>
                        </div>
                    </c:forEach>
                </c:forEach>
            </div>
        </div>

        <!-- ══ Cart Section ══ -->
        <div class="cart-section">
            <div class="cart-header">
                <div class="cart-title">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 0 1-8 0"/>
                    </svg>
                    Đơn hàng
                    <span class="cart-count" id="cartCount">0</span>
                </div>
                <span class="cart-table-badge">Bàn ${table.tableNumber}</span>
            </div>

            <div class="cart-items" id="cartItems">
                <div class="empty-cart">
                    <span class="empty-cart-icon">🛒</span>
                    Chưa có món nào<br>
                    <span style="font-size:0.8125rem;">Chọn món từ thực đơn bên trái</span>
                </div>
            </div>

            <div class="cart-footer">
                <div class="total-row">
                    <span class="total-label">Tổng cộng</span>
                    <span class="total-amount" id="totalAmount">0 đ</span>
                </div>
                <button class="btn-confirm" id="confirmBtn" disabled onclick="confirmOrder()">
                    ✓ &nbsp;Xác nhận đơn hàng
                </button>
            </div>
        </div>
    </div>

    <!-- Add Item Modal -->
    <div class="modal" id="addItemModal">
        <div class="modal-content">
            <div class="modal-item-emoji">🍽️</div>
            <div class="modal-title" id="modalItemName"></div>
            <div class="modal-price" id="modalItemPrice"></div>

            <div class="form-group">
                <label class="form-label">Số lượng</label>
                <div class="modal-qty-control">
                    <button class="modal-btn-qty" onclick="changeModalQty(-1)">−</button>
                    <span class="modal-qty-value" id="modalQty">1</span>
                    <button class="modal-btn-qty" onclick="changeModalQty(1)">+</button>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú (tuỳ chọn)</label>
                <input type="text" class="form-input" id="modalNote" placeholder="VD: Không hành, ít cay...">
            </div>

            <div class="modal-actions">
                <button class="btn-modal btn-cancel" onclick="closeModal()">Huỷ</button>
                <button class="btn-modal btn-add" onclick="addToCart()">+ Thêm vào đơn</button>
            </div>
        </div>
    </div>

    <script>
        const ctx = '${pageContext.request.contextPath}';
        const tableId = parseInt('${table.tableID}');
        let cart = [];
        let currentItem = null;
        let currentCategory = 'all';

        // Init
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.menu-item').forEach(item => {
                item.addEventListener('click', function() {
                    showAddItemModal(
                        this.dataset.itemId,
                        this.dataset.itemName,
                        parseFloat(this.dataset.itemPrice)
                    );
                });
            });
            document.querySelectorAll('.category-tab').forEach(tab => {
                tab.addEventListener('click', function() {
                    showCategory(this.dataset.category);
                });
            });
        });

        function showCategory(categoryId) {
            currentCategory = categoryId;
            document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
            document.querySelector('.category-tab[data-category="' + categoryId + '"]').classList.add('active');
            document.getElementById('searchInput').value = '';
            filterItems();
        }

        function filterItems() {
            const q = document.getElementById('searchInput').value.toLowerCase().trim();
            document.querySelectorAll('.menu-item').forEach(item => {
                const name = item.dataset.itemName.toLowerCase();
                const cat  = item.dataset.categoryId;
                const ok   = (q === '' || name.includes(q)) &&
                             (currentCategory === 'all' || cat === currentCategory);
                item.style.display = ok ? '' : 'none';
            });
        }

        function showAddItemModal(itemId, itemName, itemPrice) {
            currentItem = { itemId, itemName, itemPrice };
            document.getElementById('modalItemName').textContent = itemName;
            document.getElementById('modalItemPrice').textContent = formatCurrency(itemPrice) + ' đ';
            document.getElementById('modalQty').textContent = '1';
            document.getElementById('modalNote').value = '';
            document.getElementById('addItemModal').classList.add('show');
        }

        function closeModal() {
            document.getElementById('addItemModal').classList.remove('show');
            currentItem = null;
        }

        function changeModalQty(delta) {
            const el = document.getElementById('modalQty');
            el.textContent = Math.max(1, parseInt(el.textContent) + delta);
        }

        function addToCart() {
            const qty  = parseInt(document.getElementById('modalQty').textContent);
            const note = document.getElementById('modalNote').value.trim();
            const idx  = cart.findIndex(i => i.itemId === currentItem.itemId && i.note === note);
            if (idx >= 0) {
                cart[idx].quantity += qty;
            } else {
                cart.push({ ...currentItem, quantity: qty, unitPrice: currentItem.itemPrice, note });
            }
            renderCart();
            closeModal();
            showToast('success', 'Đã thêm vào đơn: ' + currentItem.itemName);
        }

        function removeFromCart(index) {
            cart.splice(index, 1);
            renderCart();
        }

        function updateQuantity(index, delta) {
            cart[index].quantity = Math.max(1, cart[index].quantity + delta);
            renderCart();
        }

        function renderCart() {
            const container = document.getElementById('cartItems');
            const countEl   = document.getElementById('cartCount');
            if (cart.length === 0) {
                container.innerHTML = '<div class="empty-cart"><span class="empty-cart-icon">🛒</span>Chưa có món nào<br><span style="font-size:0.8125rem;">Chọn món từ thực đơn bên trái</span></div>';
                document.getElementById('confirmBtn').disabled = true;
                document.getElementById('totalAmount').textContent = '0 đ';
                countEl.textContent = '0';
                return;
            }
            let html = '', total = 0;
            cart.forEach((item, i) => {
                const lineTotal = item.quantity * item.unitPrice;
                total += lineTotal;
                html += `
                    <div class="cart-item">
                        <div class="cart-item-header">
                            <div class="cart-item-name">\${item.itemName}</div>
                            <button class="btn-remove" onclick="removeFromCart(\${i})" title="Xoá">✕</button>
                        </div>
                        \${item.note ? '<div class="cart-item-note">' + item.note + '</div>' : ''}
                        <div class="cart-item-controls">
                            <div class="qty-control">
                                <button class="btn-qty" onclick="updateQuantity(\${i}, -1)">−</button>
                                <span class="qty-value">\${item.quantity}</span>
                                <button class="btn-qty" onclick="updateQuantity(\${i}, 1)">+</button>
                            </div>
                            <div class="item-total">\${formatCurrency(lineTotal)} đ</div>
                        </div>
                    </div>`;
            });
            container.innerHTML = html;
            document.getElementById('totalAmount').textContent = formatCurrency(total) + ' đ';
            document.getElementById('confirmBtn').disabled = false;
            countEl.textContent = cart.reduce((s, i) => s + i.quantity, 0);
        }

        function confirmOrder() {
            if (cart.length === 0) return;
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = ctx + '/staff/order/create';
            const fields = { tableId, orderType: 'DineIn', paymentMethod: 'Cash', cartItems: JSON.stringify(cart) };
            for (const [k, v] of Object.entries(fields)) {
                const inp = document.createElement('input');
                inp.type = 'hidden'; inp.name = k; inp.value = v;
                form.appendChild(inp);
            }
            document.body.appendChild(form);
            form.submit();
        }

        function formatCurrency(n) { return new Intl.NumberFormat('vi-VN').format(n); }

        function showToast(type, msg) {
            const t = document.createElement('div');
            t.className = 'toast ' + type;
            t.innerHTML = '<span class="toast-icon">' + (type === 'success' ? '✓' : '✕') + '</span><span class="toast-text">' + msg + '</span>';
            document.body.appendChild(t);
            setTimeout(() => { t.classList.add('hide'); setTimeout(() => t.remove(), 300); }, 2500);
        }

        window.onclick = e => { if (e.target.id === 'addItemModal') closeModal(); };
    </script>
</body>
</html>
