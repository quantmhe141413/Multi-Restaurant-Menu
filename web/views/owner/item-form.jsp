<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="pageTitle" value="${empty item ? 'Add Item' : 'Edit Item'}" scope="request" />
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
                            <h1><i class="fas ${empty item ? 'fa-plus-circle' : 'fa-edit'} text-primary"></i> ${empty
                                item ?
                                'Add New Menu Item' : 'Edit Menu Item'}</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a>
                                    </li>
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/items">Items</a></li>
                                    <li class="breadcrumb-item active">${empty item ? 'Add' : 'Edit'}</li>
                                </ol>
                            </nav>
                        </div>

                        <div class="row justify-content-center">
                            <div class="col-lg-10">
                                <div class="card shadow-sm border-0">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0 text-primary font-weight-bold">
                                            <i class="fas fa-hamburger me-2"></i>Item Information
                                        </h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="${pageContext.request.contextPath}/items" method="post"
                                            id="itemForm">
                                            <input type="hidden" name="action" value="${empty item ? 'add' : 'edit'}">
                                            <c:if test="${not empty item}">
                                                <input type="hidden" name="itemId" value="${item.itemID}">
                                            </c:if>

                                            <div class="row">
                                                <div class="col-md-7">
                                                    <div class="mb-4">
                                                        <label for="itemName" class="form-label">Item Name <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="itemName"
                                                            name="itemName" value="${item.itemName}" required
                                                            placeholder="e.g. Traditional Pho, Grilled Salmon...">
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="description" class="form-label">Description</label>
                                                        <textarea class="form-control" id="description"
                                                            name="description" rows="5"
                                                            placeholder="Describe the ingredients, taste, and size...">${item.description}</textarea>
                                                    </div>
                                                </div>

                                                <div class="col-md-5">
                                                    <div class="mb-4">
                                                        <label for="categoryId" class="form-label">Category <span
                                                                class="text-danger">*</span></label>
                                                        <select class="form-select" id="categoryId" name="categoryId"
                                                            required>
                                                            <option value="">Select a category</option>
                                                            <c:forEach var="cat" items="${categories}">
                                                                <option value="${cat.categoryID}"
                                                                    ${item.categoryID==cat.categoryID ? 'selected' : ''
                                                                    }>
                                                                    ${cat.categoryName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="price" class="form-label">Price (VND) <span
                                                                class="text-danger">*</span></label>
                                                        <div class="input-group">
                                                            <input type="number" class="form-control" id="price"
                                                                name="price" value="${item.price}" step="500" min="0"
                                                                required>
                                                            <span class="input-group-text">VND</span>
                                                        </div>
                                                    </div>

                                                    <div class="mb-4">
                                                        <label class="form-label d-block">Availability</label>
                                                        <div class="form-check form-switch p-0 ps-5 mt-2">
                                                            <input class="form-check-input ms-n5" type="checkbox"
                                                                id="isAvailable" name="isAvailable" value="true" ${empty
                                                                item || item.isAvailable ? 'checked' : '' }
                                                                style="width: 3rem; height: 1.5rem;">
                                                            <label class="form-check-label ms-2" for="isAvailable">Item
                                                                is
                                                                ready for sale</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-between mt-5 pt-3 border-top">
                                                <a href="${pageContext.request.contextPath}/items"
                                                    class="btn btn-light px-4">
                                                    <i class="fas fa-arrow-left me-2"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary px-5 shadow-sm">
                                                    <i class="fas fa-save me-2"></i>Save Menu Item
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

                .form-control,
                .form-select {
                    border-radius: 10px;
                    padding: 0.75rem 1rem;
                    border: 1px solid #e2e8f0;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: #6366f1;
                    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                }

                .card {
                    border-radius: 15px;
                }

                .input-group-text {
                    border-radius: 0 10px 10px 0;
                    background-color: #f1f5f9;
                    color: #64748b;
                    font-weight: 600;
                }
            </style>

            <jsp:include page="/views/includes/footer.jsp" />
            <jsp:include page="/views/includes/std_scripts.jsp" />
        </body>

        </html>