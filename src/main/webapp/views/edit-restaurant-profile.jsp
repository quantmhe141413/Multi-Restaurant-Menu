<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Edit Restaurant Profile - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <main class="auth-layout">
        <div class="auth-card" style="max-width: 650px;">
            <h1>Edit Restaurant Profile</h1>
            <p class="text-center text-muted mb-4">Update your business information to stay up to date.</p>

            <form method="post" action="edit-restaurant-profile">
                <div class="form-group">
                    <label>Restaurant Name</label>
                    <input type="text" name="name" value="${restaurant.name}" placeholder="e.g. Italian Bistro" required>
                </div>

                <div class="form-group">
                    <label>Business Address</label>
                    <input type="text" name="address" value="${restaurant.address}" placeholder="Street, City, State" required>
                </div>

                <div class="form-group">
                    <label>Contact Phone</label>
                    <input type="text" name="phone" value="${restaurant.phone}" placeholder="Phone number" required>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4" placeholder="Tell customers about your restaurant...">${restaurant.description}</textarea>
                </div>

                <div class="mt-4 pt-2">
                    <button type="submit" class="btn-submit">Save Changes</button>
                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <a href="business-license-upload" class="text-decoration-none text-primary fw-bold">
                            <i class="fas fa-file-upload me-1"></i> Business License
                        </a>
                        <a href="profile" class="text-decoration-none text-muted fw-bold">
                            <i class="fas fa-arrow-left me-1"></i> Back to Profile
                        </a>
                    </div>
                </div>
            </form>

            <c:if test="${not empty success}">
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        Swal.fire({
                            icon: 'success',
                            title: 'Thành công!',
                            text: '${success}',
                            confirmButtonColor: '#ff4757'
                        });
                    });
                </script>
            </c:if>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/std_scripts.jsp" />
</body>
</html>
