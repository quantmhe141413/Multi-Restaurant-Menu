<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Borrow Slip - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0"><i class="bi bi-plus-circle"></i> Create New Borrow Slip</h4>
            </div>
            <div class="card-body">
                <c:if test="${error != null}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/borrow" method="post" id="borrowForm">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="readerId" class="form-label">Reader *</label>
                            <select class="form-select" id="readerId" name="readerId" required>
                                <option value="">-- Select Reader --</option>
                                <c:forEach items="${readers}" var="reader">
                                    <option value="${reader.readerId}">
                                        ${reader.fullName} (${reader.cardNumber})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="daysToReturn" class="form-label">Days to Return *</label>
                            <input type="number" class="form-control" id="daysToReturn" name="daysToReturn" 
                                   min="1" max="30" value="14" required>
                            <small class="text-muted">Maximum 30 days</small>
                        </div>
                    </div>
                    
                    <h5 class="mt-3"><i class="bi bi-book"></i> Select Books</h5>
                    <div class="row mb-2">
                        <div class="col-md-4 mb-2">
                            <label for="categoryFilter" class="form-label">Category</label>
                            <select id="categoryFilter" class="form-select">
                                <option value="">-- All Categories --</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.categoryId}">${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-8 mb-2">
                            <label for="bookSearch" class="form-label">Search by code or title</label>
                            <input type="text" id="bookSearch" class="form-control" 
                                   placeholder="Enter book ID / title / author...">
                        </div>
                    </div>
                    <div id="booksList">
                        <div class="row book-item mb-2">
                            <div class="col-md-9">
                                <select class="form-select" name="bookId" required>
                                    <option value="">-- Select Book --</option>
                                    <c:forEach items="${books}" var="book">
                                        <option value="${book.bookId}"
                                                data-category="${book.categoryId}">
                                            [ID: ${book.bookId}] ${book.title} - ${book.author}
                                            (${book.categoryName}) (Available: ${book.availableQuantity})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="number" class="form-control" name="quantity" 
                                       min="1" value="1" placeholder="Qty" required>
                            </div>
                            <div class="col-md-1">
                                <button type="button" class="btn btn-danger btn-sm remove-book" disabled>
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-sm btn-success mb-3" id="addBook">
                        <i class="bi bi-plus"></i> Add Another Book
                    </button>
                    
                    <div class="mb-3">
                        <label for="notes" class="form-label">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="2"></textarea>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/borrow" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Create Borrow Slip
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const categoryFilter = document.getElementById('categoryFilter');
        const bookSearch = document.getElementById('bookSearch');

        function filterBooks() {
            const categoryId = categoryFilter.value;
            const keyword = bookSearch.value.toLowerCase();

            document.querySelectorAll('#booksList select[name="bookId"]').forEach(select => {
                Array.from(select.options).forEach(option => {
                    if (option.value === '') {
                        option.hidden = false;
                        return;
                    }
                    const optCategory = option.getAttribute('data-category');
                    const text = option.text.toLowerCase();
                    const matchCategory = !categoryId || optCategory === categoryId;
                    const matchKeyword = !keyword || text.includes(keyword);
                    option.hidden = !(matchCategory && matchKeyword);
                });

                if (select.selectedOptions.length && select.selectedOptions[0].hidden) {
                    select.value = '';
                }
            });
        }

        categoryFilter.addEventListener('change', filterBooks);
        bookSearch.addEventListener('input', filterBooks);

        document.getElementById('addBook').addEventListener('click', function() {
            const booksList = document.getElementById('booksList');
            const firstItem = booksList.querySelector('.book-item');
            const newItem = firstItem.cloneNode(true);
            
            // Reset values
            newItem.querySelector('select').value = '';
            newItem.querySelector('input[name="quantity"]').value = '1';
            newItem.querySelector('.remove-book').disabled = false;
            
            booksList.appendChild(newItem);
            updateRemoveButtons();
            filterBooks();
        });
        
        document.getElementById('booksList').addEventListener('click', function(e) {
            if (e.target.closest('.remove-book')) {
                e.target.closest('.book-item').remove();
                updateRemoveButtons();
            }
        });
        
        function updateRemoveButtons() {
            const items = document.querySelectorAll('.book-item');
            items.forEach((item, index) => {
                const btn = item.querySelector('.remove-book');
                btn.disabled = (items.length === 1);
            });
        }

        // initial filter (in case there is default state)
        filterBooks();
    </script>
</body>
</html>
