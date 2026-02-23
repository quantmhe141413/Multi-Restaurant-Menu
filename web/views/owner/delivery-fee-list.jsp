<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <c:set var="pageTitle" value="Delivery Fee Management" scope="request" />
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

                <!-- Main Content -->
                <main class="col-md-9 col-lg-10 main-content">
                    <!-- Page Header -->
                    <div class="page-header d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="fas fa-dollar-sign text-primary"></i> Delivery Fee Management</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a>
                                    </li>
                                    <li class="breadcrumb-item active">Delivery Fees</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/delivery-fee?action=add"
                                class="btn btn-primary">
                                <i class="fas fa-plus-circle"></i> Add New Fee
                            </a>
                        </div>
                    </div>

                    <!-- Filter Card -->
                    <c:url value="/delivery-fee" var="paginationUrl">
                        <c:param name="action" value="list" />
                        <c:if test="${not empty param.feeType}">
                            <c:param name="feeType" value="${param.feeType}" />
                        </c:if>
                        <c:if test="${not empty param.zoneId}">
                            <c:param name="zoneId" value="${param.zoneId}" />
                        </c:if>
                    </c:url>

                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/delivery-fee" method="GET">
                                <input type="hidden" name="action" value="list">
                                <div class="row g-3 align-items-center">
                                    <div class="col-md-4">
                                        <label class="form-label text-muted small mb-1"><i class="fas fa-tag"></i> Fee
                                            Type</label>
                                        <select class="form-select" name="feeType">
                                            <option value="">All Fee Types</option>
                                            <option value="Flat" ${param.feeType=='Flat' ? 'selected' : '' }>Flat -
                                                Fixed Amount</option>
                                            <option value="PercentageOfOrder" ${param.feeType=='PercentageOfOrder'
                                                ? 'selected' : '' }>Percentage of Order</option>
                                            <option value="FreeAboveAmount" ${param.feeType=='FreeAboveAmount'
                                                ? 'selected' : '' }>Free Above Amount</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label text-muted small mb-1"><i
                                                class="fas fa-map-marked-alt"></i> Coverage Zone</label>
                                        <select class="form-select" name="zoneId">
                                            <option value="">All Coverage Zones</option>
                                            <c:forEach var="zone" items="${zones}">
                                                <option value="${zone.zoneId}" ${param.zoneId==zone.zoneId ? 'selected'
                                                    : '' }>
                                                    ${zone.restaurantName} - ${zone.zoneName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label text-muted small mb-1 d-block">&nbsp;</label>
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="fas fa-filter"></i> Apply Filters
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Fees Table Card -->
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                        <tr>
                                            <th>Fee ID</th>
                                            <th>Zone Name</th>
                                            <th>Fee Type</th>
                                            <th>Fee Value</th>
                                            <th>Min Order</th>
                                            <th>Max Order</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty fees}">
                                                <tr>
                                                    <td colspan="8" class="text-center py-5">
                                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                        <p class="text-muted">No delivery fees found</p>
                                                        <a href="${pageContext.request.contextPath}/delivery-fee?action=add"
                                                            class="btn btn-primary btn-sm">
                                                            <i class="fas fa-plus"></i> Add First Fee
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="fee" items="${fees}">
                                                    <tr>
                                                        <td><strong>#${fee.feeId}</strong></td>
                                                        <td>
                                                            <i class="fas fa-map-pin text-primary"></i>
                                                            <c:forEach var="zone" items="${zones}">
                                                                <c:if test="${zone.zoneId == fee.zoneId}">
                                                                    ${zone.zoneName}
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${fee.feeType == 'Flat'}">
                                                                    <span class="badge"
                                                                        style="background: linear-gradient(135deg, #3b82f6, #2563eb); color: white;">
                                                                        <i class="fas fa-dollar-sign"></i> Flat
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${fee.feeType == 'PercentageOfOrder'}">
                                                                    <span class="badge"
                                                                        style="background: linear-gradient(135deg, #06b6d4, #0891b2); color: white;">
                                                                        <i class="fas fa-percent"></i> Percentage
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge"
                                                                        style="background: linear-gradient(135deg, #10b981, #059669); color: white;">
                                                                        <i class="fas fa-gift"></i> Free Above
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <strong>
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${fee.feeType == 'PercentageOfOrder'}">
                                                                        ${fee.feeValue}%
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        $${fee.feeValue}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </strong>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${empty fee.minOrderAmount}">
                                                                    <span class="text-muted">-</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    $${fee.minOrderAmount}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${empty fee.maxOrderAmount}">
                                                                    <span class="text-muted">-</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    $${fee.maxOrderAmount}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${fee.isActive}">
                                                                    <span class="badge bg-success">
                                                                        <i class="fas fa-check-circle"></i> Active
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">
                                                                        <i class="fas fa-times-circle"></i> Inactive
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/delivery-fee?action=edit&id=${fee.feeId}"
                                                                    class="btn btn-sm btn-warning" title="Edit">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/delivery-fee?action=toggle&id=${fee.feeId}"
                                                                    class="btn btn-sm btn-info" title="Toggle Status">
                                                                    <i class="fas fa-toggle-on"></i>
                                                                </a>
                                                                <a href="#" onclick="confirmDelete(${fee.feeId})"
                                                                    class="btn btn-sm btn-danger" title="Delete">
                                                                    <i class="fas fa-trash"></i>
                                                                </a>
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

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <!-- First Page -->
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${paginationUrl}&page=1" title="First Page">
                                            <i class="fas fa-angle-double-left"></i>
                                        </a>
                                    </li>
                                    <li class="page-item">
                                        <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}"
                                            title="Previous">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <!-- Page Numbers with smart pagination -->
                                <c:choose>
                                    <c:when test="${totalPages <= 7}">
                                        <!-- Show all pages if total <= 7 -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Smart pagination for many pages -->
                                        <c:if test="${currentPage > 3}">
                                            <li class="page-item">
                                                <a class="page-link" href="${paginationUrl}&page=1">1</a>
                                            </li>
                                            <c:if test="${currentPage > 4}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:if>
                                        </c:if>

                                        <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}"
                                            end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"
                                            var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages - 2}">
                                            <c:if test="${currentPage < totalPages - 3}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:if>
                                            <li class="page-item">
                                                <a class="page-link"
                                                    href="${paginationUrl}&page=${totalPages}">${totalPages}</a>
                                            </li>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Last Page -->
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}"
                                            title="Next">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                    <li class="page-item">
                                        <a class="page-link" href="${paginationUrl}&page=${totalPages}"
                                            title="Last Page">
                                            <i class="fas fa-angle-double-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                            <div class="text-center text-muted mt-2">
                                <small>Page ${currentPage} of ${totalPages} (Total: ${totalFees} fees)</small>
                            </div>
                        </nav>
                    </c:if>
                </main>
            </div>
        </div>

        <script>
            function confirmDelete(feeId) {
                if (confirm('Are you sure you want to delete this delivery fee? This action cannot be undone if the fee is not applied to ongoing orders.')) {
                    var contextPath = '${pageContext.request.contextPath}';
                    window.location.href = contextPath + '/delivery-fee?action=delete&id=' + feeId;
                }
            }
        </script>

        <jsp:include page="/views/includes/footer.jsp" />
        <jsp:include page="/views/includes/std_scripts.jsp" />
    </body>

    </html>