<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bàn ${table.tableNumber} – Quản lý đơn hàng</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, sans-serif;
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
        .header-left { display: flex; align-items: center; gap: 0.875rem; }
        .table-badge-header {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.875rem;
            border-radius: 999px;
            letter-spacing: 0.04em;
        }
        .header-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: white;
        }
        .header-subtitle { font-size: 0.8125rem; color: #94a3b8; font-weight: 400; }
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
        .btn-back:hover { background: rgba(255,255,255,0.16); color: white; }

        /* ── Container ──────────────────────────── */
        .container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 2rem;
        }
        .grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 1.5rem;
            align-items: start;
        }

        /* ── Card ───────────────────────────────── */
        .card {
            background: white;
            border-radius: 20px;
            border: 1.5px solid #f1f5f9;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            overflow: hidden;
        }
        .card-header {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border-bottom: 1.5px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-title {
            font-size: 1rem;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 0.625rem;
        }
        .card-title-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
        }
        .icon-orange { background: #fff7ed; }
        .icon-green  { background: #f0fdf4; }

        /* ── Order Items ─────────────────────────── */
        .order-list { padding: 0.75rem 0; }
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.875rem 1.5rem;
            border-bottom: 1px solid #f8fafc;
            transition: background 0.15s;
        }
        .order-item:last-child { border-bottom: none; }
        .order-item:hover { background: #f8fafc; }
        .item-info { flex: 1; }
        .item-name {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.9375rem;
            margin-bottom: 0.25rem;
        }
        .item-note {
            font-size: 0.8rem;
            color: #94a3b8;
            font-style: italic;
        }
        .item-right { text-align: right; }
        .item-quantity {
            font-weight: 700;
            color: #3b82f6;
            font-size: 0.875rem;
            background: #eff6ff;
            padding: 0.2rem 0.5rem;
            border-radius: 6px;
            margin-bottom: 0.25rem;
            display: inline-block;
        }
        .item-amount {
            font-weight: 600;
            color: #64748b;
            font-size: 0.875rem;
        }
        .empty-state {
            text-align: center;
            padding: 3rem 1.5rem;
            color: #94a3b8;
        }
        .empty-state-icon { font-size: 2.5rem; display: block; margin-bottom: 0.75rem; opacity: 0.4; }

        /* Add item button */
        .btn-add-item {
            margin: 1rem 1.5rem;
            width: calc(100% - 3rem);
            padding: 0.8125rem;
            background: white;
            color: #3b82f6;
            border: 2px dashed #93c5fd;
            border-radius: 12px;
            font-size: 0.9375rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-family: inherit;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn-add-item:hover {
            background: #eff6ff;
            border-color: #3b82f6;
            border-style: solid;
        }

        /* ── Summary Card ────────────────────────── */
        .summary-body { padding: 1.25rem 1.5rem; }
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.625rem 0;
            border-bottom: 1px solid #f8fafc;
            font-size: 0.9rem;
        }
        .summary-row:last-of-type { border-bottom: none; }
        .summary-label { color: #64748b; font-weight: 500; }
        .summary-value { color: #0f172a; font-weight: 600; }
        .summary-total {
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            border-radius: 14px;
            padding: 1.25rem;
            margin: 1rem 0;
            border: 1.5px solid #bbf7d0;
        }
        .total-label { font-size: 0.875rem; color: #059669; font-weight: 600; margin-bottom: 0.25rem; }
        .total-amount {
            font-size: 2rem;
            font-weight: 800;
            color: #059669;
            letter-spacing: -0.03em;
        }
        .btn-payment {
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
            box-shadow: 0 4px 14px rgba(5,150,105,0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn-payment:hover {
            background: linear-gradient(135deg, #047857, #065f46);
            box-shadow: 0 6px 20px rgba(5,150,105,0.45);
            transform: translateY(-1px);
        }

        /* ── Add Items Modal ─────────────────────── */
        .modal {
            display: none;
            position: fixed;
            z-index: 10000;
            inset: 0;
            background: rgba(15,23,42,0.65);
            backdrop-filter: blur(6px);
        }
        .modal.show { display: flex; align-items: center; justify-content: center; }
        .modal-content {
            background: white;
            border-radius: 24px;
            width: 90%;
            max-width: 860px;
            max-height: 88vh;
            display: flex;
            flex-direction: column;
            box-shadow: 0 25px 80px rgba(0,0,0,0.3);
            animation: popIn 0.28s cubic-bezier(0.34,1.56,0.64,1);
        }
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.88) translateY(20px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }
        .modal-header {
            padding: 1.5rem 2rem;
            border-bottom: 1.5px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }
        .modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0f172a;
        }
        .btn-close-modal {
            background: #f1f5f9;
            border: none;
            width: 36px;
            height: 36px;
            border-radius: 10px;
            color: #64748b;
            cursor: pointer;
            font-size: 1.125rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s;
        }
        .btn-close-modal:hover { background: #e2e8f0; color: #0f172a; }

        .modal-body {
            padding: 1.5rem 2rem;
            overflow-y: auto;
            flex: 1;
        }
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
        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 0.9375rem;
            font-family: inherit;
            background: #f8fafc;
            transition: all 0.2s;
            color: #0f172a;
        }
        .search-input:focus {
            outline: none;
            border-color: #059669;
            background: white;
            box-shadow: 0 0 0 3px rgba(5,150,105,0.12);
        }
        .search-input::placeholder { color: #94a3b8; }

        .category-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.25rem;
            flex-wrap: wrap;
        }
        .category-tab {
            padding: 0.45rem 1rem;
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 999px;
            cursor: pointer;
            font-size: 0.8125rem;
            font-weight: 600;
            color: #64748b;
            transition: all 0.2s;
            font-family: inherit;
        }
        .category-tab:hover { border-color: #059669; color: #059669; }
        .category-tab.active {
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            border-color: transparent;
            box-shadow: 0 3px 10px rgba(5,150,105,0.3);
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
            gap: 0.875rem;
        }
        .menu-item-card {
            background: white;
            border: 2px solid #f1f5f9;
            border-radius: 14px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.2s;
        }
        .menu-item-card:hover {
            border-color: #059669;
            box-shadow: 0 6px 20px rgba(5,150,105,0.15);
            transform: translateY(-2px);
        }
        .menu-item-image {
            width: 100%;
            height: 110px;
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.25rem;
            border-bottom: 1px solid #f1f5f9;
        }
        .menu-item-content { padding: 0.75rem; }
        .menu-item-name {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.8125rem;
            margin-bottom: 0.375rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .menu-item-price {
            color: #059669;
            font-weight: 700;
            font-size: 0.9rem;
        }

        /* Item Detail Modal */
        .item-detail-content {
            max-width: 420px;
            padding: 2rem;
            border-radius: 24px;
        }
        .item-detail-emoji {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            margin-bottom: 1rem;
        }
        .item-detail-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 0.375rem;
        }
        .item-detail-price {
            color: #059669;
            font-weight: 700;
            font-size: 1.125rem;
            margin-bottom: 1.5rem;
        }
        .form-group { margin-bottom: 1.125rem; }
        .form-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            color: #475569;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        .qty-ctrl {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.5rem 0.75rem;
            justify-content: center;
        }
        .btn-qty-d {
            width: 38px; height: 38px;
            background: linear-gradient(135deg, #059669, #047857);
            color: white; border: none; border-radius: 10px;
            cursor: pointer; font-size: 1.25rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.15s; font-family: inherit;
        }
        .btn-qty-d:hover { background: linear-gradient(135deg, #047857, #065f46); }
        .btn-qty-d:active { transform: scale(0.9); }
        .qty-val-d {
            min-width: 40px; text-align: center;
            font-weight: 800; color: #0f172a; font-size: 1.25rem;
        }
        .form-input {
            width: 100%;
            padding: 0.7rem 0.9rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.875rem;
            font-family: inherit;
            transition: all 0.2s;
            color: #0f172a;
        }
        .form-input:focus {
            outline: none;
            border-color: #059669;
            box-shadow: 0 0 0 3px rgba(5,150,105,0.12);
        }
        .modal-actions { display: flex; gap: 0.75rem; margin-top: 1.5rem; }
        .btn-modal {
            flex: 1; padding: 0.8125rem;
            border: none; border-radius: 10px;
            font-weight: 600; cursor: pointer;
            font-size: 0.9375rem; transition: all 0.2s;
            font-family: inherit;
        }
        .btn-modal-cancel { background: #f1f5f9; color: #64748b; border: 2px solid #e2e8f0; }
        .btn-modal-cancel:hover { background: #e2e8f0; }
        .btn-modal-add {
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            box-shadow: 0 4px 12px rgba(5,150,105,0.35);
        }
        .btn-modal-add:hover { background: linear-gradient(135deg, #047857, #065f46); }

        /* Payment Modal */
        .payment-methods { display: grid; gap: 0.875rem; margin-bottom: 1.25rem; }
        .payment-method {
            padding: 1.125rem 1.25rem;
            border: 2px solid #f1f5f9;
            border-radius: 14px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 1rem;
            background: white;
        }
        .payment-method-icon {
            width: 48px; height: 48px;
            background: #f8fafc; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; flex-shrink: 0;
        }
        .payment-method-name { font-weight: 700; font-size: 0.9375rem; color: #0f172a; margin-bottom: 0.2rem; }
        .payment-method-desc { font-size: 0.8rem; color: #94a3b8; }
        .payment-method:hover { border-color: #059669; background: #f0fdf4; }
        .payment-method.selected {
            border-color: #059669;
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
        }
        .payment-method.selected .payment-method-icon { background: #059669; color: white; }
        .payment-amount-display {
            text-align: center;
            background: #f0fdf4;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1.5px solid #bbf7d0;
        }
        .payment-amount-label { font-size: 0.8125rem; color: #059669; font-weight: 600; }
        .payment-amount-num { font-size: 1.75rem; font-weight: 800; color: #059669; letter-spacing: -0.02em; }

        /* QR Modal */
        .qr-content { max-width: 380px; text-align: center; padding: 2rem; }
        .qr-container {
            background: white; padding: 1.25rem; border-radius: 16px;
            border: 2px solid #f1f5f9; margin: 1.25rem 0;
        }
        .qr-container img { width: 100%; max-width: 240px; }
        .qr-instructions { font-size: 0.875rem; color: #64748b; margin-bottom: 0.75rem; line-height: 1.5; }

        /* Toast */
        .toast {
            position: fixed;
            top: 80px; right: 1.5rem;
            background: white;
            border-radius: 14px;
            padding: 1rem 1.25rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 0.875rem;
            z-index: 10001;
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

        @media (max-width: 1024px) {
            .grid { grid-template-columns: 1fr; }
            .menu-grid { grid-template-columns: repeat(auto-fill, minmax(145px, 1fr)); }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <span class="table-badge-header">● Đang có khách</span>
            <div>
                <div class="header-title">Bàn ${table.tableNumber}</div>
                <div class="header-subtitle">${table.capacity} chỗ ngồi &middot; Quản lý đơn hàng</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/staff/home" class="btn-back">&#8592; Quay lại</a>
    </div>

    <div class="container">
        <div class="grid">
            <!-- ══ Left: Ordered Items ══ -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">
                        <span class="card-title-icon icon-orange">🧾</span>
                        Món đã gọi
                    </div>
                </div>

                <c:if test="${empty orders}">
                    <div class="empty-state">
                        <span class="empty-state-icon">🍽️</span>
                        Chưa có món nào được gọi
                    </div>
                </c:if>

                <c:if test="${not empty orders}">
                    <div class="order-list">
                        <c:forEach var="order" items="${orders}">
                            <c:forEach var="item" items="${orderItemsMap[order.orderID]}">
                                <div class="order-item">
                                    <div class="item-info">
                                        <div class="item-name">${item.itemName}</div>
                                        <c:if test="${not empty item.note}">
                                            <div class="item-note">${item.note}</div>
                                        </c:if>
                                    </div>
                                    <div class="item-right">
                                        <div class="item-quantity">x${item.quantity}</div>
                                        <div class="item-amount">
                                            <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="number" groupingUsed="true"/> đ
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:forEach>
                    </div>
                </c:if>

                <button class="btn-add-item" onclick="showAddItemModal()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    Thêm món
                </button>
            </div>

            <!-- ══ Right: Summary & Payment ══ -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">
                        <span class="card-title-icon icon-green">💰</span>
                        Thanh toán
                    </div>
                </div>
                <div class="summary-body">
                    <c:set var="grandTotal" value="0" />
                    <c:forEach var="order" items="${orders}">
                        <c:set var="grandTotal" value="${grandTotal + order.finalAmount}" />
                    </c:forEach>

                    <div class="summary-total">
                        <div class="total-label">Tổng tiền</div>
                        <div class="total-amount">
                            <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/> đ
                        </div>
                    </div>

                    <c:if test="${not empty orders}">
                        <button class="btn-payment" onclick="showPaymentModal()">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
                                <line x1="1" y1="10" x2="23" y2="10"/>
                            </svg>
                            Thanh toán
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- ══ Add Items Modal ══ -->
    <div id="addItemsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">🛒 Thêm món cho Bàn ${table.tableNumber}</div>
                <button class="btn-close-modal" onclick="closeAddItemsModal()">✕</button>
            </div>
            <div class="modal-body">
                <div class="search-wrap">
                    <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                    </svg>
                    <input type="text" class="search-input" id="searchInput"
                           placeholder="Tìm kiếm món ăn..."
                           onkeyup="filterMenuItems()">
                </div>

                <div class="category-tabs" id="categoryTabs">
                    <div class="category-tab active" data-category="all">🍽️ Tất cả</div>
                    <c:forEach items="${categories}" var="category">
                        <div class="category-tab" data-category="${category.categoryID}">
                            ${category.categoryName}
                        </div>
                    </c:forEach>
                </div>

                <div class="menu-grid" id="menuGrid">
                    <c:forEach items="${categories}" var="category">
                        <c:forEach items="${categoryItemsMap[category.categoryID]}" var="item">
                            <div class="menu-item-card"
                                 data-item-id="${item.itemID}"
                                 data-item-name="${fn:escapeXml(item.itemName)}"
                                 data-item-price="${item.price}"
                                 data-category-id="${category.categoryID}"
                                 onclick="showItemDetailModal('${item.itemID}','${fn:escapeXml(item.itemName)}','${item.price}')">
                                <div class="menu-item-image">🍽️</div>
                                <div class="menu-item-content">
                                    <div class="menu-item-name">${item.itemName}</div>
                                    <div class="menu-item-price">
                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- ══ Item Detail Modal ══ -->
    <div id="itemDetailModal" class="modal">
        <div class="modal-content item-detail-content">
            <div class="item-detail-emoji">🍽️</div>
            <div class="item-detail-name" id="itemDetailName"></div>
            <div class="item-detail-price" id="itemDetailPrice"></div>

            <div class="form-group">
                <label class="form-label">Số lượng</label>
                <div class="qty-ctrl">
                    <button class="btn-qty-d" onclick="changeItemQty(-1)">−</button>
                    <span class="qty-val-d" id="itemQty">1</span>
                    <button class="btn-qty-d" onclick="changeItemQty(1)">+</button>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú (tuỳ chọn)</label>
                <input type="text" class="form-input" id="itemNote" placeholder="VD: Không hành, ít cay...">
            </div>

            <div class="modal-actions">
                <button class="btn-modal btn-modal-cancel" onclick="closeItemDetailModal()">Huỷ</button>
                <button class="btn-modal btn-modal-add" onclick="addItemToOrder()">+ Thêm vào đơn</button>
            </div>
        </div>
    </div>

    <!-- ══ Payment Modal ══ -->
    <div id="paymentModal" class="modal">
        <div class="modal-content item-detail-content">
            <div class="item-detail-name">Chọn phương thức thanh toán</div>
            <br>
            <div class="payment-amount-display">
                <div class="payment-amount-label">Tổng cần thanh toán</div>
                <div class="payment-amount-num">
                    <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/> đ
                </div>
            </div>
            <div class="payment-methods">
                <div class="payment-method" data-method="Cash">
                    <div class="payment-method-icon">💵</div>
                    <div>
                        <div class="payment-method-name">Tiền mặt</div>
                        <div class="payment-method-desc">Thanh toán trực tiếp tại bàn</div>
                    </div>
                </div>
                <div class="payment-method" data-method="VNPay">
                    <div class="payment-method-icon">📱</div>
                    <div>
                        <div class="payment-method-name">VNPay</div>
                        <div class="payment-method-desc">Quét mã QR để thanh toán</div>
                    </div>
                </div>
            </div>
            <div class="modal-actions">
                <button class="btn-modal btn-modal-cancel" onclick="closePaymentModal()">Huỷ</button>
                <button class="btn-modal btn-modal-add" onclick="processPayment()">Xác nhận</button>
            </div>
        </div>
    </div>

    <!-- ══ VNPay QR Modal ══ -->
    <div id="vnpayQRModal" class="modal">
        <div class="modal-content qr-content">
            <div class="item-detail-emoji" style="margin: 0 auto 1rem;">📱</div>
            <div class="item-detail-name">Thanh toán VNPay</div>
            <div class="payment-amount-display" style="margin-top:1rem;">
                <div class="payment-amount-label">Số tiền</div>
                <div class="payment-amount-num" id="qrPaymentAmount"></div>
            </div>
            <div class="qr-instructions">Quét mã QR bằng ứng dụng ngân hàng hoặc VNPay</div>
            <div class="qr-container" id="qrCodeContainer">
                <div style="color: #94a3b8; padding: 1rem;">Đang tạo mã QR...</div>
            </div>
            <div class="modal-actions">
                <button class="btn-modal btn-modal-cancel" style="flex:1" onclick="closeVNPayQRModal()">Đóng</button>
            </div>
        </div>
    </div>

    <script>
        const ctx = '${pageContext.request.contextPath}';
        const tableId = parseInt('${table.tableID}');
        let selectedPaymentMethod = null;
        let currentItem = null;
        let currentCategory = 'all';

        // Toast
        function showToast(type, msg) {
            const t = document.createElement('div');
            t.className = 'toast ' + type;
            t.innerHTML = '<span class="toast-icon">' + (type === 'success' ? '✓' : '✕') + '</span><span class="toast-text">' + msg + '</span>';
            document.body.appendChild(t);
            setTimeout(() => { t.classList.add('hide'); setTimeout(() => t.remove(), 300); }, 3000);
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.category-tab').forEach(tab => {
                tab.addEventListener('click', function() {
                    currentCategory = this.dataset.category;
                    document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
                    this.classList.add('active');
                    document.getElementById('searchInput').value = '';
                    filterMenuItems();
                });
            });
            document.querySelectorAll('.payment-method').forEach(m => {
                m.addEventListener('click', function() {
                    document.querySelectorAll('.payment-method').forEach(x => x.classList.remove('selected'));
                    this.classList.add('selected');
                    selectedPaymentMethod = this.dataset.method;
                });
            });
        });

        // Add Items Modal
        function showAddItemModal() { document.getElementById('addItemsModal').classList.add('show'); }
        function closeAddItemsModal() {
            document.getElementById('addItemsModal').classList.remove('show');
            document.getElementById('searchInput').value = '';
            currentCategory = 'all';
            document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
            document.querySelector('.category-tab[data-category="all"]').classList.add('active');
            filterMenuItems();
        }

        function filterMenuItems() {
            const q = document.getElementById('searchInput').value.toLowerCase().trim();
            document.querySelectorAll('.menu-item-card').forEach(card => {
                const name = card.dataset.itemName.toLowerCase();
                const cat  = card.dataset.categoryId;
                const ok   = (q === '' || name.includes(q)) && (currentCategory === 'all' || cat === currentCategory);
                card.style.display = ok ? '' : 'none';
            });
        }

        // Item Detail Modal
        function showItemDetailModal(id, name, price) {
            currentItem = { itemId: id, itemName: name, itemPrice: parseFloat(price) };
            document.getElementById('itemDetailName').textContent = name;
            document.getElementById('itemDetailPrice').textContent = formatCurrency(parseFloat(price)) + ' đ';
            document.getElementById('itemQty').textContent = '1';
            document.getElementById('itemNote').value = '';
            document.getElementById('itemDetailModal').classList.add('show');
        }
        function closeItemDetailModal() {
            document.getElementById('itemDetailModal').classList.remove('show');
            currentItem = null;
        }
        function changeItemQty(delta) {
            const el = document.getElementById('itemQty');
            el.textContent = Math.max(1, parseInt(el.textContent) + delta);
        }

        function addItemToOrder() {
            if (!currentItem) return;
            const qty  = parseInt(document.getElementById('itemQty').textContent);
            const note = document.getElementById('itemNote').value.trim();
            const body = new URLSearchParams({ tableId, itemId: currentItem.itemId, quantity: qty, note });
            fetch(ctx + '/staff/order/add-item', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString()
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    showToast('success', 'Đã thêm: ' + currentItem.itemName);
                    closeItemDetailModal();
                    closeAddItemsModal();
                    setTimeout(() => location.reload(), 1200);
                } else {
                    showToast('error', data.message || 'Không thể thêm món');
                }
            })
            .catch(() => showToast('error', 'Lỗi kết nối'));
        }

        // Payment Modal
        function showPaymentModal() {
            selectedPaymentMethod = null;
            document.querySelectorAll('.payment-method').forEach(m => m.classList.remove('selected'));
            document.getElementById('paymentModal').classList.add('show');
        }
        function closePaymentModal() { document.getElementById('paymentModal').classList.remove('show'); }

        function processPayment() {
            if (!selectedPaymentMethod) { showToast('error', 'Vui lòng chọn phương thức thanh toán'); return; }
            if (selectedPaymentMethod === 'Cash') completeCashPayment();
            else { closePaymentModal(); showVNPayQR(); }
        }

        function completeCashPayment() {
            fetch(ctx + '/staff/table/payment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'tableId=' + tableId + '&paymentMethod=Cash'
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) { showToast('success', 'Thanh toán thành công!'); setTimeout(() => location.href = ctx + '/staff/home', 100); }
                else showToast('error', data.message || 'Thanh toán thất bại');
            })
            .catch(() => showToast('error', 'Lỗi kết nối'));
        }

        function showVNPayQR() {
            const total = ${grandTotal};
            document.getElementById('qrPaymentAmount').textContent = formatCurrency(total) + ' đ';
            document.getElementById('vnpayQRModal').classList.add('show');
            const params = new URLSearchParams({ tableId, amount: total, orderInfo: 'Thanh toan ban ${table.tableNumber}' });
            fetch(ctx + '/staff/payment/vnpay?' + params.toString())
                .then(r => r.json())
                .then(data => {
                    if (data.success && data.paymentUrl) {
                        document.getElementById('qrCodeContainer').innerHTML =
                            '<img src="https://api.qrserver.com/v1/create-qr-code/?size=240x240&data=' + encodeURIComponent(data.paymentUrl) + '" alt="VNPay QR">';
                    } else { showToast('error', 'Không thể tạo mã QR'); closeVNPayQRModal(); }
                })
                .catch(() => { showToast('error', 'Lỗi tạo QR'); closeVNPayQRModal(); });
        }
        function closeVNPayQRModal() { document.getElementById('vnpayQRModal').classList.remove('show'); }

        function formatCurrency(n) { return new Intl.NumberFormat('vi-VN').format(n); }

        window.onclick = e => {
            ['addItemsModal','itemDetailModal','paymentModal','vnpayQRModal'].forEach(id => {
                const el = document.getElementById(id);
                if (e.target === el) el.classList.remove('show');
            });
        };
    </script>
</body>
</html>
