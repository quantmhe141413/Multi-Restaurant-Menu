<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reader Card Details - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="bi bi-credit-card"></i> Reader Card Details</h4>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Card Number:</div>
                            <div class="col-md-8">
                                <span class="badge bg-primary fs-6">${reader.cardNumber}</span>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Full Name:</div>
                            <div class="col-md-8">${reader.fullName}</div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Phone:</div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${not empty reader.phone}">
                                        <i class="bi bi-telephone"></i> ${reader.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">N/A</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Email:</div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${not empty reader.email}">
                                        <i class="bi bi-envelope"></i> ${reader.email}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">N/A</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Address:</div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${not empty reader.address}">
                                        <i class="bi bi-geo-alt"></i> ${reader.address}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">N/A</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Created Date:</div>
                            <div class="col-md-8">
                                <fmt:formatDate value="${reader.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Expiry Date:</div>
                            <div class="col-md-8">
                                <fmt:formatDate value="${reader.expiryDate}" pattern="dd/MM/yyyy"/>
                                <c:if test="${reader.expired}">
                                    <span class="badge bg-danger ms-2">Expired</span>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Status:</div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${reader.active}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">User Account:</div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${not empty reader.userId}">
                                        <span class="badge bg-info">Linked (User ID: ${reader.userId})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Not linked</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <h5 class="mt-4"><i class="bi bi-clock-history"></i> Borrow History</h5>
                        <c:if test="${not empty borrowSlips}">
                            <div class="table-responsive mb-3">
                                <table class="table table-striped">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Slip ID</th>
                                            <th>Borrow Date</th>
                                            <th>Due Date</th>
                                            <th>Status</th>
                                            <th>Librarian</th>
                                            <th>Actions</th>
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
                                                        <span class="badge bg-danger ms-1">Overdue</span>
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
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${empty borrowSlips}">
                            <div class="alert alert-info mt-2">
                                <i class="bi bi-info-circle"></i> This reader has no borrow history.
                            </div>
                        </c:if>
                        
                        <div class="d-flex justify-content-between mt-3">
                            <a href="${pageContext.request.contextPath}/readers" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Back to List
                            </a>
                            <a href="${pageContext.request.contextPath}/readers?action=edit&id=${reader.readerId}" 
                               class="btn btn-warning">
                                <i class="bi bi-pencil"></i> Edit
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
