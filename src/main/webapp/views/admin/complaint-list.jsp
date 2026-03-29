<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Complaint Management" scope="request" />
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
                    <h1><i class="fas fa-triangle-exclamation text-primary"></i> Complaint Management</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Complaint Management</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <c:url value="/admin/complaints" var="paginationUrl" scope="request">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.status}">
                    <c:param name="status" value="${param.status}" />
                </c:if>
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
                <c:if test="${not empty param.from}">
                    <c:param name="from" value="${param.from}" />
                </c:if>
                <c:if test="${not empty param.to}">
                    <c:param name="to" value="${param.to}" />
                </c:if>
            </c:url>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/complaints" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-toggle-on"></i> Status</label>
                                <select class="form-select" name="status">
                                    <option value="InProgress" ${param.status == 'InProgress' ? 'selected' : ''}>InProgress</option>
                                    <option value="Resolved" ${param.status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-calendar"></i> From</label>
                                <input id="complaintFromDate" class="form-control" type="date" name="from" value="${param.from}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-calendar"></i> To</label>
                                <input id="complaintToDate" class="form-control" type="date" name="to" value="${param.to}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted small mb-1"><i class="fas fa-search"></i> Search</label>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Search by description, customer, restaurant, ID..." value="${param.search}">
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter"></i> Apply Filters
                                </button>
                            </div>
                        </div>
                    </form>

                    <script>
                        (function () {
                            const fromEl = document.getElementById('complaintFromDate');
                            const toEl = document.getElementById('complaintToDate');
                            if (!fromEl || !toEl) return;

                            function parseDate(value) {
                                // value format: yyyy-MM-dd (from input[type="date"])
                                if (!value) return null;
                                const d = new Date(value + 'T00:00:00');
                                return isNaN(d.getTime()) ? null : d;
                            }

                            function swapIfNeeded() {
                                const fromVal = fromEl.value;
                                const toVal = toEl.value;

                                const fromDate = parseDate(fromVal);
                                const toDate = parseDate(toVal);
                                if (!fromDate || !toDate) return;

                                // If From > To then swap
                                if (fromDate.getTime() > toDate.getTime()) {
                                    fromEl.value = toVal;
                                    toEl.value = fromVal;
                                }
                            }

                            fromEl.addEventListener('change', swapIfNeeded);
                            toEl.addEventListener('change', swapIfNeeded);
                        })();
                    </script>
                </div>
            </div>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>ID</th>
                                    <th>Created</th>
                                    <th>Restaurant</th>
                                    <th>Customer</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty complaints}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">No complaints found</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="cpl" items="${complaints}">
                                            <tr>
                                                <td>${cpl.complaintID}</td>
                                                <td>${cpl.createdAt}</td>
                                                <td>
                                                    <strong>${cpl.restaurantName}</strong>
                                                    <div class="text-muted small">Order #${cpl.orderID}</div>
                                                </td>
                                                <td>
                                                    <div><strong>${cpl.customerName}</strong></div>
                                                    <div class="text-muted small">${cpl.customerEmail}</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty cpl.description and cpl.description.length() > 80}">
                                                            ${cpl.description.substring(0, 80)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${cpl.description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary">${cpl.status}</span>
                                                </td>
                                                <td>
                                                    <c:url value="/admin/complaints" var="detailUrl">
                                                        <c:param name="action" value="detail" />
                                                        <c:param name="id" value="${cpl.complaintID}" />
                                                    </c:url>
                                                    <a class="btn btn-sm btn-primary" href="${detailUrl}" title="View Details">
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

            <c:set var="paginationTotal" value="${totalComplaints}" scope="request" />
            <c:set var="paginationLabel" value="complaints" scope="request" />
            <jsp:include page="/views/includes/admin-pagination.jsp" />

        </main>
    </div>
</div>

<jsp:include page="/views/includes/footer.jsp" />
<jsp:include page="/views/includes/std_scripts.jsp" />
</body>
</html>
