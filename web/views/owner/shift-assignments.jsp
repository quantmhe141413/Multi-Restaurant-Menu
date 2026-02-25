<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Shift Assignments" scope="request" />
<jsp:useBean id="currentDate" class="java.util.Date"/>
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-user-clock text-primary"></i> Shift Assignments</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Shift Assignments</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/shift-management?action=add-assignment" 
                       class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Assign Shift
                    </a>
                </div>
            </div>

            <!-- Date Filter Card -->
            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/shift-management" method="GET">
                        <input type="hidden" name="action" value="assignments">
                        <div class="row align-items-end">
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-calendar-day"></i> Filter by Date (Optional)
                                </label>
                                <input type="date" class="form-control" name="date" 
                                       value="<c:if test='${selectedDate != null}'><fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd' /></c:if>">
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter"></i> Apply Filter
                                </button>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/shift-management?action=assignments" 
                                   class="btn btn-secondary w-100">
                                    <i class="fas fa-list"></i> Show All
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Selected Date Info -->
            <div class="alert alert-info" role="alert">
                <i class="fas fa-calendar-check"></i>
                <strong>Viewing shifts for:</strong> 
                <c:choose>
                    <c:when test="${selectedDate != null}">
                        <fmt:formatDate value="${selectedDate}" pattern="EEEE, MMMM dd, yyyy" />
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-primary">All Dates</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Assignments Table Card -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>Shift ID</th>
                                    <th>Date</th>
                                    <th>Employee</th>
                                    <th>Shift Name</th>
                                    <th>Position</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty shifts}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5">
                                                <i class="fas fa-user-slash fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">
                                                    <c:choose>
                                                        <c:when test="${selectedDate != null}">
                                                            No shifts assigned for this date
                                                        </c:when>
                                                        <c:otherwise>
                                                            No shifts assigned yet
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <a href="${pageContext.request.contextPath}/shift-management?action=add-assignment" 
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fas fa-plus"></i> Assign First Shift
                                                </a>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="shift" items="${shifts}">
                                            <c:set var="isPastShift" value="${shift.shiftDate.before(currentDate)}" />
                                            <tr class="${isPastShift ? 'table-secondary' : ''}">
                                                <td><strong>#${shift.shiftId}</strong></td>
                                                <td>
                                                    <i class="fas fa-calendar-day ${isPastShift ? 'text-muted' : 'text-info'}"></i>
                                                    <fmt:formatDate value="${shift.shiftDate}" pattern="MMM dd, yyyy" />
                                                    <c:if test="${isPastShift}">
                                                        <span class="badge bg-secondary ms-1">Past</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <i class="fas fa-user text-primary"></i>
                                                    <strong>${shift.staffName}</strong>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary">
                                                        ${shift.shiftName}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge" style="background: #6366f1;">
                                                        ${shift.position}
                                                    </span>
                                                </td>
                                                <td>
                                                    <i class="fas fa-clock text-success"></i>
                                                    <fmt:formatDate value="${shift.startTime}" pattern="HH:mm" />
                                                </td>
                                                <td>
                                                    <i class="fas fa-clock text-danger"></i>
                                                    <fmt:formatDate value="${shift.endTime}" pattern="HH:mm" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isPastShift}">
                                                            <button class="btn btn-sm btn-secondary" disabled title="Cannot delete past shifts">
                                                                <i class="fas fa-lock"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="#" onclick="confirmDelete(${shift.shiftId})" 
                                                               class="btn btn-sm btn-danger" title="Remove Assignment">
                                                                <i class="fas fa-times"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
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
                    <h6 class="mb-0"><i class="fas fa-rules text-info"></i> Assignment Rules</h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>An employee cannot be assigned overlapping shifts on the same date</li>
                        <li>Assigned shifts must fall within configured business hours</li>
                        <li>Shift end time must be after start time</li>
                        <li>Employees can view their assigned shifts (read-only)</li>
                        <li>Remove assignments that are no longer needed</li>
                    </ul>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function confirmDelete(shiftId) {
    if (confirm('Are you sure you want to remove this shift assignment?')) {
        var contextPath = '${pageContext.request.contextPath}';
        window.location.href = contextPath + '/shift-management?action=delete-assignment&id=' + shiftId;
    }
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
