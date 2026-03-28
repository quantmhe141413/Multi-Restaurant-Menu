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
                    <p class="text-center text-muted mb-4">Hãy cho chúng tôi biết về nhà hàng của bạn để bắt đầu.</p>

                    <form method="post" action="restaurant-profile-setup" enctype="multipart/form-data">
                        <div class="form-group">
                            <label><i class="fas fa-store me-2"></i> Tên nhà hàng</label>
                            <input type="text" name="name" placeholder="Nhập tên nhà hàng của bạn" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-map-marker-alt me-2"></i> Địa chỉ</label>
                            <input type="text" name="address"
                                placeholder="Số nhà, Tên đường, Quận/Huyện, Tỉnh/Thành phố" required>
                        </div>





                        <div class="form-group mb-4">
                            <label><i class="fas fa-file-upload me-2"></i> Giấy phép kinh doanh (Bắt buộc)</label>
                            <input type="file" name="licenseFile" class="form-control mt-2" accept=".jpg,.jpeg,.png,.pdf" required>
                            <small class="text-muted d-block mt-1">Vui lòng tải lên ảnh hoặc PDF giấy phép kinh doanh của bạn.</small>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn-submit">Lưu hồ sơ</button>
                        </div>
                    </form>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3" style="color:#842029;background:#f8d7da;border:1px solid #f5c2c7;padding:12px;border-radius:8px;">
                            <i class="fas fa-exclamation-triangle me-2"></i> ${error}
                        </div>
                    </c:if>

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