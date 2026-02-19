<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <c:set var="pageTitle" value="Menu Items" scope="request" />
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
                                    <h1><i class="fas fa-utensils text-primary"></i>Item Management</h1>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/">Home</a></li>
                                            <li class="breadcrumb-item active">Menu Items</li>
                                        </ol>
                                    </nav>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/items?action=add"
                                        class="btn btn-primary">
                                        <i class="fas fa-plus-circle"></i> Add New Item
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

                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0 align-middle">
                                            <thead class="table-light py-3">
                                                <tr>
                                                    <th class="ps-4">ID</th>
                                                    <th>SKU</th>
                                                    <th>Item Details</th>
                                                    <th>Category</th>
                                                    <th>Price</th>
                                                    <th>Status</th>
                                                    <th class="text-end pe-4">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty items}">
                                                        <tr>
                                                            <td colspan="6" class="text-center py-5">
                                                                <i class="fas fa-hamburger fa-3x text-muted mb-3"></i>
                                                                <p class="text-muted">No dishes found. Add your first
                                                                    masterpiece!</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="item" items="${items}">
                                                            <tr>
                                                                <td class="ps-4"><strong>#${item.itemID}</strong></td>
                                                                <td><span
                                                                        class="badge bg-light text-dark border">${item.sku}</span>
                                                                </td>
                                                                <td>
                                                                    <div class="fw-bold text-dark">${item.itemName}
                                                                    </div>
                                                                    <div class="text-muted small text-truncate"
                                                                        style="max-width: 250px;">${item.description}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:forEach var="cat" items="${categories}">
                                                                        <c:if
                                                                            test="${cat.categoryID == item.categoryID}">
                                                                            <span
                                                                                class="badge bg-soft-info text-info px-2 py-1">${cat.categoryName}</span>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </td>
                                                                <td><span class="fw-bold text-primary">
                                                                        <fmt:formatNumber value="${item.price}"
                                                                            pattern="#,###" /> VND
                                                                    </span></td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${item.isAvailable}">
                                                                            <span class="badge bg-success"><i
                                                                                    class="fas fa-check me-1"></i>Available</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-secondary"><i
                                                                                    class="fas fa-times me-1"></i>Unavailable</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end pe-4">
                                                                    <div class="btn-group">
                                                                        <a href="${pageContext.request.contextPath}/items?action=edit&id=${item.itemID}"
                                                                            class="btn btn-sm btn-outline-warning"
                                                                            title="Edit">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <button onclick="confirmDelete(${item.itemID})"
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
                    .bg-soft-info {
                        background-color: rgba(6, 182, 212, 0.1);
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
                </style>

                <jsp:include page="/views/includes/footer.jsp" />
                <jsp:include page="/views/includes/std_scripts.jsp" />
            </body>

            </html>

            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                function confirmDelete(id) {
                    Swal.fire({
                        title: 'Delete Item?',
                        text: "This item will be removed from your menu.",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#ef4444',
                        cancelButtonColor: '#64748b',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '${pageContext.request.contextPath}/items?action=delete&id=' + id;
                        }
                    })
                }
            </script>