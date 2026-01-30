<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Edit Delivery Fee" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-edit text-warning"></i> Edit Delivery Fee</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/delivery-fee?action=list">Delivery Fees</a></li>
                        <li class="breadcrumb-item active">Edit Fee #${fee.feeId}</li>
                    </ol>
                </nav>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <h4 class="mb-0"><i class="fas fa-pencil-alt"></i> Update Fee Configuration</h4>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/delivery-fee" method="POST">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="feeId" value="${fee.feeId}">
                                
                                <div class="mb-4">
                                    <label for="zoneId" class="form-label">
                                        <i class="fas fa-map-marked-alt text-warning"></i> Coverage Zone <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="zoneId" name="zoneId" required>
                                        <option value="">Select a coverage zone</option>
                                        <c:forEach var="zone" items="${zones}">
                                            <option value="${zone.zoneId}" ${zone.zoneId == fee.zoneId ? 'selected' : ''}>
                                                ${zone.restaurantName} - ${zone.zoneName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label for="feeType" class="form-label">
                                        <i class="fas fa-tag text-warning"></i> Fee Type <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="feeType" name="feeType" required onchange="updateFeeValueLabel()">
                                        <option value="">Select fee type</option>
                                        <option value="Flat" ${fee.feeType == 'Flat' ? 'selected' : ''}>Flat - Fixed delivery fee</option>
                                        <option value="PercentageOfOrder" ${fee.feeType == 'PercentageOfOrder' ? 'selected' : ''}>Percentage Of Order</option>
                                        <option value="FreeAboveAmount" ${fee.feeType == 'FreeAboveAmount' ? 'selected' : ''}>Free Above Amount</option>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label for="feeValue" class="form-label">
                                        <span id="feeValueLabel">Fee Value</span> <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" step="0.01" min="0" class="form-control" id="feeValue" 
                                           name="feeValue" required value="${fee.feeValue}">
                                    <small class="form-text text-muted" id="feeValueHint">
                                        Enter the fee amount
                                    </small>
                                </div>

                                <div class="mb-4">
                                    <label for="minOrderAmount" class="form-label">
                                        <i class="fas fa-arrow-down text-warning"></i> Minimum Order Amount (Optional)
                                    </label>
                                    <input type="number" step="0.01" min="0" class="form-control" id="minOrderAmount" 
                                           name="minOrderAmount" value="${fee.minOrderAmount}">
                                    <small class="form-text text-muted">
                                        Fee applies only when order is at or above this amount
                                    </small>
                                </div>

                                <div class="mb-4">
                                    <label for="maxOrderAmount" class="form-label">
                                        <i class="fas fa-arrow-up text-warning"></i> Maximum Order Amount (Optional)
                                    </label>
                                    <input type="number" step="0.01" min="0" class="form-control" id="maxOrderAmount" 
                                           name="maxOrderAmount" value="${fee.maxOrderAmount}">
                                    <small class="form-text text-muted">
                                        Fee applies only when order is at or below this amount
                                    </small>
                                </div>

                                <div class="mb-4">
                                    <label for="isActive" class="form-label">
                                        <i class="fas fa-toggle-on text-warning"></i> Status
                                    </label>
                                    <select class="form-select" id="isActive" name="isActive">
                                        <option value="1" ${fee.isActive ? 'selected' : ''}>Active</option>
                                        <option value="0" ${!fee.isActive ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>

                                <div class="d-flex justify-content-between pt-3 border-top">
                                    <a href="${pageContext.request.contextPath}/delivery-fee?action=list" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to List
                                    </a>
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fas fa-save"></i> Update Fee
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
        border-color: #f59e0b;
        box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
    }
</style>

<script>
    function updateFeeValueLabel() {
        var feeType = document.getElementById('feeType').value;
        var feeValueLabel = document.getElementById('feeValueLabel');
        var feeValueHint = document.getElementById('feeValueHint');
        
        if (feeType === 'Flat') {
            feeValueLabel.innerHTML = '<i class="fas fa-dollar-sign text-warning"></i> Fee Value ($)';
            feeValueHint.textContent = 'Enter the fixed delivery fee amount in dollars';
        } else if (feeType === 'PercentageOfOrder') {
            feeValueLabel.innerHTML = '<i class="fas fa-percent text-warning"></i> Fee Value (%)';
            feeValueHint.textContent = 'Enter the percentage of order total (e.g., 10 for 10%)';
        } else if (feeType === 'FreeAboveAmount') {
            feeValueLabel.innerHTML = '<i class="fas fa-gift text-warning"></i> Minimum Amount for Free Delivery ($)';
            feeValueHint.textContent = 'Enter the minimum order amount for free delivery';
        } else {
            feeValueLabel.innerHTML = 'Fee Value';
            feeValueHint.textContent = 'Enter the fee amount';
        }
    }
    
    // Initialize on page load
    window.onload = function() {
        updateFeeValueLabel();
    };
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
