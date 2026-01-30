<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Edit Coverage Zone" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-edit text-warning"></i> Edit Coverage Zone</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/coverage-zone?action=list">Coverage Zones</a></li>
                        <li class="breadcrumb-item active">Edit Zone #${zone.zoneId}</li>
                    </ol>
                </nav>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <h4 class="mb-0"><i class="fas fa-pencil-alt"></i> Update Zone Information</h4>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/coverage-zone" method="POST">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="zoneId" value="${zone.zoneId}">
                                
                                <div class="mb-4">
                                    <label for="zoneName" class="form-label">
                                        <i class="fas fa-map-pin text-warning"></i> Zone Name <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="zoneName" name="zoneName" 
                                           required value="${zone.zoneName}" placeholder="Enter zone name">
                                </div>

                                <div class="mb-4">
                                    <label for="zoneDefinition" class="form-label">
                                        <i class="fas fa-ruler-combined text-warning"></i> Zone Definition
                                    </label>
                                    <textarea class="form-control" id="zoneDefinition" name="zoneDefinition" 
                                              rows="4" placeholder="Describe the coverage area...">${zone.zoneDefinition}</textarea>
                                    <small class="form-text text-muted">
                                        <i class="fas fa-lightbulb"></i> Examples: "5km radius", "District 1, District 2", etc.
                                    </small>
                                </div>

                                <div class="mb-4">
                                    <label for="isActive" class="form-label">
                                        <i class="fas fa-toggle-on text-warning"></i> Status
                                    </label>
                                    <select class="form-select" id="isActive" name="isActive">
                                        <option value="1" ${zone.isActive ? 'selected' : ''}>Active</option>
                                        <option value="0" ${!zone.isActive ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>

                                <div class="d-flex justify-content-between pt-3 border-top">
                                    <a href="${pageContext.request.contextPath}/coverage-zone?action=list" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to List
                                    </a>
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fas fa-save"></i> Update Zone
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

<jsp:include page="/WEB-INF/includes/footer.jsp" />
