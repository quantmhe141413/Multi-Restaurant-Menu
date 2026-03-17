<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty editRestaurant}">
    <div class="card mb-4">
        <div class="card-header">
            <h4 class="mb-0"><i class="fas fa-pen-to-square"></i> Update Commission Rate</h4>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="text-muted small">Restaurant</div>
                    <div><strong>${editRestaurant.name}</strong></div>
                    <div class="text-muted small">Owner: ${editRestaurant.ownerName} (${editRestaurant.ownerEmail})</div>
                </div>
                <div class="col-md-6">
                    <form action="${pageContext.request.contextPath}/admin/commission" method="POST">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${editRestaurant.restaurantId}">

                        <c:if test="${not empty param.status}">
                            <input type="hidden" name="status" value="${param.status}">
                        </c:if>
                        <c:if test="${not empty param.search}">
                            <input type="hidden" name="search" value="${param.search}">
                        </c:if>
                        <c:if test="${not empty param.page}">
                            <input type="hidden" name="page" value="${param.page}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label text-muted small mb-1">Commission Rate (0 - 100)</label>
                            <input class="form-control" type="number" name="commissionRate" step="0.01" min="0" max="100"
                                   value="${editRestaurant.commissionRate}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted small mb-1">Reason <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="3" required
                                      placeholder="Why are you changing this commission rate?"></textarea>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save
                            </button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/commission?action=list">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</c:if>
