<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .card-header-custom {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            color: white;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/users">Users</a></li>
                <li class="breadcrumb-item active">${user.username}</li>
            </ol>
        </nav>
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header card-header-custom">
                        <h4 class="mb-0"><i class="bi bi-person-circle"></i> User Details</h4>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-hash"></i> User ID:
                            </div>
                            <div class="col-md-8">
                                ${user.userId}
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-person"></i> Username:
                            </div>
                            <div class="col-md-8">
                                ${user.username}
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-person-badge"></i> Full Name:
                            </div>
                            <div class="col-md-8">
                                ${user.fullName}
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-envelope"></i> Email:
                            </div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${not empty user.email}">
                                        <a href="mailto:${user.email}">${user.email}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Not provided</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-telephone"></i> Phone:
                            </div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${not empty user.phone}">
                                        ${user.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Not provided</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-shield"></i> Role:
                            </div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${user.admin}">
                                        <span class="badge bg-danger fs-6">Admin</span>
                                    </c:when>
                                    <c:when test="${user.librarian}">
                                        <span class="badge bg-primary fs-6">Librarian</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary fs-6">Reader</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-toggle-on"></i> Status:
                            </div>
                            <div class="col-md-8">
                                <c:choose>
                                    <c:when test="${user.status}">
                                        <span class="badge bg-success fs-6">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary fs-6">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4 info-label">
                                <i class="bi bi-calendar"></i> Created Date:
                            </div>
                            <div class="col-md-8">
                                <fmt:formatDate value="${user.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Back to List
                            </a>
                            <div>
                                <a href="${pageContext.request.contextPath}/users?action=edit&id=${user.userId}" 
                                   class="btn btn-warning">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <c:if test="${user.userId != sessionScope.user.userId}">
                                    <c:choose>
                                        <c:when test="${user.status}">
                                            <a href="${pageContext.request.contextPath}/users?action=ban&id=${user.userId}" 
                                               class="btn btn-danger"
                                               onclick="return confirm('Ban this user? They will not be able to login.')">
                                                <i class="bi bi-ban"></i> Ban User
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/users?action=ban&id=${user.userId}" 
                                               class="btn btn-success"
                                               onclick="return confirm('Unban this user? They will be able to login again.')">
                                                <i class="bi bi-check-circle"></i> Unban User
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
