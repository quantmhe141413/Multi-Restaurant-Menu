<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Shift Templates" scope="request" />
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
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-calendar-alt text-primary"></i> Shift Templates</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Shift Templates</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/shift-management?action=add-template" 
                       class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Add Shift Template
                    </a>
                </div>
            </div>

            <!-- Info Alert -->
            <div class="alert alert-info" role="alert">
                <i class="fas fa-info-circle"></i>
                <strong>Shift Templates:</strong> Create reusable shift definitions that can be assigned to employees. 
                Each template defines a shift name, position, and time range.
            </div>

            <!-- Templates Table Card -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>Template ID</th>
                                    <th>Shift Name</th>
                                    <th>Position</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Duration</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty templates}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5">
                                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">No shift templates configured</p>
                                                <a href="${pageContext.request.contextPath}/shift-management?action=add-template" 
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fas fa-plus"></i> Create First Template
                                                </a>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="template" items="${templates}">
                                            <tr>
                                                <td><strong>#${template.templateId}</strong></td>
                                                <td>
                                                    <i class="fas fa-tag text-primary"></i>
                                                    <strong>${template.shiftName}</strong>
                                                </td>
                                                <td>
                                                    <span class="badge" style="background: #6366f1;">
                                                        ${template.position}
                                                    </span>
                                                </td>
                                                <td>
                                                    <i class="fas fa-clock text-success"></i>
                                                    <fmt:formatDate value="${template.startTime}" pattern="HH:mm" />
                                                </td>
                                                <td>
                                                    <i class="fas fa-clock text-danger"></i>
                                                    <fmt:formatDate value="${template.endTime}" pattern="HH:mm" />
                                                </td>
                                                <td>
                                                    <c:set var="startHour" value="${template.startTime.hours}" />
                                                    <c:set var="endHour" value="${template.endTime.hours}" />
                                                    <c:set var="duration" value="${endHour - startHour}" />
                                                    <span class="badge bg-info">${duration} hours</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${template.isActive}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check-circle"></i> Active
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="fas fa-ban"></i> Inactive
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/shift-management?action=edit-template&id=${template.templateId}" 
                                                           class="btn btn-sm btn-warning" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/shift-management?action=toggle-template&id=${template.templateId}" 
                                                           class="btn btn-sm btn-info" title="Toggle Status">
                                                            <i class="fas fa-toggle-on"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Business Rules Card -->
            <div class="card mt-4">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-book text-info"></i> Shift Template Rules</h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>Shift templates are reusable definitions for employee scheduling</li>
                        <li>End time must be after start time for each shift</li>
                        <li>Templates can be activated or deactivated without deletion</li>
                        <li>Only active templates can be used for new shift assignments</li>
                        <li>Templates help maintain consistency in shift scheduling</li>
                    </ul>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
