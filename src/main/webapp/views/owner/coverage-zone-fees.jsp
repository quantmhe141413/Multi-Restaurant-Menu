<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Zone Fees - ${zone.zoneName}" scope="request" />
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
                    <h1><i class="fas fa-map-marked-alt text-primary"></i> ${zone.zoneName}
                        <small class="text-muted fs-6 ms-2">— Fees & History</small>
                    </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/coverage-zone?action=list">Coverage Zones</a></li>
                            <li class="breadcrumb-item active">${zone.zoneName} — Fees</li>
                        </ol>
                    </nav>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/delivery-fee?action=add"
                        class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Add New Fee
                    </a>
                    <a href="${pageContext.request.contextPath}/coverage-zone?action=list"
                        class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back
                    </a>
                </div>
            </div>

            <!-- Zone Info Card -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3"><span class="text-muted small">Zone Name</span><br><strong>${zone.zoneName}</strong></div>
                        <div class="col-md-3"><span class="text-muted small">Restaurant</span><br><strong>${zone.restaurantName}</strong></div>
                        <div class="col-md-3"><span class="text-muted small">Status</span><br>
                            <c:choose>
                                <c:when test="${zone.isActive}"><span class="badge bg-success">Active</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-3"><span class="text-muted small">Zone Definition</span><br>
                            <span class="text-muted">${empty zone.zoneDefinition ? '-' : zone.zoneDefinition}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Fees Section -->
            <c:choose>
                <c:when test="${empty fees}">
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <p class="text-muted">No delivery fees configured for this zone</p>
                            <a href="${pageContext.request.contextPath}/delivery-fee?action=add" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus"></i> Add First Fee
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="fee" items="${fees}">
                        <!-- Fee Card -->
                        <div class="card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center"
                                style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <div>
                                    <span class="fw-bold">Fee #${fee.feeId}</span>
                                    &nbsp;|&nbsp;
                                    <c:choose>
                                        <c:when test="${fee.feeType == 'Flat'}">
                                            <span><i class="fas fa-dollar-sign"></i> Flat — $${fee.feeValue}</span>
                                        </c:when>
                                        <c:when test="${fee.feeType == 'PercentageOfOrder'}">
                                            <span><i class="fas fa-percent"></i> Percentage — ${fee.feeValue}%</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span><i class="fas fa-gift"></i> Free Above — $${fee.feeValue}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${fee.isActive}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light text-dark">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/delivery-fee?action=edit&id=${fee.feeId}"
                                        class="btn btn-sm btn-warning" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/delivery-fee?action=toggle&id=${fee.feeId}"
                                        class="btn btn-sm btn-light" title="Toggle Status">
                                        <i class="fas fa-toggle-on"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="card-body">
                                <!-- Fee Details Row -->
                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <span class="text-muted small">Fee Type</span><br>
                                        <strong>${fee.feeType}</strong>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-muted small">Fee Value</span><br>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${fee.feeType == 'PercentageOfOrder'}">${fee.feeValue}%</c:when>
                                                <c:otherwise>$${fee.feeValue}</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-muted small">Min Order</span><br>
                                        <strong>${empty fee.minOrderAmount ? '-' : '$'.concat(fee.minOrderAmount.toString())}</strong>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-muted small">Max Order</span><br>
                                        <strong>${empty fee.maxOrderAmount ? '-' : '$'.concat(fee.maxOrderAmount.toString())}</strong>
                                    </div>
                                </div>

                                <!-- Fee Change History -->
                                <div class="mt-3">
                                    <h6 class="text-muted mb-2">
                                        <i class="fas fa-history"></i> Change History
                                        <c:set var="historyList" value="${feeHistoryMap[fee.feeId]}" />
                                        <span class="badge bg-secondary ms-1">${empty historyList ? 0 : historyList.size()}</span>
                                    </h6>
                                    <c:choose>
                                        <c:when test="${empty historyList}">
                                            <p class="text-muted small mb-0"><em>No changes recorded yet.</em></p>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-sm table-bordered mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Changed At</th>
                                                            <th>Changed By</th>
                                                            <th>Fee Type</th>
                                                            <th>Fee Value</th>
                                                            <th>Min Order</th>
                                                            <th>Max Order</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="h" items="${historyList}">
                                                            <tr>
                                                                <td>
                                                                    ${h.changedAt.toString().substring(0, 16)}
                                                                </td>
                                                                <td>${empty h.changedByName ? '-' : h.changedByName}</td>
                                                                <td>
                                                                    <c:if test="${h.oldFeeType != h.newFeeType}">
                                                                        <span class="text-danger text-decoration-line-through">${h.oldFeeType}</span>
                                                                        <i class="fas fa-arrow-right text-muted mx-1"></i>
                                                                        <span class="text-success">${h.newFeeType}</span>
                                                                    </c:if>
                                                                    <c:if test="${h.oldFeeType == h.newFeeType}">
                                                                        <span class="text-muted">${h.oldFeeType}</span>
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${h.oldFeeValue != h.newFeeValue}">
                                                                            <span class="text-danger text-decoration-line-through">${h.oldFeeValue}</span>
                                                                            <i class="fas fa-arrow-right text-muted mx-1"></i>
                                                                            <span class="text-success">${h.newFeeValue}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">${h.oldFeeValue}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:set var="oldMin" value="${h.oldMinOrder}" />
                                                                    <c:set var="newMin" value="${h.newMinOrder}" />
                                                                    <c:choose>
                                                                        <c:when test="${oldMin != newMin}">
                                                                            <span class="text-danger text-decoration-line-through">${empty oldMin ? '-' : oldMin}</span>
                                                                            <i class="fas fa-arrow-right text-muted mx-1"></i>
                                                                            <span class="text-success">${empty newMin ? '-' : newMin}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">${empty oldMin ? '-' : oldMin}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:set var="oldMax" value="${h.oldMaxOrder}" />
                                                                    <c:set var="newMax" value="${h.newMaxOrder}" />
                                                                    <c:choose>
                                                                        <c:when test="${oldMax != newMax}">
                                                                            <span class="text-danger text-decoration-line-through">${empty oldMax ? '-' : oldMax}</span>
                                                                            <i class="fas fa-arrow-right text-muted mx-1"></i>
                                                                            <span class="text-success">${empty newMax ? '-' : newMax}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">${empty oldMax ? '-' : oldMax}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
