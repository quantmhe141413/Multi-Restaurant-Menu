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
        <div class="auth-card" style="max-width: 600px;">
            <h1>Chỉnh sửa hồ sơ nhà hàng</h1>
            <p class="text-center text-muted mb-4">Cập nhật thông tin nhà hàng của bạn.</p>

            <form method="post" action="edit-restaurant-profile">
                <div class="form-group">
                    <label><i class="fas fa-store me-2"></i> Tên nhà hàng</label>
                    <input type="text" name="name" value="${restaurant.name}" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt me-2"></i> Địa chỉ</label>
                    <input type="text" name="address" value="${restaurant.address}" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-phone me-2"></i> Số điện thoại</label>
                    <input type="text" name="phone" value="${restaurant.phone}" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-align-left me-2"></i> Mô tả</label>
                    <textarea name="description" rows="4">${restaurant.description}</textarea>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn-submit">Lưu thay đổi</button>
                    <div class="text-center mt-3">
                        <a href="business-license-upload" class="text-decoration-none text-primary fw-bold">
                            <i class="fas fa-file-upload me-1"></i> Cập nhật giấy phép kinh doanh
                        </a>
                        &nbsp;|&nbsp;
                        <a href="profile" class="text-decoration-none text-secondary">
                            Quay lại hồ sơ
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
                            confirmButtonColor: '#3085d6'
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
