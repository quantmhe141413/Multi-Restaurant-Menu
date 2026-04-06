<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Restaurant Application List" scope="request" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/views/includes/std_head.jsp" />
        <title>${pageTitle}</title>
    </head>
    <body>
        <jsp:include page="/views/includes/header.jsp" />

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="/views/includes/admin-sidebar.jsp" />

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

                    <c:url value="/admin/restaurant-applications" var="paginationUrl" scope="request">
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
                                            <option value="all" ${param.status == 'all' ? 'selected' : ''}>All</option>
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
                                            <th>License Image</th>
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
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty r.licenseFileUrl}">
                                                                    <c:set var="licSrc" value="${r.licenseFileUrl}" />
                                                                    <c:choose>
                                                                        <c:when test="${fn:startsWith(licSrc, 'http://') || fn:startsWith(licSrc, 'https://')}">
                                                                            <img src="${licSrc}" alt="License"
                                                                                 style="width: 80px; height: auto; border-radius: 6px;" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}${licSrc}" alt="License"
                                                                                 style="width: 80px; height: auto; border-radius: 6px;" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No Image</span>
                                                                </c:otherwise>
                                                            </c:choose>
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

                    <c:set var="paginationTotal" value="${totalRestaurants}" scope="request" />
                    <c:set var="paginationLabel" value="restaurants" scope="request" />
                    <jsp:include page="/views/includes/admin-pagination.jsp" />
                </main>
            </div>
        </div>

        <jsp:include page="/views/includes/footer.jsp" />
    </body>
</html>
