<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="System Dashboard" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header">
                <h1><i class="fas fa-chart-line text-primary"></i> System Dashboard</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item active">System Dashboard</li>
                    </ol>
                </nav>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Total Restaurants</div>
                                    <div class="h3 mb-0"><strong>${totalRestaurants}</strong></div>
                                </div>
                                <div class="text-primary"><i class="fas fa-store fa-2x"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Pending</div>
                                    <div class="h3 mb-0"><strong>${pendingRestaurants}</strong></div>
                                </div>
                                <div class="text-warning"><i class="fas fa-hourglass-half fa-2x"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Approved</div>
                                    <div class="h3 mb-0"><strong>${approvedRestaurants}</strong></div>
                                </div>
                                <div class="text-success"><i class="fas fa-check-circle fa-2x"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Rejected</div>
                                    <div class="h3 mb-0"><strong>${rejectedRestaurants}</strong></div>
                                </div>
                                <div class="text-danger"><i class="fas fa-times-circle fa-2x"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Total Orders (Completed)</div>
                                    <div class="h3 mb-0"><strong>${totalOrders}</strong></div>
                                </div>
                                <div class="text-info"><i class="fas fa-receipt fa-2x"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Total Revenue (Completed)</div>
                                    <div class="h3 mb-0"><strong>${totalRevenue}</strong></div>
                                </div>
                                <div class="text-success"><i class="fas fa-sack-dollar fa-2x"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0"><i class="fas fa-ranking-star"></i> Top Restaurants (Revenue)</h4>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>Restaurant ID</th>
                                    <th>Name</th>
                                    <th>Total Orders</th>
                                    <th>Total Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty topRestaurants}">
                                        <tr>
                                            <td colspan="4" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">No analytics data</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${topRestaurants}">
                                            <tr>
                                                <td><strong>#${r.restaurantId}</strong></td>
                                                <td>${r.restaurantName}</td>
                                                <td>${r.totalOrders}</td>
                                                <td>${r.totalRevenue}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
