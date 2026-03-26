<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Commission History" scope="request" />
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

            <c:url value="/admin/commission-history" var="paginationUrl" scope="request">
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

            <%-- Pagination --%>
            <c:set var="paginationTotal" value="${totalHistory}" scope="request" />
            <c:set var="paginationLabel" value="changes" scope="request" />
            <jsp:include page="/views/includes/admin-pagination.jsp" />

        </main>
    </div>
</div>

<jsp:include page="/views/includes/footer.jsp" />
</body>
</html>
