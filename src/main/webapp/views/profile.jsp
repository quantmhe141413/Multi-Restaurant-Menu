<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>My Profile - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
    <style>
        .profile-header {
            background: var(--gradient-primary, linear-gradient(135deg, #ff4757 0%, #ff6b81 100%));
            color: white;
            padding: 3rem 2rem;
            border-radius: var(--radius);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 2rem;
            box-shadow: 0 10px 25px rgba(255, 71, 87, 0.2);
        }
        .avatar-circle {
            width: 100px;
            height: 100px;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 800;
            border: 4px solid rgba(255,255,255,0.4);
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .profile-content {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
        }
        @media (max-width: 992px) {
            .profile-content {
                grid-template-columns: 1fr;
            }
        }
        .info-label {
            color: var(--text-muted);
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        .info-value {
            color: var(--text-main);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--border);
        }
        .badge-role {
            background: rgba(255,255,255,0.25);
            padding: 0.4rem 1rem;
            border-radius: 99px;
            font-size: 0.85rem;
            font-weight: 700;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container my-5">
        <div class="profile-header">
            <div class="avatar-circle">
                ${fn:substring(sessionScope.user.fullName, 0, 1)}
            </div>
            <div>
                <h1 class="mb-1">${sessionScope.user.fullName} (Red Theme)</h1>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-role">
                        <c:choose>
                            <c:when test="${sessionScope.user.roleID == 4}">Customer</c:when>
                            <c:when test="${sessionScope.user.roleID == 2}">Restaurant Owner</c:when>
                            <c:when test="${sessionScope.user.roleID == 3}">Restaurant Staff</c:when>
                            <c:otherwise>Administrator</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="text-white-50">• Member since <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MMM yyyy"/></span>
                </div>
            </div>
        </div>

        <div class="profile-content">
            <!-- Account Details Sidebar -->
            <div class="dashboard-card">
                <h3 class="mb-4">Account Settings</h3>
                <div class="form-group">
                    <div class="info-label">Full Name</div>
                    <div class="info-value">${sessionScope.user.fullName}</div>
                </div>
                <div class="form-group">
                    <div class="info-label">Email Address</div>
                    <div class="info-value">${sessionScope.user.email}</div>
                </div>
                <div class="form-group">
                    <div class="info-label">Phone Number</div>
                    <div class="info-value">${not empty sessionScope.user.phone ? sessionScope.user.phone : 'Not provided'}</div>
                </div>
                <hr class="my-4">
                <a href="${pageContext.request.contextPath}/change-password" class="btn btn-outline-primary w-100 py-2 fw-bold mb-2">
                    <i class="fas fa-lock me-2"></i> Change Password
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100 py-2 fw-bold">
                    <i class="fas fa-sign-out-alt me-2"></i> Logout
                </a>
            </div>

            <!-- Role-Specific Content Area -->
            <div class="dashboard-card">
                <c:choose>
                    <c:when test="${sessionScope.user.roleID == 4}">
                        <h3 class="mb-4">Customer Activity</h3>
                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="p-4 border rounded-3 bg-light text-center">
                                    <h4 class="text-muted mb-2">My Orders</h4>
                                    <p>Track your current and past orders.</p>
                                    <a href="${pageContext.request.contextPath}/order-history" class="btn btn-primary w-100">View History</a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="p-4 border rounded-3 bg-light text-center">
                                    <h4 class="text-muted mb-2">Cart</h4>
                                    <p>Continue your current order.</p>
                                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary w-100">Go to Cart</a>
                                </div>
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${sessionScope.user.roleID == 2 || sessionScope.user.roleID == 3}">
                        <h3 class="mb-4">Restaurant Business</h3>
                        <c:if test="${not empty restaurant}">
                            <div class="d-flex align-items-center gap-4 mb-4 p-3 border rounded-3">
                                <img src="${restaurant.logoUrl}" alt="${restaurant.name}" class="rounded shadow-sm" style="width: 80px; height: 80px; object-fit: cover;">
                                <div>
                                    <h4 class="mb-1">${restaurant.name}</h4>
                                    <p class="text-muted mb-0"><i class="fas fa-map-marker-alt me-1"></i> ${restaurant.address}</p>
                                    <span class="badge ${restaurant.status == 'Approved' ? 'bg-success' : 'bg-warning'} mt-2">
                                        Status: ${restaurant.status}
                                    </span>
                                    <a href="${pageContext.request.contextPath}/edit-restaurant-profile" class="btn btn-sm btn-outline-primary ms-3 mt-2">
                                        <i class="fas fa-edit me-1"></i> Edit Profile
                                    </a>
                                </div>
                            </div>
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/categories?action=list" class="text-decoration-none">
                                        <div class="p-4 border rounded-3 bg-light text-center hover-shadow transition">
                                            <i class="fas fa-utensils fa-2x text-primary mb-3"></i>
                                            <h5 class="text-dark">Menu Management</h5>
                                            <p class="text-muted small">Manage your dishes and categories</p>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/restaurant-analytics-dashboard" class="text-decoration-none">
                                        <div class="p-4 border rounded-3 bg-light text-center hover-shadow transition">
                                            <i class="fas fa-chart-line fa-2x text-primary mb-3"></i>
                                            <h5 class="text-dark">Analytics</h5>
                                            <p class="text-muted small">View sales reports and growth</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${empty restaurant}">
                            <div class="text-center p-5">
                                <i class="fas fa-store-slash fa-4x text-muted mb-3"></i>
                                <h4>No restaurant found</h4>
                                <p>Please complete your restaurant profile setup.</p>
                                <a href="${pageContext.request.contextPath}/restaurant-profile-setup" class="btn btn-primary px-4 py-2 fw-bold"> <i class="fas fa-plus-circle me-1"></i> Setup Profile</a>
                            </div>
                        </c:if>
                    </c:when>

                    <c:otherwise>
                        <div class="text-center p-5">
                            <i class="fas fa-user-shield fa-4x text-primary mb-3"></i>
                            <h4>Administrative Dashboard</h4>
                            <p>Access global system management tools.</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Go to Admin Panel</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/std_scripts.jsp" />
</body>
</html>
