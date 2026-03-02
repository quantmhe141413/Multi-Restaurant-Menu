<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Commission Configuration" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-percent text-primary"></i> Commission Configuration</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Commission Configuration</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <c:if test="${not empty editRestaurant}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-pen-to-square"></i> Update Commission Rate</h4>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="text-muted small">Restaurant</div>
                                <div><strong>${editRestaurant.name}</strong></div>
                                <div class="text-muted small">Owner: ${editRestaurant.ownerName} (${editRestaurant.ownerEmail})</div>
                            </div>
                            <div class="col-md-6">
                                <form action="${pageContext.request.contextPath}/admin/commission" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${editRestaurant.restaurantId}">

                                    <c:if test="${not empty param.status}">
                                        <input type="hidden" name="status" value="${param.status}">
                                    </c:if>
                                    <c:if test="${not empty param.search}">
                                        <input type="hidden" name="search" value="${param.search}">
                                    </c:if>
                                    <c:if test="${not empty param.page}">
                                        <input type="hidden" name="page" value="${param.page}">
                                    </c:if>

                                    <div class="mb-3">
                                        <label class="form-label text-muted small mb-1">Commission Rate (0 - 100)</label>
                                        <input class="form-control" type="number" name="commissionRate" step="0.01" min="0" max="100"
                                               value="${editRestaurant.commissionRate}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label text-muted small mb-1">Reason <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="reason" rows="3" required
                                                  placeholder="Why are you changing this commission rate?"></textarea>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save
                                        </button>
                                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/commission?action=list">
                                            Cancel
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:url value="/admin/commission" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
            </c:url>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/commission" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-10">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-search"></i> Search</label>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Search by restaurant name, license, owner name/email..." value="${param.search}">
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

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>ID</th>
                                    <th>Restaurant</th>
                                    <th>Owner</th>
                                    <th>Status</th>
                                    <th>Commission Rate</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty restaurants}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">No restaurants found</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${restaurants}">
                                            <tr>
                                                <td>${r.restaurantId}</td>
                                                <td>
                                                    <strong>${r.name}</strong>
                                                    <div class="text-muted small">${r.licenseNumber}</div>
                                                </td>
                                                <td>
                                                    <div><strong>${r.ownerName}</strong></div>
                                                    <div class="text-muted small">${r.ownerEmail}</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.status == 'Approved'}">
                                                            <span class="badge bg-success">Approved</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'Rejected'}">
                                                            <span class="badge bg-danger">Rejected</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning text-dark">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <strong>${r.commissionRate}</strong>
                                                </td>
                                                <td>
                                                    <c:url value="/admin/commission" var="editUrl">
                                                        <c:param name="action" value="edit" />
                                                        <c:param name="id" value="${r.restaurantId}" />
                                                        <c:if test="${not empty param.search}">
                                                            <c:param name="search" value="${param.search}" />
                                                        </c:if>
                                                        <c:param name="page" value="${currentPage}" />
                                                    </c:url>
                                                    <a class="btn btn-sm btn-warning" href="${editUrl}" title="Edit Commission">
                                                        <i class="fas fa-edit"></i>
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

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
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

                        <c:choose>
                            <c:when test="${totalPages <= 7}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
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
                        <small>Page ${currentPage} of ${totalPages} (Total: ${totalRestaurants} restaurants)</small>
                    </div>
                </nav>
            </c:if>

        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
