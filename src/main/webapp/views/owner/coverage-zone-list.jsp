<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Coverage Zone Management" scope="request" />
<!DOCTYPE html>
<html lang="en">

<head>
    <title>${pageTitle} - FoodieExpress</title>
    <jsp:include page="/views/includes/std_head.jsp" />
    <style>
    .btn-xs { padding: 2px 7px; font-size: 0.75rem; }
    .fee-accordion-row td { background-color: #f8f9fe; }
    .zone-row:hover { background-color: #f0f2ff; cursor: pointer; }
    .toggle-icon.open { transform: rotate(90deg); }
    </style>
</head>

<body>
    <jsp:include page="/views/includes/header.jsp" />
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="/views/includes/restaurant-sidebar.jsp" />

                <!-- Main Content -->
                <main class="col-md-9 col-lg-10 main-content">
                    <!-- Page Header -->
                    <div class="page-header d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="fas fa-map-marked-alt text-primary"></i> Coverage Zone Management</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a>
                                    </li>
                                    <li class="breadcrumb-item active">Coverage Zones</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/coverage-zone?action=add"
                                class="btn btn-primary">
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
                                        <label class="form-label text-muted small mb-1"><i class="fas fa-store"></i>
                                            Restaurant</label>
                                        <select class="form-select" name="restaurant">
                                            <option value="">All Restaurants</option>
                                            <c:forEach var="restaurant" items="${restaurants}">
                                                <option value="${restaurant.restaurantId}"
                                                    ${param.restaurant==restaurant.restaurantId.toString() ? 'selected'
                                                    : '' }>
                                                    ${restaurant.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label text-muted small mb-1"><i class="fas fa-toggle-on"></i>
                                            Status</label>
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="active" ${param.status=='active' ? 'selected' : '' }>Active
                                            </option>
                                            <option value="inactive" ${param.status=='inactive' ? 'selected' : '' }>
                                                Inactive</option>
                                        </select>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label text-muted small mb-1"><i class="fas fa-search"></i>
                                            Search</label>
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

                    <!-- Zones Table Card with Inline Fee Accordion -->
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="zoneTable">
                                    <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                        <tr>
                                            <th style="width:36px;"></th>
                                            <th>Zone</th>
                                            <th>Zone Definition</th>
                                            <th>Fees</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty zones}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-4 text-muted">No coverage zones found</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="zone" items="${zones}">
                                                    <%-- Count fees for this zone --%>
                                                    <c:set var="zoneFees" value="${zoneFeeMap[zone.zoneId]}" />
                                                    <c:set var="feeCount" value="${empty zoneFees ? 0 : zoneFees.size()}" />

                                                    <%-- Zone main row --%>
                                                    <tr class="zone-row" data-zone-id="${zone.zoneId}">
                                                        <td class="text-center align-middle">
                                                            <button class="btn btn-sm btn-link p-0 text-secondary toggle-fees-btn"
                                                                    data-target="fees-${zone.zoneId}"
                                                                    title="Show/Hide Fees">
                                                                <i class="fas fa-chevron-right toggle-icon" style="font-size:0.75rem;transition:transform .2s;"></i>
                                                            </button>
                                                        </td>
                                                        <td>
                                                            <div class="fw-semibold">${zone.zoneName}</div>
                                                            <c:if test="${not empty zone.restaurantName}">
                                                                <small class="text-muted">${zone.restaurantName}</small>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-muted small">
                                                            <c:choose>
                                                                <c:when test="${not empty zone.zoneDefinition and zone.zoneDefinition.length() > 50}">
                                                                    ${zone.zoneDefinition.substring(0, 50)}...
                                                                </c:when>
                                                                <c:otherwise>${zone.zoneDefinition}</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${feeCount > 0 ? 'bg-primary' : 'bg-light text-muted border'}">
                                                                <i class="fas fa-dollar-sign me-1"></i>${feeCount} fee${feeCount != 1 ? 's' : ''}
                                                            </span>
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
                                                        <td class="small text-muted">${zone.createdAt}</td>
                                                        <td>
                                                            <div class="d-flex gap-1">
                                                                <a href="${pageContext.request.contextPath}/coverage-zone?action=edit&id=${zone.zoneId}"
                                                                   class="btn btn-sm btn-outline-warning" title="Edit Zone">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <button type="button"
                                                                        class="btn btn-sm btn-outline-secondary toggle-status-btn"
                                                                        title="${zone.isActive ? 'Deactivate' : 'Activate'} Zone"
                                                                        data-href="${pageContext.request.contextPath}/coverage-zone?action=toggle&id=${zone.zoneId}"
                                                                        data-zone-name="${zone.zoneName}"
                                                                        data-current-status="${zone.isActive}">
                                                                    <i class="fas ${zone.isActive ? 'fa-toggle-on text-success' : 'fa-toggle-off text-muted'}"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>

                                                    <%-- Accordion: inline fee rows --%>
                                                    <tr class="fee-accordion-row d-none" id="fees-${zone.zoneId}">
                                                        <td colspan="7" class="p-0 border-top-0">
                                                            <div class="bg-light border-start border-4 border-primary ps-3 py-3 pe-3">

                                                                <%-- Fee table --%>
                                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                                    <span class="fw-semibold text-primary small">
                                                                        <i class="fas fa-tags me-1"></i>Fees for ${zone.zoneName}
                                                                    </span>
                                                                    <a href="${pageContext.request.contextPath}/delivery-fee?action=add&zoneId=${zone.zoneId}"
                                                                       class="btn btn-sm btn-primary">
                                                                        <i class="fas fa-plus"></i> Add Fee
                                                                    </a>
                                                                </div>

                                                                <c:choose>
                                                                    <c:when test="${empty zoneFees}">
                                                                        <p class="text-muted small mb-0">No fees configured for this zone yet.</p>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <table class="table table-sm table-bordered bg-white mb-0">
                                                                            <thead class="table-light">
                                                                                <tr>
                                                                                    <th>Fee Type</th>
                                                                                    <th>Value</th>
                                                                                    <th>Min Order</th>
                                                                                    <th>Max Order</th>
                                                                                    <th>Status</th>
                                                                                    <th>Actions</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <c:forEach var="fee" items="${zoneFees}">
                                                                                    <tr>
                                                                                        <td class="small">${fee.feeType}</td>
                                                                                        <td class="small fw-semibold">${fee.feeValue}</td>
                                                                                        <td class="small text-muted">
                                                                                            <c:choose>
                                                                                                <c:when test="${fee.minOrderAmount != null}">${fee.minOrderAmount}</c:when>
                                                                                                <c:otherwise>—</c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td class="small text-muted">
                                                                                            <c:choose>
                                                                                                <c:when test="${fee.maxOrderAmount != null}">${fee.maxOrderAmount}</c:when>
                                                                                                <c:otherwise>—</c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span class="badge ${fee.isActive ? 'bg-success' : 'bg-secondary'} badge-sm">
                                                                                                ${fee.isActive ? 'Active' : 'Inactive'}
                                                                                            </span>
                                                                                        </td>
                                                                                        <td>
                                                                                            <div class="d-flex gap-1">
                                                                                                <a href="${pageContext.request.contextPath}/delivery-fee?action=edit&id=${fee.feeId}"
                                                                                                   class="btn btn-xs btn-outline-warning" title="Edit Fee">
                                                                                                    <i class="fas fa-edit"></i>
                                                                                                </a>
                                                                                                <a href="${pageContext.request.contextPath}/coverage-zone?action=fees&id=${zone.zoneId}#history-${fee.feeId}"
                                                                                                   class="btn btn-xs btn-outline-info" title="View History">
                                                                                                    <i class="fas fa-history"></i>
                                                                                                </a>
                                                                                                <a href="${pageContext.request.contextPath}/delivery-fee?action=toggle&id=${fee.feeId}&returnZone=${zone.zoneId}"
                                                                                                   class="btn btn-xs btn-outline-secondary" title="Toggle Fee Status">
                                                                                                    <i class="fas ${fee.isActive ? 'fa-toggle-on text-success' : 'fa-toggle-off'}"></i>
                                                                                                </a>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </tbody>
                                                                        </table>
                                                                    </c:otherwise>
                                                                </c:choose>
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

                    <!-- Toggle Status Confirm Modal -->
                    <div class="modal fade" id="toggleStatusModal" tabindex="-1">
                        <div class="modal-dialog modal-sm">
                            <div class="modal-content">
                                <div class="modal-header py-2">
                                    <h6 class="modal-title"><i class="fas fa-toggle-on"></i> Confirm Status Change</h6>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body small" id="toggleStatusBody"></div>
                                <div class="modal-footer py-2">
                                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <a id="toggleStatusConfirmBtn" href="#" class="btn btn-sm btn-primary">Confirm</a>
                                </div>
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
                                <small>Page ${currentPage} of ${totalPages} (Total: ${totalZones} zones)</small>
                            </div>
                        </nav>
                    </c:if>
                </main>
            </div>
        </div>

        <script>
        // Accordion toggle: expand/collapse fee rows inline
        document.querySelectorAll('.toggle-fees-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const targetId = this.getAttribute('data-target');
                const row = document.getElementById(targetId);
                const icon = this.querySelector('.toggle-icon');
                if (row.classList.contains('d-none')) {
                    row.classList.remove('d-none');
                    icon.classList.add('open');
                } else {
                    row.classList.add('d-none');
                    icon.classList.remove('open');
                }
            });
        });

        // Also expand when clicking anywhere on the zone row
        document.querySelectorAll('.zone-row').forEach(function(row) {
            row.addEventListener('click', function(e) {
                // Don't trigger if clicking a button/link inside the row
                if (e.target.closest('a, button')) return;
                const btn = this.querySelector('.toggle-fees-btn');
                if (btn) btn.click();
            });
        });

        // Toggle status with confirm modal
        document.querySelectorAll('.toggle-status-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const href = this.getAttribute('data-href');
                const name = this.getAttribute('data-zone-name');
                const isActive = this.getAttribute('data-current-status') === 'true';
                const action = isActive ? 'deactivate' : 'activate';
                document.getElementById('toggleStatusBody').textContent =
                    'Are you sure you want to ' + action + ' zone "' + name + '"?';
                document.getElementById('toggleStatusConfirmBtn').href = href;
                new bootstrap.Modal(document.getElementById('toggleStatusModal')).show();
            });
        });
        </script>

        <jsp:include page="/WEB-INF/includes/footer.jsp" />