<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="System Report" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-file-lines text-primary"></i> System Report</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">System Report</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/system-report" method="GET">
                        <input type="hidden" name="action" value="view">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-calendar"></i> From</label>
                                <input class="form-control" type="date" name="from" value="${from}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-calendar"></i> To</label>
                                <input class="form-control" type="date" name="to" value="${to}">
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary w-100" type="submit">
                                    <i class="fas fa-filter"></i> Apply
                                </button>
                            </div>
                            <div class="col-md-3">
                                <c:url value="/admin/system-report" var="exportUrl">
                                    <c:param name="action" value="export" />
                                    <c:param name="from" value="${from}" />
                                    <c:param name="to" value="${to}" />
                                </c:url>
                                <a class="btn btn-success w-100" href="${exportUrl}">
                                    <i class="fas fa-file-csv"></i> Export CSV
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <div class="text-muted small">Total Orders</div>
                            <div class="h3 mb-0">${totalOrders}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <div class="text-muted small">Completed Orders</div>
                            <div class="h3 mb-0">${completedOrders}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <div class="text-muted small">Revenue</div>
                            <div class="h3 mb-0">
                                <fmt:formatNumber value="${revenue}" type="number" maxFractionDigits="2" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <div class="text-muted small">New Complaints</div>
                            <div class="h3 mb-0">${newComplaints}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="card text-center">
                        <div class="card-body">
                            <div class="text-muted small">New Restaurants</div>
                            <div class="h4 mb-0">${newRestaurants}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center">
                        <div class="card-body">
                            <div class="text-muted small">New Users</div>
                            <div class="h4 mb-0">${newUsers}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>Date</th>
                                    <th>Total Orders</th>
                                    <th>Completed Orders</th>
                                    <th>Revenue</th>
                                    <th>New Restaurants</th>
                                    <th>New Users</th>
                                    <th>New Complaints</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty rows}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">No data found</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${rows}">
                                            <tr>
                                                <td>${r.reportDate}</td>
                                                <td>${r.totalOrders}</td>
                                                <td>${r.completedOrders}</td>
                                                <td>
                                                    <fmt:formatNumber value="${r.revenue}" type="number" maxFractionDigits="2" />
                                                </td>
                                                <td>${r.newRestaurants}</td>
                                                <td>${r.newUsers}</td>
                                                <td>${r.newComplaints}</td>
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
