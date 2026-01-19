<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Management - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-book"></i> Book Management</h2>
            <c:if test="${sessionScope.user.admin || sessionScope.user.librarian}">
                <a href="${pageContext.request.contextPath}/books?action=add" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> Add New Book
                </a>
            </c:if>
        </div>
        
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'added'}">Book added successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">Book updated successfully!</c:when>
                    <c:when test="${param.success == 'hidden'}">Book hidden successfully!</c:when>
                    <c:when test="${param.success == 'unhidden'}">Book unhidden successfully!</c:when>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Category</th>
                        <th>Publisher</th>
                        <th>Year</th>
                        <th>Location</th>
                        <th>Available/Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${books}" var="book">
                        <tr>
                            <td>${book.bookId}</td>
                            <td>${book.title}</td>
                            <td>${book.author}</td>
                            <td><span class="badge bg-info">${book.categoryName}</span></td>
                            <td>${book.publisher}</td>
                            <td>${book.publishYear}</td>
                            <td>${book.location}</td>
                            <td>
                                <span class="badge ${book.availableQuantity > 0 ? 'bg-success' : 'bg-danger'}">
                                    ${book.availableQuantity}/${book.quantity}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${book.hidden}">
                                        <span class="badge bg-secondary"><i class="bi bi-eye-slash"></i> Hidden</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success"><i class="bi bi-eye"></i> Visible</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/books?action=view&id=${book.bookId}" 
                                   class="btn btn-sm btn-info" title="View">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <c:if test="${sessionScope.user.admin}">
                                    <a href="${pageContext.request.contextPath}/books?action=edit&id=${book.bookId}" 
                                       class="btn btn-sm btn-warning" title="Edit">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <c:choose>
                                        <c:when test="${book.hidden}">
                                            <a href="${pageContext.request.contextPath}/books?action=unhide&id=${book.bookId}" 
                                               class="btn btn-sm btn-success" title="Unhide Book">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/books?action=hide&id=${book.bookId}" 
                                               class="btn btn-sm btn-secondary" title="Hide Book"
                                               onclick="return confirm('Are you sure you want to hide this book?')">
                                                <i class="bi bi-eye-slash"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Book pagination">
                    <ul class="pagination justify-content-center">
                        <!-- Previous button -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/books?page=${currentPage - 1}">
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
                                        <a class="page-link" href="${pageContext.request.contextPath}/books?page=${i}">${i}</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- Next button -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/books?page=${currentPage + 1}">
                                Next <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                
                <div class="text-center text-muted mb-3">
                    <small>Showing page ${currentPage} of ${totalPages} (Total: ${totalBooks} books)</small>
                </div>
            </c:if>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
