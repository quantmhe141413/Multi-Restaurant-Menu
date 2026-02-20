<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <c:set var="pageTitle" value="Menu Categories" scope="request" />
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>${pageTitle} - FoodieExpress</title>
                <jsp:include page="/views/includes/std_head.jsp" />
            </head>

            <body>
                <jsp:include page="/views/includes/header.jsp" />

                <div class="container-fluid">
                    <div class="row">
                        <jsp:include page="/views/includes/sidebar.jsp" />

                        <main class="col-md-9 col-lg-10 main-content">
                            <div class="page-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h1><i class="fas fa-list text-primary"></i> Category Management</h1>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/">Home</a>
                                            </li>
                                            <li class="breadcrumb-item active">Menu Categories</li>
                                        </ol>
                                    </nav>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/categories?action=add"
                                        class="btn btn-primary">
                                        <i class="fas fa-plus-circle"></i> Add New Category
                                    </a>
                                </div>
                            </div>

                            <!-- Message Notification -->
                            <!-- Message Notification -->
                            <c:if test="${not empty sessionScope.message}">
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        Swal.fire({
                                            icon: '${sessionScope.messageType}',
                                            title: '${sessionScope.messageType == "success" ? "Success!" : "Error!"}',
                                            text: '${sessionScope.message}',
                                            timer: 3000,
                                            showConfirmButton: false,
                                            toast: true,
                                            position: 'top-end'
                                        });
                                    });
                                </script>
                                <% session.removeAttribute("message"); session.removeAttribute("messageType"); %>
                            </c:if>

                            <!-- Advanced Search and Filter Bar -->
                            <div class="card shadow-sm border-0 mb-4">
                                <div class="card-body p-4">
                                    <form action="${pageContext.request.contextPath}/categories" method="get"
                                        id="filterForm">
                                        <input type="hidden" name="action" value="list">

                                        <div class="row g-3 align-items-center">
                                            <!-- Search -->
                                            <div class="col-md-4">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-white border-end-0">
                                                        <i class="fas fa-search text-muted"></i>
                                                    </span>
                                                    <input type="text" name="search"
                                                        class="form-control border-start-0 ps-0"
                                                        placeholder="Search by name..." value="${currentSearch}">
                                                </div>
                                            </div>

                                            <!-- Status -->
                                            <div class="col-md-2">
                                                <select name="status" class="form-select">
                                                    <option value="">All Status</option>
                                                    <option value="active" ${currentStatus=='active' ? 'selected' : ''
                                                        }>
                                                        Active</option>
                                                    <option value="inactive" ${currentStatus=='inactive' ? 'selected'
                                                        : '' }>Inactive</option>
                                                </select>
                                            </div>

                                            <!-- Sort By -->
                                            <div class="col-md-2">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light"><i
                                                            class="fas fa-sort"></i></span>
                                                    <select name="sortBy" class="form-select">
                                                        <option value="DisplayOrder" ${currentSortBy=='DisplayOrder'
                                                            ? 'selected' : '' }>Sort by Order</option>
                                                        <option value="name" ${currentSortBy=='name' ? 'selected' : ''
                                                            }>
                                                            Sort by Name</option>
                                                        <option value="status" ${currentSortBy=='status' ? 'selected'
                                                            : '' }>Sort by Status</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <!-- Sort Order -->
                                            <div class="col-md-2">
                                                <select name="sortOrder" class="form-select">
                                                    <option value="ASC" ${currentSortOrder=='ASC' ? 'selected' : '' }>
                                                        Ascending</option>
                                                    <option value="DESC" ${currentSortOrder=='DESC' ? 'selected' : '' }>
                                                        Descending</option>
                                                </select>
                                            </div>

                                            <!-- Apply Button -->
                                            <div class="col-md-2 d-grid">
                                                <button type="submit" class="btn btn-primary shadow-sm">
                                                    <i class="fas fa-filter me-2"></i>Apply
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Table -->
                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0 align-middle">
                                            <thead class="table-light py-3">
                                                <tr>
                                                    <th class="ps-4">ID</th>
                                                    <th>Category Name</th>
                                                    <th>Order</th>
                                                    <th>Status</th>
                                                    <th class="text-end pe-4">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty categories}">
                                                        <tr>
                                                            <td colspan="4" class="text-center py-5">
                                                                <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                                                                <p class="text-muted">No categories found. Start by
                                                                    adding
                                                                    one!
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="cat" items="${categories}">
                                                            <tr>
                                                                <td class="ps-4"><strong>#${cat.categoryID}</strong>
                                                                </td>
                                                                <td><span
                                                                        class="badge bg-soft-primary text-primary px-3 py-2">${cat.categoryName}</span>
                                                                </td>
                                                                <td>${cat.displayOrder}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${cat.isActive}">
                                                                            <span class="badge bg-success">Active</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="badge bg-secondary">Inactive</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end pe-4">
                                                                    <div class="btn-group">
                                                                        <a href="${pageContext.request.contextPath}/categories?action=edit&id=${cat.categoryID}"
                                                                            class="btn btn-sm btn-outline-warning"
                                                                            title="Edit">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <button
                                                                            onclick="confirmDelete(${cat.categoryID})"
                                                                            class="btn btn-sm btn-outline-danger"
                                                                            title="Delete">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </div>
                </div>

                <style>
                    .bg-soft-primary {
                        background-color: rgba(99, 102, 241, 0.1);
                    }

                    .main-content {
                        padding: 2rem;
                        background-color: #f8fafc;
                        min-height: 100vh;
                    }

                    .page-header h1 {
                        font-weight: 700;
                        color: #1e293b;
                        margin-bottom: 0.5rem;
                    }

                    .card {
                        border-radius: 15px;
                        overflow: hidden;
                    }

                    .table thead th {
                        font-weight: 600;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.05em;
                        color: #64748b;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .btn-group .btn {
                        border-radius: 8px;
                        margin-left: 5px;
                    }
                </style>

                <jsp:include page="/views/includes/footer.jsp" />
                <jsp:include page="/views/includes/std_scripts.jsp" />
            </body>

            </html>

            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                function confirmDelete(id) {
                    Swal.fire({
                        title: 'Delete Category?',
                        text: "All items in this category might be affected.",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#ef4444',
                        cancelButtonColor: '#64748b',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '${pageContext.request.contextPath}/categories?action=delete&id=' + id;
                        }
                    })
                }
            </script>