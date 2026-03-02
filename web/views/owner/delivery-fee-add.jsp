<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Add Delivery Fee" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-shipping-fast text-primary"></i> Add New Delivery Fee</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/delivery-fee?action=list">Delivery Fees</a></li>
                        <li class="breadcrumb-item active">Add New</li>
                    </ol>
                </nav>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-plus-circle"></i> Fee Configuration</h4>
                        </div>
                        <div class="card-body">
                            <!-- Error/Success Messages -->
                            <c:if test="${not empty sessionScope.toastMessage and sessionScope.toastType == 'error'}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle"></i> <strong>Error!</strong> ${sessionScope.toastMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/delivery-fee" method="POST" id="feeForm" novalidate>
                                <input type="hidden" name="action" value="add">
                            
                            <div class="mb-3">
                                <label for="zoneId" class="form-label">Coverage Zone <span class="text-danger">*</span></label>
                                <select class="form-select" id="zoneId" name="zoneId" required>
                                    <option value="">Select a coverage zone</option>
                                    <c:choose>
                                        <c:when test="${empty zones}">
                                            <option value="" disabled>No zones available - Please create a coverage zone first</option>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="zone" items="${zones}">
                                                <option value="${zone.zoneId}">
                                                    ${zone.restaurantName} - ${zone.zoneName}
                                                </option>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                                <div class="invalid-feedback">
                                    Please select a coverage zone.
                                </div>
                                <c:if test="${empty zones}">
                                    <div class="alert alert-warning mt-2">
                                        <i class="fas fa-exclamation-triangle"></i> 
                                        No coverage zones found. Please <a href="${pageContext.request.contextPath}/coverage-zone?action=add">create a coverage zone</a> first.
                                    </div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label for="feeType" class="form-label">Fee Type <span class="text-danger">*</span></label>
                                <select class="form-select" id="feeType" name="feeType" required onchange="updateFeeValueLabel()">
                                    <option value="">Select fee type</option>
                                    <option value="Flat">Flat - Fixed delivery fee</option>
                                    <option value="PercentageOfOrder">Percentage Of Order - Fee based on order total</option>
                                    <option value="FreeAboveAmount">Free Above Amount - Free delivery above certain amount</option>
                                </select>
                                <small class="form-text text-muted">
                                    <ul class="mt-2">
                                        <li><strong>Flat:</strong> Fixed delivery fee regardless of order amount</li>
                                        <li><strong>Percentage Of Order:</strong> Fee calculated as percentage of order total</li>
                                        <li><strong>Free Above Amount:</strong> Free delivery when order exceeds minimum amount</li>
                                    </ul>
                                </small>
                            </div>

                            <div class="mb-3">
                                <label for="feeValue" class="form-label">
                                    <span id="feeValueLabel">Fee Value</span> <span class="text-danger">*</span>
                                </label>
                                <input type="number" step="0.01" min="0" max="999999" class="form-control" id="feeValue" 
                                       name="feeValue" required placeholder="Enter fee value">
                                <div class="invalid-feedback">
                                    Please enter a valid fee value (0 or greater).
                                </div>
                                <small class="form-text text-muted" id="feeValueHint">
                                    Enter the fee amount or percentage
                                </small>
                            </div>

                            <div class="mb-3">
                                <label for="minOrderAmount" class="form-label">Minimum Order Amount (Optional)</label>
                                <input type="number" step="0.01" min="0" max="999999" class="form-control" id="minOrderAmount" 
                                       name="minOrderAmount" placeholder="Enter minimum order amount">
                                <div class="invalid-feedback">
                                    Minimum order amount must be 0 or greater.
                                </div>
                                <small class="form-text text-muted">
                                    Fee applies only when order total is at or above this amount
                                </small>
                            </div>

                            <div class="mb-3">
                                <label for="maxOrderAmount" class="form-label">Maximum Order Amount (Optional)</label>
                                <input type="number" step="0.01" min="0" max="999999" class="form-control" id="maxOrderAmount" 
                                       name="maxOrderAmount" placeholder="Enter maximum order amount">
                                <div class="invalid-feedback">
                                    Maximum order amount must be 0 or greater.
                                </div>
                                <small class="form-text text-muted">
                                    Fee applies only when order total is at or below this amount
                                </small>
                            </div>

                            <div class="mb-4">
                                <label for="isActive" class="form-label">
                                    <i class="fas fa-toggle-on text-primary"></i> Status
                                </label>
                                <select class="form-select" id="isActive" name="isActive">
                                    <option value="1" selected>Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/delivery-fee?action=list" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Fee
                                </button>
                            </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<style>
    .form-label {
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }
    
    .form-control, .form-select {
        border-radius: 10px;
        border: 2px solid #e2e8f0;
        padding: 0.75rem 1rem;
        transition: all 0.3s ease;
    }
    
    .form-control:focus, .form-select:focus {
        border-color: #6366f1;
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
    }
    
    .form-text {
        color: #64748b;
        font-size: 0.875rem;
    }
    
    .alert {
        border-radius: 10px;
        border: none;
    }
    
    .invalid-feedback {
        display: none;
        color: #ef4444;
        font-size: 0.875rem;
        margin-top: 0.25rem;
    }
    
    .was-validated .form-control:invalid ~ .invalid-feedback,
    .was-validated .form-select:invalid ~ .invalid-feedback {
        display: block;
    }
    
    .was-validated .form-control:invalid,
    .was-validated .form-select:invalid {
        border-color: #ef4444;
    }
    
    .was-validated .form-control:valid,
    .was-validated .form-select:valid {
        border-color: #10b981;
    }
</style>

<script>
    // Form validation
    (function() {
        'use strict';
        
        const form = document.getElementById('feeForm');
        const minOrderAmount = document.getElementById('minOrderAmount');
        const maxOrderAmount = document.getElementById('maxOrderAmount');
        
        // Custom validation for min/max order amounts
        function validateOrderAmounts() {
            const minVal = parseFloat(minOrderAmount.value) || 0;
            const maxVal = parseFloat(maxOrderAmount.value) || 0;
            
            if (minOrderAmount.value && maxOrderAmount.value && maxVal < minVal) {
                maxOrderAmount.setCustomValidity('Maximum order amount must be greater than minimum order amount');
                return false;
            } else {
                maxOrderAmount.setCustomValidity('');
                return true;
            }
        }
        
        minOrderAmount.addEventListener('change', validateOrderAmounts);
        maxOrderAmount.addEventListener('change', validateOrderAmounts);
        
        // Form submission validation
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity() || !validateOrderAmounts()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
        
        // Real-time validation
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (form.classList.contains('was-validated')) {
                    if (this.checkValidity()) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    }
                }
            });
        });
    })();
    
    function updateFeeValueLabel() {
            var feeType = document.getElementById('feeType').value;
            var feeValueLabel = document.getElementById('feeValueLabel');
            var feeValueHint = document.getElementById('feeValueHint');
            
            if (feeType === 'Flat') {
                feeValueLabel.textContent = 'Fee Value ($)';
                feeValueHint.textContent = 'Enter the fixed delivery fee amount in dollars';
            } else if (feeType === 'PercentageOfOrder') {
                feeValueLabel.textContent = 'Fee Value (%)';
                feeValueHint.textContent = 'Enter the percentage of order total (e.g., 10 for 10%)';
            } else if (feeType === 'FreeAboveAmount') {
                feeValueLabel.textContent = 'Minimum Amount for Free Delivery ($)';
                feeValueHint.textContent = 'Enter the minimum order amount for free delivery';
            } else {
                feeValueLabel.textContent = 'Fee Value';
                feeValueHint.textContent = 'Enter the fee amount or percentage';
            }
        }
    </script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
