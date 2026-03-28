<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Work History" scope="request" />
<jsp:useBean id="currentDate" class="java.util.Date"/>
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
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-history text-info"></i> Work History</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shift-management?action=assignments">Shift Assignments</a></li>
                            <li class="breadcrumb-item active">Work History</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/shift-management?action=assignments"
                   class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>

            <!-- Employee Info Banner -->
            <div class="alert alert-primary d-flex align-items-center mb-4" role="alert">
                <i class="fas fa-user-circle fa-2x me-3"></i>
                <div>
                    <strong class="fs-5">${staffName}</strong>
                    <div class="text-muted small">Complete attendance history for all assigned shifts</div>
                </div>
            </div>

            <!-- Summary Stats -->
            <c:set var="totalShifts" value="${0}" />
            <c:set var="presentCount" value="${0}" />
            <c:set var="absentCount" value="${0}" />
            <c:set var="lateCount" value="${0}" />
            <c:set var="excusedCount" value="${0}" />
            <c:set var="unmarkedCount" value="${0}" />
            <c:forEach var="s" items="${history}">
                <c:set var="totalShifts" value="${totalShifts + 1}" />
                <c:choose>
                    <c:when test="${s.attendanceStatus == 'Present'}"><c:set var="presentCount" value="${presentCount + 1}" /></c:when>
                    <c:when test="${s.attendanceStatus == 'Absent'}"><c:set var="absentCount" value="${absentCount + 1}" /></c:when>
                    <c:when test="${s.attendanceStatus == 'Late'}"><c:set var="lateCount" value="${lateCount + 1}" /></c:when>
                    <c:when test="${s.attendanceStatus == 'Excused'}"><c:set var="excusedCount" value="${excusedCount + 1}" /></c:when>
                    <c:otherwise><c:set var="unmarkedCount" value="${unmarkedCount + 1}" /></c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-6 col-md-2">
                    <div class="card text-center border-primary">
                        <div class="card-body py-2">
                            <div class="fs-4 fw-bold text-primary">${totalShifts}</div>
                            <small class="text-muted">Total</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="card text-center border-success">
                        <div class="card-body py-2">
                            <div class="fs-4 fw-bold text-success">${presentCount}</div>
                            <small class="text-muted">Present</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="card text-center border-warning">
                        <div class="card-body py-2">
                            <div class="fs-4 fw-bold text-warning">${lateCount}</div>
                            <small class="text-muted">Late</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="card text-center border-danger">
                        <div class="card-body py-2">
                            <div class="fs-4 fw-bold text-danger">${absentCount}</div>
                            <small class="text-muted">Absent</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="card text-center border-info">
                        <div class="card-body py-2">
                            <div class="fs-4 fw-bold text-info">${excusedCount}</div>
                            <small class="text-muted">Excused</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-2">
                    <div class="card text-center border-secondary">
                        <div class="card-body py-2">
                            <div class="fs-4 fw-bold text-secondary">${unmarkedCount}</div>
                            <small class="text-muted">Not Marked</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- History Table -->
            <div class="card">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h6 class="mb-0"><i class="fas fa-table"></i> Shift History (${totalShifts} records)</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Date</th>
                                    <th>Shift</th>
                                    <th>Position</th>
                                    <th>Hours</th>
                                    <th>Attendance</th>
                                    <th>Note</th>
                                    <th>Marked By</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty history}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5 text-muted">
                                                <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                                No shift history found for this employee
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="s" items="${history}">
                                            <c:set var="isPast" value="${s.shiftDate.before(currentDate)}" />
                                            <tr class="${isPast ? 'table-secondary' : ''}">
                                                <td>
                                                    <fmt:formatDate value="${s.shiftDate}" pattern="MMM dd, yyyy" />
                                                    <c:if test="${!isPast}">
                                                        <span class="badge bg-primary ms-1">Upcoming</span>
                                                    </c:if>
                                                </td>
                                                <td><span class="badge bg-primary">${s.shiftName}</span></td>
                                                <td><span class="badge" style="background:#6366f1;">${s.position}</span></td>
                                                <td class="text-nowrap">
                                                    <fmt:formatDate value="${s.startTime}" pattern="HH:mm" /> -
                                                    <fmt:formatDate value="${s.endTime}" pattern="HH:mm" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${s.attendanceStatus == 'Present'}">
                                                            <span class="badge bg-success"><i class="fas fa-check-circle"></i> Present</span>
                                                        </c:when>
                                                        <c:when test="${s.attendanceStatus == 'Late'}">
                                                            <span class="badge bg-warning text-dark"><i class="fas fa-clock"></i> Late</span>
                                                        </c:when>
                                                        <c:when test="${s.attendanceStatus == 'Absent'}">
                                                            <span class="badge bg-danger"><i class="fas fa-times-circle"></i> Absent</span>
                                                        </c:when>
                                                        <c:when test="${s.attendanceStatus == 'Excused'}">
                                                            <span class="badge bg-info"><i class="fas fa-info-circle"></i> Excused</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-muted border">Not marked</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty s.note}">
                                                            <span title="${s.note}" style="cursor:help;">
                                                                <i class="fas fa-sticky-note text-warning"></i>
                                                                <small>${s.note.length() > 30 ? s.note.substring(0,30).concat('...') : s.note}</small>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty s.markedByName}">
                                                            <small class="text-muted">${s.markedByName}</small>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <!-- Allow re-marking attendance anytime -->
                                                    <a href="${pageContext.request.contextPath}/shift-management?action=mark-attendance&id=${s.shiftId}"
                                                       class="btn btn-sm btn-outline-success" title="Mark / Update Attendance">
                                                        <i class="fas fa-clipboard-check"></i>
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
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
