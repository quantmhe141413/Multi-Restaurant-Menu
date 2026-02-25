<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Add Shift Assignment" scope="request" />
<jsp:useBean id="today" class="java.util.Date"/>
<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" var="todayStr"/>
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-user-plus text-primary"></i> Assign Employee to Shift</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shift-management?action=assignments">Shift Assignments</a></li>
                        <li class="breadcrumb-item active">Add</li>
                    </ol>
                </nav>
            </div>

            <!-- Form Card -->
            <div class="card shadow-sm">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h5 class="mb-0"><i class="fas fa-user-clock"></i> Shift Assignment Form</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/shift-management" method="POST">
                        <input type="hidden" name="action" value="add-assignment">
                        
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-user text-primary"></i> Select Employee <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" name="staffId" required>
                                    <option value="">-- Select Employee --</option>
                                    <c:forEach var="staff" items="${availableStaff}">
                                        <option value="${staff.userID}">${staff.fullName}</option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Choose the employee to assign</small>
                            </div>
                            
                            <div class="col-md-4 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-calendar-day text-info"></i> Shift Date <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" name="shiftDate" min="${todayStr}" required>
                                <small class="text-muted">Date of the shift (cannot be in the past)</small>
                            </div>

                            <div class="col-md-4 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-calendar-check text-success"></i> Select Shift <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" name="templateId" id="templateId" required onchange="showShiftDetails(this)">
                                    <option value="">-- Select Shift Template --</option>
                                    <c:forEach var="template" items="${templates}">
                                        <option value="${template.templateId}" 
                                                data-shift-name="${template.shiftName}"
                                                data-start-time="<fmt:formatDate value='${template.startTime}' pattern='HH:mm' />"
                                                data-end-time="<fmt:formatDate value='${template.endTime}' pattern='HH:mm' />"
                                                data-position="${template.position}">
                                            ${template.shiftName} (<fmt:formatDate value="${template.startTime}" pattern="HH:mm" /> - <fmt:formatDate value="${template.endTime}" pattern="HH:mm" />) - ${template.position}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Choose the shift template</small>
                            </div>
                        </div>

                        <!-- Shift Details Preview -->
                        <div id="shiftDetailsCard" class="card bg-light mb-3" style="display: none;">
                            <div class="card-body">
                                <h6 class="card-title">
                                    <i class="fas fa-info-circle text-info"></i> Shift Details
                                </h6>
                                <div class="row">
                                    <div class="col-md-3">
                                        <strong>Shift Name:</strong>
                                        <p class="mb-0" id="detailShiftName">-</p>
                                    </div>
                                    <div class="col-md-3">
                                        <strong>Start Time:</strong>
                                        <p class="mb-0" id="detailStartTime">-</p>
                                    </div>
                                    <div class="col-md-3">
                                        <strong>End Time:</strong>
                                        <p class="mb-0" id="detailEndTime">-</p>
                                    </div>
                                    <div class="col-md-3">
                                        <strong>Position:</strong>
                                        <p class="mb-0" id="detailPosition">-</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-info" role="alert">
                            <i class="fas fa-info-circle"></i>
                            <strong>How it works:</strong> 
                            <ul class="mb-0">
                                <li>Select an employee from your staff</li>
                                <li>Choose the date for the shift</li>
                                <li>Pick a shift template - all details (time, position) will be taken from the template</li>
                                <li>Employee cannot have overlapping shifts on the same date</li>
                            </ul>
                        </div>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/shift-management?action=assignments" 
                               class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Assign Shift
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
    const selectedOption = selectElement.options[selectElement.selectedIndex];
    
    if (selectedOption.value === "") {
        document.getElementById('shiftDetailsCard').style.display = 'none';
        return;
    }
    
    // Get data from selected option
    const shiftName = selectedOption.getAttribute('data-shift-name');
    const startTime = selectedOption.getAttribute('data-start-time');
    const endTime = selectedOption.getAttribute('data-end-time');
    const position = selectedOption.getAttribute('data-position');
    
    // Update details
    document.getElementById('detailShiftName').textContent = shiftName;
    document.getElementById('detailStartTime').textContent = startTime;
    document.getElementById('detailEndTime').textContent = endTime;
    document.getElementById('detailPosition').textContent = position;
    
    // Show card
    document.getElementById('shiftDetailsCard').style.display = 'block';
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
