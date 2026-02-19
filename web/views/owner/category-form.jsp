<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="pageTitle" value="${empty category ? 'Add Category' : 'Edit Category'}" scope="request" />
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
                        <div class="page-header">
                            <h1><i class="fas ${empty category ? 'fa-plus-circle' : 'fa-edit'} text-primary"></i>
                                ${empty
                                category ? 'Add New Category' : 'Edit Category'}</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a>
                                    </li>
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/categories">Categories</a>
                                    </li>
                                    <li class="breadcrumb-item active">${empty category ? 'Add' : 'Edit'}</li>
                                </ol>
                            </nav>
                        </div>

                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="card shadow-sm border-0">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0 text-primary font-weight-bold">
                                            <i class="fas fa-info-circle me-2"></i>Category Details
                                        </h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="${pageContext.request.contextPath}/categories" method="post"
                                            id="categoryForm">
                                            <input type="hidden" name="action"
                                                value="${empty category ? 'add' : 'edit'}">
                                            <c:if test="${not empty category}">
                                                <input type="hidden" name="categoryId" value="${category.categoryID}">
                                            </c:if>

                                            <div class="mb-4">
                                                <label for="categoryName" class="form-label">Category Name <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="categoryName"
                                                    name="categoryName" value="${category.categoryName}" required
                                                    placeholder="e.g. Main Course, Desserts...">
                                                <div class="form-text">Give your category a clear, appetizing name.
                                                </div>
                                            </div>

                                            <div class="mb-4">
                                                <label for="description" class="form-label">Description</label>
                                                <textarea class="form-control" id="description" name="description"
                                                    rows="4"
                                                    placeholder="Briefly describe what this category includes...">${category.description}</textarea>
                                            </div>

                                            <div class="d-flex justify-content-between mt-5">
                                                <a href="${pageContext.request.contextPath}/categories"
                                                    class="btn btn-light px-4">
                                                    <i class="fas fa-arrow-left me-2"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary px-5">
                                                    <i class="fas fa-save me-2"></i>Save Category
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>

            <style>
                .main-content {
                    padding: 2rem;
                    background-color: #f8fafc;
                    min-height: 100vh;
                }

                .form-label {
                    font-weight: 600;
                    color: #475569;
                }

                .form-control {
                    border-radius: 10px;
                    padding: 0.75rem 1rem;
                    border: 1px solid #e2e8f0;
                }

                .form-control:focus {
                    border-color: #6366f1;
                    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                }

                .card {
                    border-radius: 15px;
                }
            </style>

            <jsp:include page="/views/includes/footer.jsp" />
            <jsp:include page="/views/includes/std_scripts.jsp" />
        </body>

        </html>