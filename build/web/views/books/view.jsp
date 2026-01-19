<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .book-cover {
            max-height: 400px;
            object-fit: cover;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books">Books</a></li>
                <li class="breadcrumb-item active">${book.title}</li>
            </ol>
        </nav>
        
        <div class="row">
            <div class="col-md-4">
                <c:choose>
                    <c:when test="${not empty book.imageUrl}">
                        <img src="${book.imageUrl}" class="img-fluid book-cover rounded" alt="${book.title}">
                    </c:when>
                    <c:otherwise>
                        <div class="text-center p-5 bg-light rounded">
                            <i class="bi bi-book display-1 text-muted"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="col-md-8">
                <h2 class="mb-3">${book.title}</h2>
                
                <table class="table table-borderless">
                    <tbody>
                        <tr>
                            <th width="150"><i class="bi bi-person"></i> Author:</th>
                            <td>${book.author}</td>
                        </tr>
                        <tr>
                            <th><i class="bi bi-building"></i> Publisher:</th>
                            <td>${book.publisher}</td>
                        </tr>
                        <tr>
                            <th><i class="bi bi-calendar"></i> Publish Year:</th>
                            <td>${book.publishYear}</td>
                        </tr>
                        <tr>
                            <th><i class="bi bi-upc"></i> ISBN:</th>
                            <td>${book.isbn}</td>
                        </tr>
                        <tr>
                            <th><i class="bi bi-tag"></i> Category:</th>
                            <td><span class="badge bg-info">${book.categoryName}</span></td>
                        </tr>
                        <tr>
                            <th><i class="bi bi-geo-alt"></i> Location:</th>
                            <td>${book.location}</td>
                        </tr>
                        <tr>
                            <th><i class="bi bi-box"></i> Availability:</th>
                            <td>
                                <span class="badge ${book.availableQuantity > 0 ? 'bg-success' : 'bg-danger'} fs-6">
                                    ${book.availableQuantity} available / ${book.quantity} total
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
                <c:if test="${not empty book.description}">
                    <div class="mt-4">
                        <h5><i class="bi bi-file-text"></i> Description:</h5>
                        <p class="text-muted">${book.description}</p>
                    </div>
                </c:if>
                
                <c:if test="${not empty currentBorrowers}">
                    <div class="mt-4">
                        <h5><i class="bi bi-people"></i> Currently Borrowed By:</h5>
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Reader</th>
                                        <th>Card Number</th>
                                        <th>Quantity</th>
                                        <th>Due Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${currentBorrowers}" var="b">
                                        <tr>
                                            <td>${b.readerName}</td>
                                            <td>${b.readerCardNumber}</td>
                                            <td>${b.totalQuantity}</td>
                                            <td>${b.dueDate}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:if>
                
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    <c:if test="${sessionScope.user.librarian || sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/books?action=edit&id=${book.bookId}" 
                           class="btn btn-warning">
                            <i class="bi bi-pencil"></i> Edit
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/books?action=delete&id=${book.bookId}" 
                           class="btn btn-danger"
                           onclick="return confirm('Are you sure you want to delete this book?')">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
