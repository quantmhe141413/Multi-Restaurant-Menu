<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Edit Shift Template" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-edit text-primary"></i> Edit Shift Template</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shift-management?action=templates">Shift Templates</a></li>
                        <li class="breadcrumb-item active">Edit</li>
                    </ol>
                </nav>
            </div>

            <!-- Form Card -->
            <div class="card shadow-sm">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h5 class="mb-0"><i class="fas fa-calendar-alt"></i> Edit Shift Template</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/shift-management" method="POST" onsubmit="return validateShiftTime()">
                        <input type="hidden" name="action" value="edit-template">
                        <input type="hidden" name="templateId" value="${template.templateId}">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-tag text-primary"></i> Shift Name <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" name="shiftName" 
                                       value="${template.shiftName}" required>
                                <small class="text-muted">A descriptive name for this shift</small>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-briefcase text-info"></i> Position
                                </label>
                                <input type="text" class="form-control" name="position" 
                                       value="${template.position}">
                                <small class="text-muted">Job position for this shift (optional)</small>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-clock text-success"></i> Start Time <span class="text-danger">*</span>
                                </label>
                                <fmt:formatDate value="${template.startTime}" pattern="HH:mm" var="formattedStart" />
                                <input type="time" class="form-control" name="startTime" id="startTime" 
                                       value="${formattedStart}" required>
                                <small class="text-muted">When the shift begins</small>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-clock text-danger"></i> End Time <span class="text-danger">*</span>
                                </label>
                                <fmt:formatDate value="${template.endTime}" pattern="HH:mm" var="formattedEnd" />
                                <input type="time" class="form-control" name="endTime" id="endTime" 
                                       value="${formattedEnd}" required>
                                <small class="text-muted">When the shift ends</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isActive" value="1" 
                                       id="isActive" ${template.isActive ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">
                                    <strong>Active Status</strong>
                                </label>
                            </div>
                            <small class="text-muted">Active templates can be used for shift assignments</small>
                        </div>

                        <div class="alert alert-info" role="alert">
                            <i class="fas fa-info-circle"></i>
                            <strong>Note:</strong> Changes to shift templates will not affect existing assignments.
                        </div>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/shift-management?action=templates" 
                               class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Template
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function validateShiftTime() {
    const startTime = document.getElementById('startTime').value;
    const endTime = document.getElementById('endTime').value;
    
    if (!startTime || !endTime) {
        alert('Please fill in both start and end time');
        return false;
    }
    
    if (endTime <= startTime) {
        alert('End time must be after start time.\nPlease adjust the shift times.');
        return false;
    }
    
    return true;
}

// Real-time validation
document.getElementById('startTime').addEventListener('change', function() {
    document.getElementById('endTime').min = this.value;
});

document.getElementById('endTime').addEventListener('change', function() {
    const startTime = document.getElementById('startTime').value;
    const endTime = this.value;
    
    if (startTime && endTime && endTime <= startTime) {
        this.classList.add('is-invalid');
        this.setCustomValidity('End time must be after start time');
    } else {
        this.classList.remove('is-invalid');
        this.setCustomValidity('');
    }
});
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
