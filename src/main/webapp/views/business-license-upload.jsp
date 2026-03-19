<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Business License Upload - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <main class="auth-layout">
        <div class="auth-card">
            <h1>Business License</h1>
            <p class="text-center text-muted mb-4">Please upload your operating license for verification.</p>

            <form method="post" action="business-license-upload" enctype="multipart/form-data">
                <div class="form-group">
                    <label><i class="fas fa-file-alt me-2"></i> Select License File (PDF/JPG/PNG)</label>
                    <input type="file" name="licenseFile" accept="application/pdf,image/*" required>
                    <small class="text-muted d-block mt-2">Max file size: 5MB</small>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn-submit">Upload License</button>
                    <a href="restaurant-profile-setup" class="btn btn-link w-100 text-decoration-none text-muted mt-2">Back to Setup</a>
                </div>
            </form>

            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${error}
                </div>
            </c:if>
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
