<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <tr>
                        <th>ID</th>
                        <th>Restaurant</th>
                        <th>Owner</th>
                        <th>Status</th>
                        <th>Commission Rate</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty restaurants}">
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <p class="text-muted mb-0">No restaurants found</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${restaurants}">
                                <tr>
                                    <td>${r.restaurantId}</td>
                                    <td>
                                        <strong>${r.name}</strong>
                                        <div class="text-muted small">${r.licenseNumber}</div>
                                    </td>
                                    <td>
                                        <div><strong>${r.ownerName}</strong></div>
                                        <div class="text-muted small">${r.ownerEmail}</div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'Approved'}">
                                                <span class="badge bg-success">Approved</span>
                                            </c:when>
                                            <c:when test="${r.status == 'Rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong>${r.commissionRate}</strong>
                                    </td>
                                    <td>
                                        <c:url value="/admin/commission" var="editUrl">
                                            <c:param name="action" value="edit" />
                                            <c:param name="id" value="${r.restaurantId}" />
                                            <c:if test="${not empty param.search}">
                                                <c:param name="search" value="${param.search}" />
                                            </c:if>
                                            <c:param name="page" value="${currentPage}" />
                                        </c:url>
                                        <a class="btn btn-sm btn-warning" href="${editUrl}" title="Edit Commission">
                                            <i class="fas fa-edit"></i>
                                        </a>
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
