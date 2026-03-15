<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Add Shift Template" scope="request" />
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
                <h1><i class="fas fa-plus-circle text-primary"></i> Add Shift Template</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shift-management?action=templates">Shift Templates</a></li>
                        <li class="breadcrumb-item active">Add</li>
                    </ol>
                </nav>
            </div>

            <!-- Form Card -->
            <div class="card shadow-sm">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h5 class="mb-0"><i class="fas fa-calendar-alt"></i> Shift Template Configuration</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/shift-management" method="POST">
                        <input type="hidden" name="action" value="add-template">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-tag text-primary"></i> Shift Name <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" name="shiftName" 
                                       placeholder="e.g., Morning Shift, Evening Shift..." required>
                                <small class="text-muted">A descriptive name for this shift</small>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-briefcase text-info"></i> Position
                                </label>
                                <input type="text" class="form-control" name="position" 
                                       placeholder="e.g., Server, Chef, Cashier...">
                                <small class="text-muted">Job position for this shift (optional)</small>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-clock text-success"></i> Start Time <span class="text-danger">*</span>
                                </label>
                                <input type="time" class="form-control" name="startTime" required>
                                <small class="text-muted">When the shift begins</small>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fas fa-clock text-danger"></i> End Time <span class="text-danger">*</span>
                                </label>
                                <input type="time" class="form-control" name="endTime" required>
                                <small class="text-muted">When the shift ends</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isActive" value="1" 
                                       id="isActive" checked>
                                <label class="form-check-label" for="isActive">
                                    <strong>Activate Template</strong>
                                </label>
                            </div>
                            <small class="text-muted">Active templates can be used for shift assignments</small>
                        </div>

                        <div class="alert alert-info" role="alert">
                            <i class="fas fa-info-circle"></i>
                            <strong>Note:</strong> Shift templates are reusable definitions. Once created, you can assign employees to shifts based on these templates.
                        </div>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/shift-management?action=templates" 
                               class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Template
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
