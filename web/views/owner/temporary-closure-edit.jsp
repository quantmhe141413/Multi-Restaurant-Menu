<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Edit Temporary Closure" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-edit text-primary"></i> Edit Temporary Closure</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/temporary-closure?action=list">Temporary Closure</a></li>
                        <li class="breadcrumb-item active">Edit</li>
                    </ol>
                </nav>
            </div>

            <!-- Form Card -->
            <div class="card shadow-sm">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h5 class="mb-0"><i class="fas fa-door-closed"></i> Edit Closure Period</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/temporary-closure" method="POST" 
                          onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="closureId" value="${closure.closureId}">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-calendar-plus text-primary"></i> Start Date & Time <span class="text-danger">*</span>
                                </label>
                                <fmt:formatDate value="${closure.startDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="formattedStart" />
                                <input type="datetime-local" class="form-control" name="startDateTime" 
                                       id="startDateTime" value="${formattedStart}" required>
                                <small class="text-muted">When the closure period begins (cannot be in the past)</small>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-calendar-minus text-danger"></i> End Date & Time <span class="text-danger">*</span>
                                </label>
                                <fmt:formatDate value="${closure.endDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="formattedEnd" />
                                <input type="datetime-local" class="form-control" name="endDateTime" 
                                       id="endDateTime" value="${formattedEnd}" required>
                                <small class="text-muted">When the closure period ends (must be after start)</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-comment-alt text-info"></i> Reason (Optional)
                            </label>
                            <textarea class="form-control" name="reason" rows="3" 
                                      placeholder="e.g., Staff training, Holiday, Maintenance...">${closure.reason}</textarea>
                            <small class="text-muted">Provide a reason for the closure (optional)</small>
                        </div>

                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isActive" value="1" 
                                       id="isActive" ${closure.isActive ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">
                                    <strong>Active Status</strong>
                                </label>
                            </div>
                            <small class="text-muted">Active closures will prevent new orders</small>
                        </div>

                        <div class="alert alert-warning" role="alert">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Important:</strong> During an active temporary closure, the system will not accept new orders.
                        </div>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/temporary-closure?action=list" 
                               class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Closure Period
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
// Set minimum datetime to current datetime
window.onload = function() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const minDateTime = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
    
    document.getElementById('startDateTime').min = minDateTime;
    document.getElementById('endDateTime').min = minDateTime;
};

function validateForm() {
    const startDateTime = document.getElementById('startDateTime').value;
    const endDateTime = document.getElementById('endDateTime').value;
    
    if (!startDateTime || !endDateTime) {
        alert('Please fill in both start and end date/time');
        return false;
    }
    
    const startDate = new Date(startDateTime);
    const endDate = new Date(endDateTime);
    const currentDate = new Date();
    
    // Validation 1: Start date cannot be in the past
    if (startDate < currentDate) {
        alert('Start date/time cannot be in the past.\nPlease select a future date and time.');
        return false;
    }
    
    // Validation 2: End date must be after start date
    if (endDate <= startDate) {
        alert('End date/time must be after start date/time.\nPlease ensure the end time is later than the start time.');
        return false;
    }
    
    // Check duration is reasonable (at least 1 hour)
    const durationInHours = (endDate - startDate) / (1000 * 60 * 60);
    if (durationInHours < 1) {
        if (!confirm('Closure period is less than 1 hour. Are you sure you want to continue?')) {
            return false;
        }
    }
    
    return true;
}

// Real-time validation feedback
document.getElementById('startDateTime').addEventListener('change', function() {
    const startDate = new Date(this.value);
    const currentDate = new Date();
    
    if (startDate < currentDate) {
        this.classList.add('is-invalid');
        this.setCustomValidity('Start date cannot be in the past');
    } else {
        this.classList.remove('is-invalid');
        this.setCustomValidity('');
    }
    
    // Update end date minimum
    document.getElementById('endDateTime').min = this.value;
});

document.getElementById('endDateTime').addEventListener('change', function() {
    const startDateTime = document.getElementById('startDateTime').value;
    const endDateTime = this.value;
    
    if (startDateTime && endDateTime && endDateTime <= startDateTime) {
        this.classList.add('is-invalid');
        this.setCustomValidity('End date must be after start date');
    } else {
        this.classList.remove('is-invalid');
        this.setCustomValidity('');
    }
});
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
