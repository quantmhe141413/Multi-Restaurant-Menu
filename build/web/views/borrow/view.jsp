<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrow Slip #${borrowSlip.slipId} - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/borrow">Borrow</a></li>
                <li class="breadcrumb-item active">Slip #${borrowSlip.slipId}</li>
            </ol>
        </nav>
        
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="bi bi-receipt"></i> Borrow Slip #${borrowSlip.slipId}
                    <c:choose>
                        <c:when test="${borrowSlip.status == 'borrowed'}">
                            <span class="badge bg-warning float-end">Borrowed</span>
                        </c:when>
                        <c:when test="${borrowSlip.status == 'returned'}">
                            <span class="badge bg-success float-end">Returned</span>
                        </c:when>
                    </c:choose>
                    <c:if test="${borrowSlip.overdue}">
                        <span class="badge bg-danger float-end me-2">Overdue</span>
                    </c:if>
                </h4>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5><i class="bi bi-person"></i> Reader Information</h5>
                        <table class="table table-sm">
                            <tr>
                                <th width="150">Name:</th>
                                <td>${borrowSlip.readerName}</td>
                            </tr>
                            <tr>
                                <th>Card Number:</th>
                                <td>${borrowSlip.readerCardNumber}</td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h5><i class="bi bi-calendar"></i> Dates</h5>
                        <table class="table table-sm">
                            <tr>
                                <th width="150">Borrow Date:</th>
                                <td><fmt:formatDate value="${borrowSlip.borrowDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                            <tr>
                                <th>Due Date:</th>
                                <td>
                                    <fmt:formatDate value="${borrowSlip.dueDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    <c:if test="${borrowSlip.overdue}">
                                        <span class="badge bg-danger">Overdue</span>
                                    </c:if>
                                </td>
                            </tr>
                            <c:if test="${borrowSlip.returnDate != null}">
                                <tr>
                                    <th>Return Date:</th>
                                    <td><fmt:formatDate value="${borrowSlip.returnDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                </tr>
                            </c:if>
                            <tr>
                                <th>Librarian:</th>
                                <td>${borrowSlip.librarianName}</td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <h5><i class="bi bi-book"></i> Borrowed Books</h5>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead class="table-dark">
                            <tr>
                                <th>Book Title</th>
                                <th>Author</th>
                                <th>Quantity</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${borrowSlip.borrowDetails}" var="detail">
                                <tr>
                                    <td>${detail.bookTitle}</td>
                                    <td>${detail.bookAuthor}</td>
                                    <td>${detail.quantity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${detail.returned}">
                                                <span class="badge bg-success">Returned</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">Not Returned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <h5><i class="bi bi-info-circle"></i> Slip Status</h5>
                <table class="table table-sm">
                    <tr>
                        <th>Status:</th>
                        <td>
                            <c:choose>
                                <c:when test="${borrowSlip.returned}">
                                    <span class="badge bg-success">Returned</span>
                                </c:when>
                                <c:when test="${borrowSlip.overdue}">
                                    <span class="badge bg-danger">Overdue</span>
                                    <c:if test="${!borrowSlip.finePaid}">
                                        <span class="badge bg-warning text-dark ms-2">Unpaid fine</span>
                                        <c:if test="${sessionScope.user.librarian || sessionScope.user.admin}">
                                            <a href="${pageContext.request.contextPath}/borrow?action=markFinePaid&id=${borrowSlip.slipId}"
                                               class="btn btn-sm btn-outline-success ms-2"
                                               onclick="return confirm('Xác nhận độc giả đã nộp phí trễ hạn?');">
                                                Confirm fine paid
                                            </a>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${borrowSlip.finePaid}">
                                        <span class="badge bg-success ms-2">Fine paid</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark">Borrowed</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
                
                <c:if test="${not empty borrowSlip.notes}">
                    <div class="alert alert-info">
                        <strong><i class="bi bi-sticky"></i> Notes:</strong>
                        ${borrowSlip.notes}
                    </div>
                </c:if>
                
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/borrow" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    <c:if test="${borrowSlip.status == 'borrowed'}">
                        <a href="${pageContext.request.contextPath}/borrow?action=return&id=${borrowSlip.slipId}" 
                           class="btn btn-success"
                           onclick="return confirm('Mark all books as returned?')">
                            <i class="bi bi-check-circle"></i> Mark as Returned
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
