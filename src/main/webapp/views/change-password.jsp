<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Change Password - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
    <style>
        .login-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .text-danger { color: #ff4757; }
        .text-success { color: #2ed573; }
        .form-control:focus {
            border-color: #ff4757;
            box-shadow: 0 0 0 0.2rem rgba(255, 71, 87, 0.25);
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
        <div class="login-container">
            <h2 class="text-center mb-4"><i class="fas fa-key me-2 text-danger"></i> Đổi mật khẩu</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${success}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/change-password" method="POST">
                <div class="mb-4">
                    <label class="form-label fw-bold">Mật khẩu cũ</label>
                    <input type="password" name="oldPassword" class="form-control form-control-lg" required>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-bold">Mật khẩu mới</label>
                    <input type="password" name="newPassword" class="form-control form-control-lg" required placeholder="Tối thiểu 6 ký tự">
                </div>
                <div class="mb-4">
                    <label class="form-label fw-bold">Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" class="form-control form-control-lg" required>
                </div>
                <button type="submit" class="btn btn-danger btn-lg w-100 fw-bold shadow-sm">
                    Lưu thay đổi
                </button>
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none text-muted small">
                        <i class="fas fa-arrow-left me-1"></i> Quay lại profile
                    </a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/std_scripts.jsp" />
</body>
</html>
