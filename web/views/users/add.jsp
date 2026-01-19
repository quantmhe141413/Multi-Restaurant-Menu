<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .card-header-custom {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header card-header-custom">
                        <h4 class="mb-0"><i class="bi bi-person-plus"></i> Add New Staff (Librarian)</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-triangle"></i> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/users" method="post">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">
                                        <i class="bi bi-person"></i> Username *
                                    </label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">
                                        <i class="bi bi-lock"></i> Password *
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fullName" class="form-label">
                                    <i class="bi bi-person-badge"></i> Full Name *
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">
                                        <i class="bi bi-envelope"></i> Email
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">
                                        <i class="bi bi-telephone"></i> Phone
                                    </label>
                                    <input type="tel" class="form-control" id="phone" name="phone">
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> <strong>Note:</strong> This will create a Librarian account. Staff members can manage books, borrowing, and reader cards.
                            </div>
                            
                            <hr>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save"></i> Create Staff
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
