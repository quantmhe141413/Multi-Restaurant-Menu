<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-warning text-white">
                        <h4 class="mb-0"><i class="bi bi-pencil"></i> Edit Book</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/books" method="post">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="bookId" value="${book.bookId}">
                            
                            <div class="mb-3">
                                <label for="title" class="form-label">Title *</label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       value="${book.title}" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="author" class="form-label">Author *</label>
                                    <input type="text" class="form-control" id="author" name="author" 
                                           value="${book.author}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="publisher" class="form-label">Publisher</label>
                                    <input type="text" class="form-control" id="publisher" name="publisher" 
                                           value="${book.publisher}">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="publishYear" class="form-label">Publish Year</label>
                                    <input type="number" class="form-control" id="publishYear" name="publishYear" 
                                           min="1900" max="2100" value="${book.publishYear}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="isbn" class="form-label">ISBN</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" 
                                           value="${book.isbn}">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <label for="categoryId" class="form-label">Category *</label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.categoryId}" 
                                                    ${cat.categoryId == book.categoryId ? 'selected' : ''}>
                                                ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="quantity" class="form-label">Total Quantity *</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" 
                                           min="1" value="${book.quantity}" required>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="availableQuantity" class="form-label">Available *</label>
                                    <input type="number" class="form-control" id="availableQuantity" 
                                           name="availableQuantity" min="0" value="${book.availableQuantity}" required>
                                    <small class="text-muted">Currently borrowed: ${book.quantity - book.availableQuantity}</small>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="location" class="form-label">Location</label>
                                    <input type="text" class="form-control" id="location" name="location" 
                                           value="${book.location}" placeholder="Shelf / Row / Room">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                       value="${book.imageUrl}">
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="3">${book.description}</textarea>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-save"></i> Update Book
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
