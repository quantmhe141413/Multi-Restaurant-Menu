<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Add Coverage Zone" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-map-marked-alt text-primary"></i> Add New Coverage Zone</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/coverage-zone?action=list">Coverage Zones</a></li>
                        <li class="breadcrumb-item active">Add New</li>
                    </ol>
                </nav>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="fas fa-plus-circle"></i> Zone Information</h4>
                        </div>
                        <div class="card-body">
                            <!-- Error/Success Messages -->
                            <c:if test="${not empty sessionScope.toastMessage and sessionScope.toastType == 'error'}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle"></i> <strong>Error!</strong> ${sessionScope.toastMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/coverage-zone" method="POST" id="zoneForm" novalidate>
                                <input type="hidden" name="action" value="add">
                                
                                <div class="mb-4">
                                    <label for="restaurantId" class="form-label">
                                        <i class="fas fa-store text-primary"></i> Restaurant <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="restaurantId" name="restaurantId" required>
                                        <option value="">-- Select Restaurant --</option>
                                        <c:forEach var="restaurant" items="${restaurants}">
                                            <option value="${restaurant.restaurantId}" 
                                                    ${restaurant.restaurantId == currentRestaurantId ? 'selected' : ''}>
                                                ${restaurant.name} - ${restaurant.address}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">
                                        <i class="fas fa-info-circle"></i> Select the restaurant for this coverage zone
                                    </small>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="zoneName" class="form-label">
                                        <i class="fas fa-map-pin text-primary"></i> Zone Name <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="zoneName" name="zoneName" 
                                           required minlength="3" maxlength="100" 
                                           placeholder="e.g., Downtown District 1">
                                    <div class="invalid-feedback">
                                        Please enter a zone name (3-100 characters).
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="zoneDefinition" class="form-label">
                                        <i class="fas fa-ruler-combined text-primary"></i> Zone Definition
                                    </label>
                                    <textarea class="form-control" id="zoneDefinition" name="zoneDefinition" 
                                              rows="4" maxlength="500" placeholder="Describe the coverage area..."></textarea>
                                    <small class="form-text text-muted">
                                        <span id="charCount">0</span>/500 characters
                                    </small>
                                    <small class="form-text text-muted">
                                        <i class="fas fa-lightbulb"></i> Define the coverage area. Examples:
                                        <div class="mt-2 ms-3">
                                            <div><i class="fas fa-circle text-primary" style="font-size: 6px;"></i> <strong>Radius:</strong> "5km radius from restaurant location"</div>
                                            <div><i class="fas fa-circle text-primary" style="font-size: 6px;"></i> <strong>Area:</strong> "District 1, District 2, District 3"</div>
                                            <div><i class="fas fa-circle text-primary" style="font-size: 6px;"></i> <strong>Coordinates:</strong> "Custom polygon: lat1,lng1; lat2,lng2..."</div>
                                        </div>
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

                                <div class="d-flex justify-content-between pt-3 border-top">
                                    <a href="${pageContext.request.contextPath}/coverage-zone?action=list" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to List
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Create Zone
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
        
        const form = document.getElementById('zoneForm');
        const zoneDefinition = document.getElementById('zoneDefinition');
        const charCount = document.getElementById('charCount');
        
        // Character counter
        if (zoneDefinition && charCount) {
            zoneDefinition.addEventListener('input', function() {
                charCount.textContent = this.value.length;
                if (this.value.length > 450) {
                    charCount.style.color = '#ef4444';
                } else {
                    charCount.style.color = '#64748b';
                }
            });
        }
        
        // Form submission validation
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
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
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
