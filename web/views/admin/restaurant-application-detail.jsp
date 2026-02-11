<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Restaurant Application Detail" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-file-alt text-primary"></i> Restaurant Application Detail</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/restaurant-applications?action=list">Restaurant Applications</a></li>
                            <li class="breadcrumb-item active">Detail</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <c:url value="/admin/restaurant-applications" var="backUrl">
                        <c:param name="action" value="list" />
                        <c:if test="${not empty param.status}">
                            <c:param name="status" value="${param.status}" />
                        </c:if>
                        <c:if test="${not empty param.search}">
                            <c:param name="search" value="${param.search}" />
                        </c:if>
                        <c:if test="${not empty param.page}">
                            <c:param name="page" value="${param.page}" />
                        </c:if>
                    </c:url>
                    <a href="${backUrl}" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-store"></i> Restaurant Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">Restaurant ID</div>
                                <div class="col-md-8"><strong>${restaurant.restaurantId}</strong></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">Name</div>
                                <div class="col-md-8"><strong>${restaurant.name}</strong></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">Address</div>
                                <div class="col-md-8">${restaurant.address}</div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">License Number</div>
                                <div class="col-md-8">${restaurant.licenseNumber}</div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">Commission Rate</div>
                                <div class="col-md-8">${restaurant.commissionRate}</div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">Delivery Fee</div>
                                <div class="col-md-8">${restaurant.deliveryFee}</div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 text-muted">Status</div>
                                <div class="col-md-8">
                                    <c:choose>
                                        <c:when test="${restaurant.status == 'Approved'}">
                                            <span class="badge bg-success">Approved</span>
                                        </c:when>
                                        <c:when test="${restaurant.status == 'Rejected'}">
                                            <span class="badge bg-danger">Rejected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mb-0">
                                <div class="col-md-4 text-muted">Created At</div>
                                <div class="col-md-8">${restaurant.createdAt}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-user"></i> Owner Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-4 text-muted">Owner ID</div>
                                <div class="col-8"><strong>${restaurant.ownerId}</strong></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-4 text-muted">Owner Name</div>
                                <div class="col-8"><strong>${restaurant.ownerName}</strong></div>
                            </div>
                            <div class="row mb-0">
                                <div class="col-4 text-muted">Owner Email</div>
                                <div class="col-8">${restaurant.ownerEmail}</div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-gavel"></i> Decision</h4>
                        </div>
                        <div class="card-body">
                            <c:if test="${restaurant.status != 'Pending'}">
                                <div class="alert alert-info mb-0" role="alert">
                                    This application has already been processed.
                                </div>
                            </c:if>

                            <c:if test="${restaurant.status == 'Pending'}">
                                <form action="${pageContext.request.contextPath}/admin/restaurant-applications" method="POST">
                                    <input type="hidden" name="id" value="${restaurant.restaurantId}">
                                    <input type="hidden" name="returnTo" value="detail">
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
                                        <label class="form-label text-muted small mb-1"><i class="fas fa-comment"></i> Reason <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="reason" rows="4" required
                                                  placeholder="Enter reason for approval or rejection..."></textarea>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" name="action" value="approve" class="btn btn-success flex-fill">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                        <button type="submit" name="action" value="reject" class="btn btn-danger flex-fill">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </div>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
