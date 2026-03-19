<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* ── Orders Table Fragment (inline styles for fragment safety) ── */
    .ot-empty {
        text-align: center;
        padding: 3.5rem 1.5rem;
        color: #94a3b8;
    }
    .ot-empty-icon { font-size: 2.5rem; display: block; margin-bottom: 0.75rem; opacity: 0.4; }
    .ot-empty-text { font-size: 0.9375rem; font-weight: 500; }

    .ot-table { width: 100%; border-collapse: collapse; }
    .ot-table thead tr {
        background: linear-gradient(135deg, #1e293b, #0f172a);
    }
    .ot-table th {
        padding: 0.875rem 1rem;
        text-align: left;
        font-size: 0.75rem;
        font-weight: 700;
        color: #94a3b8;
        text-transform: uppercase;
        letter-spacing: 0.07em;
        white-space: nowrap;
    }
    .ot-table th:last-child { text-align: center; }
    .ot-table tbody tr {
        border-bottom: 1px solid #f1f5f9;
        transition: background 0.15s;
    }
    .ot-table tbody tr:last-child { border-bottom: none; }
    .ot-table tbody tr:hover { background: #f8fafc; }
    .ot-table td {
        padding: 0.9375rem 1rem;
        font-size: 0.875rem;
        color: #0f172a;
        vertical-align: middle;
    }
    .ot-table td:last-child { text-align: center; }

    /* Order ID */
    .ot-order-id {
        font-weight: 700;
        font-size: 0.9375rem;
        color: #3b82f6;
    }

    /* Customer */
    .ot-customer {
        font-weight: 500;
        color: #0f172a;
    }

    /* Badges */
    .ot-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.35rem;
        padding: 0.3rem 0.75rem;
        border-radius: 999px;
        font-size: 0.73rem;
        font-weight: 700;
        letter-spacing: 0.03em;
        white-space: nowrap;
    }
    .ot-badge-dot {
        width: 6px; height: 6px;
        border-radius: 50%;
        display: inline-block;
        background: currentColor;
    }
    /* Order type */
    .badge-dinein    { background: #eff6ff; color: #2563eb; }
    .badge-pickup    { background: #fef3c7; color: #d97706; }
    .badge-online    { background: #f0f9ff; color: #0284c7; }
    /* Payment status */
    .badge-paid      { background: #f0fdf4; color: #15803d; }
    .badge-pending   { background: #fefce8; color: #a16207; }
    .badge-failed    { background: #fff1f2; color: #be123c; }
    .badge-default   { background: #f8fafc; color: #64748b; }

    /* Amount */
    .ot-amount {
        font-weight: 700;
        color: #059669;
        font-size: 0.9375rem;
        white-space: nowrap;
        text-align: right;
    }

    /* Date */
    .ot-date { color: #64748b; font-size: 0.8125rem; white-space: nowrap; }

    /* Action buttons */
    .ot-actions { display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap; }
    .ot-btn {
        display: inline-flex;
        align-items: center;
        gap: 0.35rem;
        padding: 0.4rem 0.875rem;
        border-radius: 8px;
        font-size: 0.8125rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.18s;
        border: 1.5px solid;
        text-decoration: none;
        font-family: inherit;
        background: white;
    }
    .ot-btn-view {
        color: #3b82f6;
        border-color: #93c5fd;
    }
    .ot-btn-view:hover {
        background: #eff6ff;
        border-color: #3b82f6;
        transform: translateY(-1px);
        box-shadow: 0 3px 8px rgba(59,130,246,0.2);
    }
    .ot-btn-print {
        color: #64748b;
        border-color: #e2e8f0;
    }
    .ot-btn-print:hover {
        background: #f8fafc;
        border-color: #94a3b8;
        transform: translateY(-1px);
    }
</style>

<c:if test="${empty orders}">
    <div class="ot-empty">
        <span class="ot-empty-icon">📋</span>
        <div class="ot-empty-text">Không có đơn hàng nào</div>
    </div>
</c:if>

<c:if test="${not empty orders}">
    <div style="overflow-x: auto;">
        <table class="ot-table">
            <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Loại đơn</th>
                    <th>Thanh toán</th>
                    <th style="text-align:right;">Tổng tiền</th>
                    <th>Thời gian</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orders}" var="order">
                    <tr class="order-row" data-order-id="${order.orderID}">
                        <td class="ot-order-id">#${order.orderID}</td>
                        <td class="ot-customer">${order.customerName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.orderType == 'DineIn'}">
                                    <span class="ot-badge badge-dinein">
                                        <span class="ot-badge-dot"></span> Ăn tại chỗ
                                    </span>
                                </c:when>
                                <c:when test="${order.orderType == 'Pickup'}">
                                    <span class="ot-badge badge-pickup">
                                        <span class="ot-badge-dot"></span> Mang đi
                                    </span>
                                </c:when>
                                <c:when test="${order.orderType == 'Online'}">
                                    <span class="ot-badge badge-online">
                                        <span class="ot-badge-dot"></span> Giao hàng
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="ot-badge badge-default">${order.orderType}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.paymentStatus == 'Success'}">
                                    <span class="ot-badge badge-paid">
                                        <span class="ot-badge-dot"></span> Đã thanh toán
                                    </span>
                                </c:when>
                                <c:when test="${order.paymentStatus == 'Pending'}">
                                    <span class="ot-badge badge-pending">
                                        <span class="ot-badge-dot"></span> Chờ thanh toán
                                    </span>
                                </c:when>
                                <c:when test="${order.paymentStatus == 'Failed'}">
                                    <span class="ot-badge badge-failed">
                                        <span class="ot-badge-dot"></span> Thất bại
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="ot-badge badge-default">${order.paymentStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="ot-amount">
                            <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true"/> đ
                        </td>
                        <td class="ot-date">
                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td>
                            <div class="ot-actions">
                                <button class="ot-btn ot-btn-view view-order-btn"
                                        data-order-id="${order.orderID}"
                                        title="Xem chi tiết">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                        <circle cx="12" cy="12" r="3"/>
                                    </svg>
                                    Xem
                                </button>
                                <a href="${pageContext.request.contextPath}/staff/invoice?orderId=${order.orderID}"
                                   class="ot-btn ot-btn-print"
                                   title="In hóa đơn">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <polyline points="6 9 6 2 18 2 18 9"/>
                                        <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                                        <rect x="6" y="14" width="12" height="8"/>
                                    </svg>
                                    In
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>
