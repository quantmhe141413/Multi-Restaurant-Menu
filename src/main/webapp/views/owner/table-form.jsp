<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="isEdit" value="${formAction == 'edit'}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Table' : 'Add New Table'}" scope="request" />
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
            <jsp:include page="/views/includes/restaurant-sidebar.jsp" />

            <main class="col-md-9 col-lg-10 main-content">
                <div class="page-header">
                    <h1>
                        <i class="fas fa-chair text-primary"></i>
                        ${isEdit ? 'Edit Table' : 'Add New Table'}
                    </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/owner/tables">Restaurant Tables</a>
                            </li>
                            <li class="breadcrumb-item active">${isEdit ? 'Edit Table' : 'Add New Table'}</li>
                        </ol>
                    </nav>
                </div>

                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">

                                <!-- Inline error from controller -->
                                <c:if test="${not empty formError}">
                                    <div class="alert alert-danger" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>${formError}
                                    </div>
                                </c:if>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/owner/tables"
                                      novalidate
                                      onsubmit="return validateForm()">
                                    <input type="hidden" name="action" value="${formAction}" />
                                    <c:if test="${isEdit}">
                                        <input type="hidden" name="tableId" value="${table.tableID}" />
                                    </c:if>

                                    <!-- Table Number -->
                                    <div class="mb-3">
                                        <label for="tableNumber" class="form-label fw-semibold">
                                            Table Number <span class="text-danger">*</span>
                                        </label>
                                        <input type="text"
                                               id="tableNumber"
                                               name="tableNumber"
                                               class="form-control"
                                               placeholder="e.g. T01, A1, VIP-1"
                                               value="${not empty inputTableNumber ? inputTableNumber : (isEdit ? table.tableNumber : '')}"
                                               maxlength="20"
                                               required />
                                        <div class="form-text text-muted">Max 20 characters.</div>
                                    </div>

                                    <!-- Capacity -->
                                    <div class="mb-4">
                                        <label for="capacity" class="form-label fw-semibold">
                                            Capacity (guests) <span class="text-danger">*</span>
                                        </label>
                                        <input type="number"
                                               id="capacity"
                                               name="capacity"
                                               class="form-control"
                                               placeholder="e.g. 4"
                                               value="${not empty inputCapacity ? inputCapacity : (isEdit ? table.capacity : '2')}"
                                               min="1"
                                               max="100"
                                               required />
                                        <div class="form-text text-muted">Minimum 1 guest.</div>
                                    </div>

                                    <!-- Note: status is managed by staff -->
                                    <c:if test="${isEdit}">
                                        <div class="alert alert-info py-2 mb-4">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Table status (<strong>${table.tableStatus}</strong>) is managed automatically by staff operations.
                                        </div>
                                    </c:if>

                                    <!-- Buttons -->
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>
                                            ${isEdit ? 'Save Changes' : 'Add Table'}
                                        </button>
                                        <a href="${pageContext.request.contextPath}/owner/tables"
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i> Cancel
                                        </a>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <jsp:include page="/views/includes/footer.jsp" />

    <script>
        function validateForm() {
            const tableNumber = document.getElementById('tableNumber').value.trim();
            const capacity = parseInt(document.getElementById('capacity').value);

            if (!tableNumber) {
                alert('Please enter a table number.');
                document.getElementById('tableNumber').focus();
                return false;
            }
            if (isNaN(capacity) || capacity < 1) {
                alert('Capacity must be at least 1.');
                document.getElementById('capacity').focus();
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
