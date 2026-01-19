<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .table-header {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            color: white;
        }
        .badge-admin {
            background-color: #dc3545;
        }
        .badge-librarian {
            background-color: #0d6efd;
        }
        .badge-reader {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="card shadow">
            <div class="card-header table-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h4 class="mb-0"><i class="bi bi-people"></i> Staff Management (Librarians)</h4>
                    <a href="${pageContext.request.contextPath}/users?action=add" class="btn btn-light">
                        <i class="bi bi-plus-circle"></i> Add New Staff
                    </a>
                </div>
            </div>
            <div class="card-body">
                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="bi bi-check-circle"></i>
                        <c:choose>
                            <c:when test="${param.success == 'added'}">Staff added successfully!</c:when>
                            <c:when test="${param.success == 'updated'}">Staff updated successfully!</c:when>
                            <c:when test="${param.success == 'deleted'}">Staff deleted successfully!</c:when>
                            <c:when test="${param.success == 'status_changed'}">Staff status changed successfully!</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-triangle"></i>
                        <c:choose>
                            <c:when test="${param.error == 'cannot_delete_self'}">Cannot delete your own account!</c:when>
                            <c:when test="${param.error == 'delete_failed'}">Failed to delete staff!</c:when>
                            <c:when test="${param.error == 'cannot_ban_self'}">Cannot ban your own account!</c:when>
                            <c:when test="${param.error == 'status_change_failed'}">Failed to change staff status!</c:when>
                            <c:when test="${param.error == 'invalid_user'}">Invalid user! Only librarian accounts can be managed.</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="u">
                                <tr>
                                    <td>${u.userId}</td>
                                    <td><i class="bi bi-person"></i> ${u.username}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.admin}">
                                                <span class="badge badge-admin">Admin</span>
                                            </c:when>
                                            <c:when test="${u.librarian}">
                                                <span class="badge badge-librarian">Librarian</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-reader">Reader</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/users?action=view&id=${u.userId}" 
                                           class="btn btn-sm btn-info text-white" title="View">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/users?action=edit&id=${u.userId}" 
                                           class="btn btn-sm btn-warning" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <c:if test="${u.userId != sessionScope.user.userId}">
                                            <c:choose>
                                                <c:when test="${u.status}">
                                                    <a href="${pageContext.request.contextPath}/users?action=ban&id=${u.userId}" 
                                                       class="btn btn-sm btn-danger" title="Ban User"
                                                       onclick="return confirm('Ban this user? They will not be able to login.')">
                                                        <i class="bi bi-ban"></i> Ban
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/users?action=ban&id=${u.userId}" 
                                                       class="btn btn-sm btn-success" title="Unban User"
                                                       onclick="return confirm('Unban this user? They will be able to login again.')">
                                                        <i class="bi bi-check-circle"></i> Unban
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <c:if test="${empty users}">
                    <div class="alert alert-info text-center">
                        <i class="bi bi-info-circle"></i> No staff members found.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
