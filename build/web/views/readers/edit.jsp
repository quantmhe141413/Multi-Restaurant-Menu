<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Reader Card - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-warning text-dark">
                        <h4 class="mb-0"><i class="bi bi-pencil-square"></i> Edit Reader Card</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle"></i> ${error}
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/readers" method="post">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="readerId" value="${reader.readerId}">
                            
                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">Card Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="cardNumber" name="cardNumber" 
                                       value="${reader.cardNumber}" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${reader.fullName}" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="text" class="form-control" id="phone" name="phone" 
                                           value="${reader.phone}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${reader.email}">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2">${reader.address}</textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="userId" class="form-label">User Account ID (Optional)</label>
                                <input type="number" class="form-control" id="userId" name="userId" 
                                       value="${reader.userId}">
                                <div class="form-text">Leave empty if not linked to any user account</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="expiryDate" class="form-label">Expiry Date</label>
                                <fmt:formatDate value="${reader.expiryDate}" pattern="yyyy-MM-dd" var="formattedDate"/>
                                <input type="date" class="form-control" id="expiryDate" name="expiryDate" 
                                       value="${formattedDate}">
                            </div>
                            
                            <div class="mb-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="1" ${reader.status ? 'selected' : ''}>Active</option>
                                    <option value="0" ${!reader.status ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/readers" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-save"></i> Update Reader Card
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
