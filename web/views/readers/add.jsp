<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Reader Card - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="bi bi-credit-card-2-front"></i> Create New Reader Card</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle"></i> ${error}
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/readers" method="post">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">Card Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="cardNumber" name="cardNumber" 
                                       placeholder="e.g., RD001" required>
                                <div class="form-text">Unique card number for the reader</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="text" class="form-control" id="phone" name="phone">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="userId" class="form-label">Link to User Account (Optional)</label>
                                <select class="form-select" id="userId" name="userId">
                                    <option value="">-- No User Account --</option>
                                    <c:forEach items="${availableUsers}" var="user">
                                        <option value="${user.userId}">${user.fullName} (${user.username})</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Link this reader card to an existing user account</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="expiryDate" class="form-label">Expiry Date</label>
                                <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                                <div class="form-text">Leave empty to set expiry date to 1 year from now</div>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/readers" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save"></i> Create Reader Card
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
