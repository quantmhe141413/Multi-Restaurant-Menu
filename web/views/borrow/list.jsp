<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrow Management - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-arrow-left-right"></i> Borrow Management</h2>
            <a href="${pageContext.request.contextPath}/borrow?action=new" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> New Borrow Slip
            </a>
        </div>
        
        <!-- Filter Buttons -->
        <div class="btn-group mb-3" role="group">
            <a href="${pageContext.request.contextPath}/borrow" 
               class="btn ${empty statusFilter ? 'btn-primary' : 'btn-outline-primary'}">All</a>
            <a href="${pageContext.request.contextPath}/borrow?status=active" 
               class="btn ${statusFilter == 'active' ? 'btn-primary' : 'btn-outline-primary'}">Active</a>
            <a href="${pageContext.request.contextPath}/borrow?status=overdue" 
               class="btn ${statusFilter == 'overdue' ? 'btn-danger' : 'btn-outline-danger'}">Overdue</a>
        </div>
        
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show">
                <c:choose>
                    <c:when test="${param.success == 'created'}">Borrow slip created successfully!</c:when>
                    <c:when test="${param.success == 'returned'}">Books returned successfully!</c:when>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <div class="table-responsive">
            <table class="table table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Slip ID</th>
                        <th>Reader</th>
                        <th>Card Number</th>
                        <th>Borrow Date</th>
                        <th>Due Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                        <th>Librarian</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${borrowSlips}" var="slip">
                        <tr>
                            <td>${slip.slipId}</td>
                            <td>${slip.readerName}</td>
                            <td>${slip.readerCardNumber}</td>
                            <td><fmt:formatDate value="${slip.borrowDate}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <fmt:formatDate value="${slip.dueDate}" pattern="dd/MM/yyyy"/>
                                <c:if test="${slip.overdue}">
                                    <span class="badge bg-danger">Overdue</span>
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
                                        <span class="badge bg-warning">Borrowed</span>
                                    </c:when>
                                    <c:when test="${slip.status == 'returned'}">
                                        <span class="badge bg-success">Returned</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${slip.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${slip.librarianName}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/borrow?action=view&id=${slip.slipId}" 
                                   class="btn btn-sm btn-info">
                                    <i class="bi bi-eye"></i> View
                                </a>
                                <c:if test="${slip.status == 'borrowed'}">
                                    <a href="${pageContext.request.contextPath}/borrow?action=return&id=${slip.slipId}" 
                                       class="btn btn-sm btn-success"
                                       onclick="return confirm('Mark all books as returned?')">
                                        <i class="bi bi-check-circle"></i> Return
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <c:if test="${empty borrowSlips}">
            <div class="alert alert-info text-center">
                <i class="bi bi-info-circle"></i> No borrow slips found.
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
