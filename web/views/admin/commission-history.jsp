<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Commission History" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header">
                <h1><i class="fas fa-clock-rotate-left text-primary"></i> Commission History</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item active">Commission History</li>
                    </ol>
                </nav>
            </div>

            <c:if test="${not historyTableExists}">
                <div class="alert alert-warning" role="alert">
                    Commission history table is not found. Please run the SQL script to create <strong>RestaurantCommissionHistory</strong>.
                </div>
            </c:if>

            <c:url value="/admin/commission-history" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.restaurant}">
                    <c:param name="restaurant" value="${param.restaurant}" />
                </c:if>
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
            </c:url>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/commission-history" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-4">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-store"></i> Restaurant</label>
                                <select class="form-select" name="restaurant">
                                    <option value="" ${empty param.restaurant ? 'selected' : ''}>All Restaurants</option>
                                    <c:forEach var="r" items="${restaurants}">
                                        <option value="${r.restaurantId}" ${param.restaurant == r.restaurantId ? 'selected' : ''}>${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-search"></i> Search</label>
                                <input type="text" class="form-control" name="search" value="${param.search}"
                                       placeholder="Search by restaurant name or admin name/email...">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label text-muted small mb-1 d-block">&nbsp;</label>
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter"></i> Apply
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
                                    <th>History ID</th>
                                    <th>Restaurant</th>
                                    <th>Old Rate</th>
                                    <th>New Rate</th>
                                    <th>Changed By</th>
                                    <th>Reason</th>
                                    <th>Changed At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty history}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">No commission history found</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td><strong>#${h.historyId}</strong></td>
                                                <td>
                                                    <strong>${h.restaurantName}</strong>
                                                    <div class="text-muted small">ID: ${h.restaurantId}</div>
                                                </td>
                                                <td>${h.oldRate}</td>
                                                <td><strong>${h.newRate}</strong></td>
                                                <td>
                                                    <strong>${h.changedByName}</strong>
                                                    <div class="text-muted small">ID: ${h.changedBy}</div>
                                                </td>
                                                <td>${h.reason}</td>
                                                <td>${h.changedAt}</td>
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
                        <small>Page ${currentPage} of ${totalPages} (Total: ${totalHistory} changes)</small>
                    </div>
                </nav>
            </c:if>

        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
