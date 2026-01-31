<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Coverage Zone Management" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />
<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-map-marked-alt text-primary"></i> Coverage Zone Management</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Coverage Zones</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/coverage-zone?action=add" class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Add New Zone
                    </a>
                </div>
            </div>

            <!-- Filter Card -->
            <c:url value="/coverage-zone" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.restaurant}">
                    <c:param name="restaurant" value="${param.restaurant}" />
                </c:if>
                <c:if test="${not empty param.status}">
                    <c:param name="status" value="${param.status}" />
                </c:if>
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
            </c:url>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/coverage-zone" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-store"></i> Restaurant</label>
                                <select class="form-select" name="restaurant">
                                    <option value="">All Restaurants</option>
                                    <c:forEach var="restaurant" items="${restaurants}">
                                        <option value="${restaurant.restaurantId}" 
                                                ${param.restaurant == restaurant.restaurantId.toString() ? 'selected' : ''}>
                                            ${restaurant.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-toggle-on"></i> Status</label>
                                <select class="form-select" name="status">
                                    <option value="">All Status</option>
                                    <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                    <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-search"></i> Search</label>
                                <input type="text" class="form-control" name="search" 
                                       placeholder="Search zone name..." value="${param.search}">
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

            <!-- Zones Table Card -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                            <tr>
                                <th>Zone ID</th>
                                <th>Restaurant</th>
                                <th>Zone Name</th>
                                <th>Zone Definition</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty zones}">
                                    <tr>
                                        <td colspan="7" class="text-center">No coverage zones found</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="zone" items="${zones}">
                                        <tr>
                                            <td>${zone.zoneId}</td>
                                            <td>
                                                <strong>${zone.restaurantName}</strong>
                                                <c:if test="${empty zone.restaurantName}">
                                                    <span class="text-muted">ID: ${zone.restaurantId}</span>
                                                </c:if>
                                            </td>
                                            <td>${zone.zoneName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${zone.zoneDefinition.length() > 50}">
                                                        ${zone.zoneDefinition.substring(0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${zone.zoneDefinition}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${zone.isActive}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${zone.createdAt}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/coverage-zone?action=edit&id=${zone.zoneId}" 
                                                   class="btn btn-sm btn-warning" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/coverage-zone?action=toggle&id=${zone.zoneId}" 
                                                   class="btn btn-sm btn-info" title="Toggle Status">
                                                    <i class="fas fa-toggle-on"></i>
                                                </a>
                                                <a href="#" onclick="confirmDelete(${zone.zoneId})" 
                                                   class="btn btn-sm btn-danger" title="Delete">
                                                    <i class="fas fa-trash"></i>
                                                </a>
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
                                <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" title="Previous">
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
                                        <a class="page-link" href="${paginationUrl}&page=${totalPages}">${totalPages}</a>
                                    </li>
                                </c:if>
                            </c:otherwise>
                        </c:choose>

                        <!-- Last Page -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" title="Next">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${totalPages}" title="Last Page">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                    <div class="text-center text-muted mt-2">
                        <small>Page ${currentPage} of ${totalPages} (Total: ${totalZones} zones)</small>
                    </div>
                </nav>
            </c:if>
        </main>
    </div>
</div>

<script>
    function confirmDelete(zoneId) {
        if (confirm('Are you sure you want to delete this coverage zone? This action cannot be undone if the zone is not associated with active delivery fees.')) {
            var contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/coverage-zone?action=delete&id=' + zoneId;
        }
    }
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
