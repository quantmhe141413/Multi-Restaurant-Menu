<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Edit Temporary Closure" scope="request" />
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

                        <!-- Business Hours Reference -->
                        <c:if test="${not empty businessHours}">
                            <div class="card border-info mb-3">
                                <div class="card-header bg-info text-white py-2">
                                    <i class="fas fa-clock"></i> <strong>Current Business Hours</strong>
                                    <small class="ms-2">(closure will override these days)</small>
                                </div>
                                <div class="card-body py-2">
                                    <div class="row row-cols-2 row-cols-md-4 g-2">
                                        <c:forEach var="bh" items="${businessHours}">
                                            <div class="col">
                                                <div class="p-2 rounded border text-center ${bh.isOpen ? 'border-success' : 'border-secondary bg-light'}">
                                                    <div class="fw-bold small">${bh.dayOfWeek}</div>
                                                    <c:choose>
                                                        <c:when test="${bh.isOpen}">
                                                            <div class="text-success small">${bh.openingTime} – ${bh.closingTime}</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-muted small">Closed</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Conflict Warning -->
                        <div id="conflictWarning" class="alert alert-danger d-none" role="alert">
                            <i class="fas fa-calendar-times"></i>
                            <strong>Business Hours Conflict:</strong>
                            <span id="conflictDetail"></span>
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

// Business hours conflict check
const businessHoursData = [
    <c:forEach var="bh" items="${businessHours}" varStatus="loop">
    { day: '${bh.dayOfWeek}', isOpen: ${bh.isOpen}, open: '${bh.openingTime}', close: '${bh.closingTime}' }${!loop.last ? ',' : ''}
    </c:forEach>
];

const DAY_NAMES = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

function checkBusinessHoursConflict() {
    const startVal = document.getElementById('startDateTime').value;
    const endVal = document.getElementById('endDateTime').value;
    const warning = document.getElementById('conflictWarning');
    const detail = document.getElementById('conflictDetail');

    if (!startVal || !endVal || businessHoursData.length === 0) {
        warning.classList.add('d-none');
        return;
    }

    const start = new Date(startVal);
    const end = new Date(endVal);
    if (end <= start) { warning.classList.add('d-none'); return; }

    const affectedDays = new Set();
    const cursor = new Date(start);
    while (cursor <= end) {
        affectedDays.add(DAY_NAMES[cursor.getDay()]);
        cursor.setDate(cursor.getDate() + 1);
    }

    const conflicts = businessHoursData.filter(bh => bh.isOpen && affectedDays.has(bh.day));

    if (conflicts.length > 0) {
        const conflictList = conflicts.map(bh => bh.day + ' (' + bh.open + '–' + bh.close + ')').join(', ');
        detail.textContent = ' This closure overlaps open business hours on: ' + conflictList + '. The closure will override these hours.';
        warning.classList.remove('d-none');
    } else {
        warning.classList.add('d-none');
    }
}

document.getElementById('startDateTime').addEventListener('change', checkBusinessHoursConflict);
document.getElementById('endDateTime').addEventListener('change', checkBusinessHoursConflict);

// Run on page load to show conflict for existing dates
checkBusinessHoursConflict();
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
