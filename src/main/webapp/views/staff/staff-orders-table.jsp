<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-state">
                            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="1.5" style="margin: 0 auto 1rem; color: #cbd5e1;">
                                <path
                                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                            <p style="font-size: 1rem; color: #64748b; margin-bottom: 0.5rem;">Không có đơn hàng nào</p>
                            <p style="font-size: 0.875rem; color: #94a3b8;">Thử thay đổi bộ lọc hoặc tạo đơn hàng mới
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Mã ĐH</th>
                                    <th>Loại</th>
                                    <th>Bàn</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thanh toán</th>
                                    <th>Thời gian</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td style="font-weight: 600; color: #4a90e2;">#${order.orderID}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.orderType == 'DineIn'}">Ăn tại chỗ</c:when>
                                                <c:when test="${order.orderType == 'Pickup'}">Mang đi</c:when>
                                                <c:when test="${order.orderType == 'Online'}">Giao hàng</c:when>
                                                <c:otherwise>${order.orderType}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.tableID != null && order.tableID > 0}">
                                                    Bàn ${order.tableID}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #94a3b8;">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="font-weight: 600;">
                                            <fmt:formatNumber value="${order.finalAmount}" type="number"
                                                pattern="#,##0" />đ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.orderStatus == 'Pending'}">
                                                    <span class="badge bg-warning">Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Preparing'}">
                                                    <span class="badge bg-warning">Đang chuẩn bị</span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Ready'}">
                                                    <span class="badge" style="background: #dbeafe; color: #1e40af;">Sẵn
                                                        sàng</span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Completed'}">
                                                    <span class="badge bg-success">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${order.orderStatus == 'Cancelled'}">
                                                    <span class="badge bg-danger">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge"
                                                        style="background: #f1f5f9; color: #64748b;">${order.orderStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.paymentStatus == 'Success'}">
                                                    <span class="badge bg-success">Đã thanh toán</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatus == 'Pending'}">
                                                    <span class="badge bg-warning">Chờ thanh toán</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatus == 'Failed'}">
                                                    <span class="badge bg-danger">Thất bại</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge"
                                                        style="background: #f1f5f9; color: #64748b;">${order.paymentStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color: #64748b; font-size: 0.8125rem;">
                                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <button onclick="viewOrderDetail(${order.orderID})"
                                                style="padding: 0.375rem 0.75rem; background: #4a90e2; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 0.8125rem; font-weight: 500;">
                                                Xem chi tiết
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <c:if test="${totalPages > 1}">
                            <div
                                style="padding: 1.25rem; border-top: 1px solid #e2e8f0; display: flex; justify-content: center; gap: 0.5rem;">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <button
                                        onclick="loadOrders(null, document.getElementById('fromDateFilter').value, document.getElementById('toDateFilter').value, document.getElementById('orderTypeFilter').value, ${i})"
                                        style="padding: 0.5rem 0.875rem; border: 1px solid ${i == currentPage ? '#4a90e2' : '#e2e8f0'}; background: ${i == currentPage ? '#4a90e2' : 'white'}; color: ${i == currentPage ? 'white' : '#64748b'}; border-radius: 6px; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        ${i}
                                    </button>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>