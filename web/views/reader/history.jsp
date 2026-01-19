<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử mượn sách - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-3"><i class="bi bi-clock-history"></i> Lịch sử mượn sách</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <c:if test="${not empty reader}">
            <div class="mb-3">
                <p>
                    <strong>Độc giả:</strong> ${reader.fullName}
                    (<span class="badge bg-primary">${reader.cardNumber}</span>)
                </p>
            </div>
        </c:if>
        
        <c:if test="${not empty borrowSlips}">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>Mã phiếu</th>
                            <th>Ngày mượn</th>
                            <th>Hạn trả</th>
                            <th>Ngày trả</th>
                            <th>Trạng thái</th>
                            <th>Chi tiết sách</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${borrowSlips}" var="slip">
                            <tr>
                                <td>${slip.slipId}</td>
                                <td><fmt:formatDate value="${slip.borrowDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <fmt:formatDate value="${slip.dueDate}" pattern="dd/MM/yyyy"/>
                                    <c:if test="${slip.overdue}">
                                        <span class="badge bg-danger ms-1">Quá hạn</span>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${slip.returnDate != null}">
                                        <fmt:formatDate value="${slip.returnDate}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${slip.status == 'borrowed'}">
                                            <span class="badge bg-warning text-dark">Đang mượn</span>
                                        </c:when>
                                        <c:when test="${slip.status == 'returned'}">
                                            <span class="badge bg-success">Đã trả</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${slip.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${not empty slip.borrowDetails}">
                                        <ul class="mb-0">
                                            <c:forEach items="${slip.borrowDetails}" var="detail">
                                                <li>
                                                    <strong>${detail.bookTitle}</strong>
                                                    - ${detail.bookAuthor}
                                                    (SL: ${detail.quantity})
                                                    <c:choose>
                                                        <c:when test="${detail.returned}">
                                                            <span class="badge bg-success ms-1">Đã trả</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning text-dark ms-1">Chưa trả</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <c:if test="${empty borrowSlips && empty error}">
            <div class="alert alert-info">
                <i class="bi bi-info-circle"></i> Bạn chưa có lịch sử mượn sách nào.
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
