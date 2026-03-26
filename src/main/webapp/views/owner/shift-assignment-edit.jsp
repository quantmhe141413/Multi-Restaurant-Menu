<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <c:set var="pageTitle" value="Edit Shift Assignment" scope="request" />
        <jsp:useBean id="today" class="java.util.Date" />
        <fmt:formatDate value="${today}" pattern="yyyy-MM-dd" var="todayStr" />
        <fmt:formatDate value="${shift.shiftDate}" pattern="yyyy-MM-dd" var="shiftDateStr" />
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
                        <div class="page-header">
                            <h1><i class="fas fa-edit text-warning"></i> Edit Shift Assignment</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a>
                                    </li>
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/shift-management?action=assignments">Shift
                                            Assignments</a></li>
                                    <li class="breadcrumb-item active">Edit #${shift.shiftId}</li>
                                </ol>
                            </nav>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header"
                                style="background: linear-gradient(135deg, #f59e0b, #d97706); color: white;">
                                <h5 class="mb-0"><i class="fas fa-user-clock"></i> Edit Shift Assignment
                                    #${shift.shiftId}</h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/shift-management" method="POST">
                                    <input type="hidden" name="action" value="edit-assignment">
                                    <input type="hidden" name="shiftId" value="${shift.shiftId}">

                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-user text-primary"></i> Select Employee <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" name="staffId" required>
                                                <option value="">-- Select Employee --</option>
                                                <c:forEach var="staff" items="${availableStaff}">
                                                    <option value="${staff.userID}" ${staff.userID==shift.staffId
                                                        ? 'selected' : '' }>
                                                        ${staff.fullName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-calendar-day text-info"></i> Shift Date <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <input type="date" class="form-control" name="shiftDate"
                                                value="${shiftDateStr}" min="${todayStr}" required>
                                            <small class="text-muted">Cannot be set to a past date</small>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-calendar-check text-success"></i> Select Shift <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" name="templateId" id="templateId" required
                                                onchange="showShiftDetails(this)">
                                                <option value="">-- Select Shift Template --</option>
                                                <c:forEach var="template" items="${templates}">
                                                    <option value="${template.templateId}"
                                                        data-shift-name="${template.shiftName}"
                                                        data-start-time="<fmt:formatDate value='${template.startTime}' pattern='HH:mm' />"
                                                        data-end-time="<fmt:formatDate value='${template.endTime}' pattern='HH:mm' />"
                                                        data-position="${template.position}"
                                                        ${template.templateId==shift.templateId ? 'selected' : '' }>
                                                        ${template.shiftName} (
                                                        <fmt:formatDate value="${template.startTime}" pattern="HH:mm" />
                                                        -
                                                        <fmt:formatDate value="${template.endTime}" pattern="HH:mm" />)
                                                        - ${template.position}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Shift Details Preview -->
                                    <div id="shiftDetailsCard" class="card bg-light mb-3">
                                        <div class="card-body">
                                            <h6 class="card-title"><i class="fas fa-info-circle text-info"></i> Shift
                                                Details</h6>
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <strong>Shift Name:</strong>
                                                    <p class="mb-0" id="detailShiftName">${shift.shiftName}</p>
                                                </div>
                                                <div class="col-md-3">
                                                    <strong>Start Time:</strong>
                                                    <p class="mb-0" id="detailStartTime">
                                                        <fmt:formatDate value="${shift.startTime}" pattern="HH:mm" />
                                                    </p>
                                                </div>
                                                <div class="col-md-3">
                                                    <strong>End Time:</strong>
                                                    <p class="mb-0" id="detailEndTime">
                                                        <fmt:formatDate value="${shift.endTime}" pattern="HH:mm" />
                                                    </p>
                                                </div>
                                                <div class="col-md-3">
                                                    <strong>Position:</strong>
                                                    <p class="mb-0" id="detailPosition">${shift.position}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="text-center">
                                        <a href="${pageContext.request.contextPath}/shift-management?action=assignments"
                                            class="btn btn-secondary">
                                            <i class="fas fa-times"></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-warning text-white">
                                            <i class="fas fa-save"></i> Update Assignment
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </main>
                </div>
            </div>

            <script>
                function showShiftDetails(selectElement) {
                    const opt = selectElement.options[selectElement.selectedIndex];
                    if (!opt.value) return;
                    document.getElementById('detailShiftName').textContent = opt.getAttribute('data-shift-name');
                    document.getElementById('detailStartTime').textContent = opt.getAttribute('data-start-time');
                    document.getElementById('detailEndTime').textContent = opt.getAttribute('data-end-time');
                    document.getElementById('detailPosition').textContent = opt.getAttribute('data-position');
                }
            </script>

            <jsp:include page="/WEB-INF/includes/footer.jsp" />