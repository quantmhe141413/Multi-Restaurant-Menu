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

                    <form method="post" action="restaurant-profile-setup">
                        <div class="form-group">
                            <label><i class="fas fa-store me-2"></i> Tên nhà hàng</label>
                            <input type="text" name="name" placeholder="Nhập tên nhà hàng của bạn" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-map-marker-alt me-2"></i> Địa chỉ</label>
                            <input type="text" name="address"
                                placeholder="Số nhà, Tên đường, Quận/Huyện, Tỉnh/Thành phố" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-phone me-2"></i> Số điện thoại</label>
                            <input type="text" name="phone" placeholder="098XXXXXXXX" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-align-left me-2"></i> Mô tả</label>
                            <textarea name="description" rows="4"
                                placeholder="Mô tả ngắn gọn về nhà hàng của bạn..."></textarea>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn-submit">Lưu hồ sơ</button>
                            <div class="text-center mt-3">
                                <a href="business-license-upload" class="text-decoration-none text-primary fw-bold">
                                    <i class="fas fa-file-upload me-1"></i> Tải lên giấy phép kinh doanh
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