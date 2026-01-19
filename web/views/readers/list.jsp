<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reader Card Management - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-credit-card"></i> Reader Card Management</h2>
            <a href="${pageContext.request.contextPath}/readers?action=add" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Create New Reader Card
            </a>
        </div>
        
        <!-- Search Bar -->
        <div class="row mb-3">
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/readers" method="get" class="input-group">
                    <input type="hidden" name="action" value="search">
                    <input type="text" class="form-control" name="keyword" 
                           placeholder="Search by name, card number, or phone..." 
                           value="${keyword}">
                    <button class="btn btn-outline-primary" type="submit">
                        <i class="bi bi-search"></i> Search
                    </button>
                </form>
            </div>
        </div>
        
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'added'}">Reader card created successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">Reader card updated successfully!</c:when>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Card Number</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Expiry Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${readers}" var="reader">
                        <tr>
                            <td><strong>${reader.cardNumber}</strong></td>
                            <td>${reader.fullName}</td>
                            <td>${reader.phone}</td>
                            <td>${reader.email}</td>
                            <td>
                                <fmt:formatDate value="${reader.expiryDate}" pattern="dd/MM/yyyy"/>
                                <c:if test="${reader.expired}">
                                    <span class="badge bg-danger ms-1">Expired</span>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${reader.active}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/readers?action=view&id=${reader.readerId}" 
                                   class="btn btn-sm btn-info" title="View">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/readers?action=edit&id=${reader.readerId}" 
                                   class="btn btn-sm btn-warning" title="Edit">
                                    <i class="bi bi-pencil"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <c:if test="${empty readers}">
            <div class="alert alert-info text-center">
                <i class="bi bi-info-circle"></i> No reader cards found.
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
