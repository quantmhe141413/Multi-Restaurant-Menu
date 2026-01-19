<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .book-card {
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
            border: none;
            box-shadow: 0 2px 8px rgba(30,144,255,0.1);
        }
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(30,144,255,0.2);
        }
        .badge-available {
            background-color: #28a745;
        }
        .badge-unavailable {
            background-color: #dc3545;
        }
        .search-bar {
            max-width: 600px;
        }
        .book-image {
            height: 250px;
            width: 100%;
            overflow: hidden;
            background: #f0f8ff;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .book-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .btn-primary {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #4169e1 0%, #1e90ff 100%);
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp" />
    
    <!-- Main Content -->
    <div class="container">
        <!-- Search Bar -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="search-bar mx-auto">
                    <form action="${pageContext.request.contextPath}/home" method="get" class="input-group">
                        <input type="text" class="form-control" name="keyword" 
                               placeholder="Search books by title, author, or description..." 
                               value="${keyword}">
                        <button class="btn btn-primary" type="submit">
                            <i class="bi bi-search"></i> Search
                        </button>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Category Filter -->
        <div class="row mb-3">
            <div class="col-12">
                <div class="btn-group" role="group">
                    <a href="${pageContext.request.contextPath}/home" 
                       class="btn btn-sm ${empty selectedCategoryId ? 'btn-primary' : 'btn-outline-primary'}">
                        All Categories
                    </a>
                    <c:forEach items="${categories}" var="cat">
                        <a href="${pageContext.request.contextPath}/home?categoryId=${cat.categoryId}" 
                           class="btn btn-sm ${selectedCategoryId == cat.categoryId ? 'btn-primary' : 'btn-outline-primary'}">
                            ${cat.categoryName}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>
        
        <!-- Books Grid -->
        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <c:forEach items="${books}" var="book">
                <div class="col">
                    <div class="card book-card h-100">
                        <div class="book-image d-flex align-items-center justify-content-center">
                            <c:choose>
                                <c:when test="${not empty book.imageUrl}">
                                    <img src="${book.imageUrl}" class="card-img-top" alt="${book.title}">
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-book display-1 text-muted"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <h6 class="card-title">${book.title}</h6>
                            <p class="card-text small text-muted mb-2">
                                <i class="bi bi-person"></i> ${book.author}
                            </p>
                            <p class="card-text small mb-2">
                                <span class="badge bg-info">${book.categoryName}</span>
                                <c:if test="${sessionScope.user.librarian || sessionScope.user.admin}">
                                    <c:if test="${book.hidden}">
                                        <span class="badge bg-secondary"><i class="bi bi-eye-slash"></i> Hidden</span>
                                    </c:if>
                                </c:if>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge ${book.availableQuantity > 0 ? 'badge-available' : 'badge-unavailable'}">
                                    ${book.availableQuantity}/${book.quantity} available
                                </span>
                                <a href="${pageContext.request.contextPath}/books?action=view&id=${book.bookId}" 
                                   class="btn btn-sm btn-outline-primary">
                                    View
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty books}">
            <div class="alert alert-info text-center mt-4">
                <i class="bi bi-info-circle"></i> No books found.
            </div>
        </c:if>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Book pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <!-- Previous button -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage - 1}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty selectedCategoryId}'>&categoryId=${selectedCategoryId}</c:if>">
                            <i class="bi bi-chevron-left"></i> Previous
                        </a>
                    </li>
                    
                    <!-- Page numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <li class="page-item active">
                                    <span class="page-link">${i}</span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/home?page=${i}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty selectedCategoryId}'>&categoryId=${selectedCategoryId}</c:if>">${i}</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <!-- Next button -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage + 1}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty selectedCategoryId}'>&categoryId=${selectedCategoryId}</c:if>">
                            Next <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
            
            <div class="text-center text-muted mb-4">
                <small>Showing page ${currentPage} of ${totalPages} (Total: ${totalBooks} books)</small>
            </div>
        </c:if>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
