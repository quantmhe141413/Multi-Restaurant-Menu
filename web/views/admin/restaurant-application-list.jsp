<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Restaurant Application List" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />
<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-store text-primary"></i> Restaurant Application List</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Restaurant Applications</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <c:url value="/admin/restaurant-applications" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.status}">
                    <c:param name="status" value="${param.status}" />
                </c:if>
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
            </c:url>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/restaurant-applications" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-toggle-on"></i> Status</label>
                                <select class="form-select" name="status">
                                    <option value="Pending" ${empty param.status || param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                    <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                </select>
                            </div>
                            <div class="col-md-7">
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
                                    <th>License</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty restaurants}">
                                        <tr>
                                            <td colspan="7" class="text-center">No restaurants found</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${restaurants}">
                                            <tr>
                                                <td>${r.restaurantId}</td>
                                                <td>
                                                    <strong>${r.name}</strong>
                                                    <div class="text-muted small">${r.address}</div>
                                                </td>
                                                <td>
                                                    <div><strong>${r.ownerName}</strong></div>
                                                    <div class="text-muted small">${r.ownerEmail}</div>
                                                    <c:if test="${empty r.ownerName and empty r.ownerEmail}">
                                                        <span class="text-muted">OwnerID: ${r.ownerId}</span>
                                                    </c:if>
                                                </td>
                                                <td>${r.licenseNumber}</td>
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
                                                <td>${r.createdAt}</td>
                                                <td>
                                                    <c:url value="/admin/restaurant-applications" var="detailUrl">
                                                        <c:param name="action" value="detail" />
                                                        <c:param name="id" value="${r.restaurantId}" />
                                                        <c:if test="${not empty param.status}">
                                                            <c:param name="status" value="${param.status}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.search}">
                                                            <c:param name="search" value="${param.search}" />
                                                        </c:if>
                                                        <c:param name="page" value="${currentPage}" />
                                                    </c:url>
                                                    <a href="${detailUrl}"
                                                       class="btn btn-sm btn-primary" title="View Details">
                                                        <i class="fas fa-eye"></i>
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
