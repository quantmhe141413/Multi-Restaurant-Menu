<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Change Password - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <main class="auth-layout">
        <div class="auth-card">
            <h1>Change Password</h1>
            <p class="text-center text-muted mb-4">Please enter your current and new password.</p>
            
            <form method="post" action="change-password" id="changePasswordForm">
                <div class="form-group">
                    <label><i class="fas fa-key me-2"></i> Current Password</label>
                    <input type="password" name="oldPassword" placeholder="••••••••" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-lock me-2"></i> New Password</label>
                    <input type="password" name="newPassword" id="newPassword" placeholder="••••••••" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-check-circle me-2"></i> Confirm New Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" placeholder="••••••••" required>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn-submit">Update Password</button>
                    <a href="profile" class="btn btn-link w-100 text-decoration-none text-muted mt-2">Back to Profile</a>
                </div>
            </form>

            <c:if test="${not empty error}">
                <script>
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: '${error}',
                        confirmButtonColor: '#ff4757'
                    });
                </script>
            </c:if>
            <c:if test="${not empty success}">
                <script>
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: '${success}',
                        confirmButtonColor: '#ff4757'
                    }).then(() => {
                        window.location.href = 'profile';
                    });
                </script>
            </c:if>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />
    
    <script>
    document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;
        
        if (newPass.length < 6) {
            e.preventDefault();
            Swal.fire('Weak Password', 'New password must be at least 6 characters.', 'warning');
            return;
        }
        
        if (newPass !== confirmPass) {
            e.preventDefault();
            Swal.fire('Mismatch', 'Passwords do not match.', 'error');
        }
    });
    </script>
</body>
</html>
