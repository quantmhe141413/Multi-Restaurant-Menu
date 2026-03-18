<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Restaurant Profile Setup - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <main class="auth-layout">
        <div class="auth-card" style="max-width: 600px;">
            <h1>Restaurant Profile Setup</h1>
            <p class="text-center text-muted mb-4">Tell us about your restaurant to get started.</p>

            <form method="post" action="restaurant-profile-setup">
                <div class="form-group">
                    <label><i class="fas fa-store me-2"></i> Restaurant Name</label>
                    <input type="text" name="name" placeholder="Enter your restaurant name" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt me-2"></i> Address</label>
                    <input type="text" name="address" placeholder="123 Street, District, City" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-phone me-2"></i> Phone Number</label>
                    <input type="text" name="phone" placeholder="028XXXXXXXX" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-align-left me-2"></i> Description</label>
                    <textarea name="description" rows="4" placeholder="Briefly describe your restaurant..."></textarea>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn-submit">Save Profile</button>
                    <div class="text-center mt-3">
                        <a href="business-license-upload" class="text-decoration-none text-primary fw-bold">
                            <i class="fas fa-file-upload me-1"></i> Upload Business License
                        </a>
                    </div>
                </div>
            </form>

            <c:if test="${not empty success}">
                <div class="alert alert-success mt-3" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${success}
                </div>
            </c:if>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/std_scripts.jsp" />
</body>
</html>
