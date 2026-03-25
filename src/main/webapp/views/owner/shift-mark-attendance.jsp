<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Mark Attendance" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} - FoodieExpress</title>
    <jsp:include page="/views/includes/std_head.jsp" />
</head>
<body>
    <jsp:include page="/views/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/views/includes/restaurant-sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-clipboard-check text-success"></i> Mark Attendance</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shift-management?action=assignments">Shift Assignments</a></li>
                        <li class="breadcrumb-item active">Mark Attendance</li>
                    </ol>
                </nav>
            </div>

            <!-- Shift Info Card -->
            <div class="card mb-4">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-info-circle text-info"></i> Shift Details</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <small class="text-muted">Employee</small>
                            <p class="fw-bold mb-0"><i class="fas fa-user text-primary"></i> ${shift.staffName}</p>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted">Date</small>
                            <p class="fw-bold mb-0">
                                <fmt:formatDate value="${shift.shiftDate}" pattern="EEE, MMM dd yyyy" />
                            </p>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted">Shift</small>
                            <p class="fw-bold mb-0">
                                <span class="badge bg-primary">${shift.shiftName}</span>
                                &nbsp;
                                <fmt:formatDate value="${shift.startTime}" pattern="HH:mm" /> -
                                <fmt:formatDate value="${shift.endTime}" pattern="HH:mm" />
                            </p>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted">Position</small>
                            <p class="fw-bold mb-0">
                                <span class="badge" style="background:#6366f1;">${shift.position}</span>
                            </p>
                        </div>
                    </div>
                    <c:if test="${shift.attendanceStatus != null}">
                        <hr>
                        <div class="alert alert-warning mb-0 py-2">
                            <i class="fas fa-exclamation-triangle"></i>
                            This shift already has attendance marked as
                            <strong>${shift.attendanceStatus}</strong>.
                            Submitting this form will overwrite it.
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Attendance Form -->
            <div class="card">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h6 class="mb-0"><i class="fas fa-pen"></i> Attendance Record</h6>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/shift-management" method="POST">
                        <input type="hidden" name="action" value="save-attendance">
                        <input type="hidden" name="shiftId" value="${shift.shiftId}">

                        <!-- Status -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                <i class="fas fa-check-square text-success"></i> Attendance Status <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex flex-wrap gap-3">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="attendanceStatus"
                                           id="statusPresent" value="Present"
                                           ${shift.attendanceStatus == 'Present' ? 'checked' : ''} required>
                                    <label class="form-check-label" for="statusPresent">
                                        <span class="badge bg-success"><i class="fas fa-check-circle"></i> Present</span>
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="attendanceStatus"
                                           id="statusLate" value="Late"
                                           ${shift.attendanceStatus == 'Late' ? 'checked' : ''}>
                                    <label class="form-check-label" for="statusLate">
                                        <span class="badge bg-warning text-dark"><i class="fas fa-clock"></i> Late</span>
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="attendanceStatus"
                                           id="statusAbsent" value="Absent"
                                           ${shift.attendanceStatus == 'Absent' ? 'checked' : ''}>
                                    <label class="form-check-label" for="statusAbsent">
                                        <span class="badge bg-danger"><i class="fas fa-times-circle"></i> Absent</span>
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="attendanceStatus"
                                           id="statusExcused" value="Excused"
                                           ${shift.attendanceStatus == 'Excused' ? 'checked' : ''}>
                                    <label class="form-check-label" for="statusExcused">
                                        <span class="badge bg-info"><i class="fas fa-info-circle"></i> Excused</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Note -->
                        <div class="mb-4">
                            <label class="form-label">
                                <i class="fas fa-sticky-note text-warning"></i> Note (Optional)
                            </label>
                            <textarea class="form-control" name="note" rows="3"
                                      placeholder="e.g. Left early due to emergency, Called in sick...">${shift.note}</textarea>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Save Attendance
                            </button>
                            <a href="${pageContext.request.contextPath}/shift-management?action=assignments"
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
