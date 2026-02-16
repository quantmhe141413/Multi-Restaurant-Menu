<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Temporary Closure Management" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-door-closed text-primary"></i> Temporary Closure Management</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Temporary Closure</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/temporary-closure?action=add" class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Add Closure Period
                    </a>
                </div>
            </div>

            <!-- Active Closure Alert -->
            <c:if test="${not empty activeClosure}">
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    <h5 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Active Temporary Closure</h5>
                    <p class="mb-0">
                        <strong>Period:</strong> 
                        <fmt:formatDate value="${activeClosure.startDateTime}" pattern="yyyy-MM-dd HH:mm" /> - 
                        <fmt:formatDate value="${activeClosure.endDateTime}" pattern="yyyy-MM-dd HH:mm" />
                    </p>
                    <c:if test="${not empty activeClosure.reason}">
                        <p class="mb-0"><strong>Reason:</strong> ${activeClosure.reason}</p>
                    </c:if>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Closures Table Card -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>ID</th>
                                    <th>Start Date/Time</th>
                                    <th>End Date/Time</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty closures}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5">
                                                <i class="fas fa-calendar-check fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">No temporary closures configured</p>
                                                <a href="${pageContext.request.contextPath}/temporary-closure?action=add" 
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fas fa-plus"></i> Add First Closure
                                                </a>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="closure" items="${closures}">
                                            <tr>
                                                <td><strong>#${closure.closureId}</strong></td>
                                                <td>
                                                    <i class="fas fa-calendar-day text-primary"></i>
                                                    <fmt:formatDate value="${closure.startDateTime}" pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td>
                                                    <i class="fas fa-calendar-day text-danger"></i>
                                                    <fmt:formatDate value="${closure.endDateTime}" pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty closure.reason}">
                                                            ${closure.reason}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${closure.isActive}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-door-closed"></i> Active
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="fas fa-door-open"></i> Inactive
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/temporary-closure?action=edit&id=${closure.closureId}" 
                                                           class="btn btn-sm btn-warning" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/temporary-closure?action=toggle&id=${closure.closureId}" 
                                                           class="btn btn-sm btn-info" title="Toggle Status">
                                                            <i class="fas fa-toggle-on"></i>
                                                        </a>
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

            <!-- Business Rules Card -->
            <div class="card mt-4">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-info-circle text-info"></i> Business Rules</h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>During active temporary closure, the system does not accept new orders</li>
                        <li>Closure period must have valid start and end timestamps</li>
                        <li>End date/time must be after start date/time</li>
                        <li>Temporary closure overrides normal business hours</li>
                        <li>Only one active closure should be in effect at a time</li>
                    </ul>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
