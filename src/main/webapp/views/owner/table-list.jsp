<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Restaurant Tables" scope="request" />
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
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h1><i class="fas fa-chair text-primary"></i> Restaurant Tables</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                                <li class="breadcrumb-item active">Restaurant Tables</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/owner/tables?action=add" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i> Add New Table
                        </a>
                    </div>
                </div>

                <!-- Flash messages -->
                <c:if test="${not empty sessionScope.flashSuccess}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.flashSuccess}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("flashSuccess"); %>
                </c:if>
                <c:if test="${not empty sessionScope.flashError}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.flashError}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("flashError"); %>
                </c:if>

                <!-- Tables list -->
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">#</th>
                                        <th>Table Number</th>
                                        <th>Capacity</th>
                                        <th>Status</th>
                                        <th>Active</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty tables}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5">
                                                    <i class="fas fa-chair fa-3x text-muted mb-3 d-block"></i>
                                                    <p class="text-muted">No tables found. Start by adding one!</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="t" items="${tables}" varStatus="s">
                                                <tr class="${t.active ? '' : 'table-secondary text-muted'}">
                                                    <td class="ps-4">${s.index + 1}</td>
                                                    <td>
                                                        <strong>${t.tableNumber}</strong>
                                                    </td>
                                                    <td>${t.capacity} guests</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${!t.active}">
                                                                <span class="badge bg-secondary">Inactive</span>
                                                            </c:when>
                                                            <c:when test="${t.tableStatus == 'Available'}">
                                                                <span class="badge bg-success">Available</span>
                                                            </c:when>
                                                            <c:when test="${t.tableStatus == 'Occupied'}">
                                                                <span class="badge bg-warning text-dark">Occupied</span>
                                                            </c:when>
                                                            <c:when test="${t.tableStatus == 'Reserved'}">
                                                                <span class="badge bg-info text-dark">Reserved</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${t.tableStatus}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${t.active}">
                                                                <i class="fas fa-check-circle text-success"></i> Active
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-times-circle text-secondary"></i> Inactive
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end pe-4">
                                                        <!-- Edit button -->
                                                        <a href="${pageContext.request.contextPath}/owner/tables?action=edit&tableId=${t.tableID}"
                                                           class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </a>
                                                        <!-- Deactivate / Activate toggle -->
                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/owner/tables"
                                                              class="d-inline"
                                                              onsubmit="return confirmToggle(${t.active}, '${t.tableNumber}')">
                                                            <input type="hidden" name="tableId" value="${t.tableID}" />
                                                            <c:choose>
                                                                <c:when test="${t.active}">
                                                                    <input type="hidden" name="action" value="deactivate" />
                                                                    <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                                        <i class="fas fa-eye-slash"></i> Deactivate
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <input type="hidden" name="action" value="activate" />
                                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                                        <i class="fas fa-eye"></i> Activate
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </form>
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
                <!-- Summary -->
                <c:if test="${not empty tables}">
                    <div class="mt-3 text-muted small">
                        Total: ${tables.size()} table(s)
                    </div>
                </c:if>

            </main>
        </div>
    </div>

    <jsp:include page="/views/includes/footer.jsp" />

    <script>
        function confirmToggle(isActive, tableNumber) {
            if (isActive) {
                return confirm('Deactivate table "' + tableNumber + '"? It will be hidden from the staff view.');
            }
            return true;
        }
    </script>
</body>
</html>
