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
                    
                    <c:if test="${not empty restaurant}">
                        <div class="d-flex justify-content-center mb-4">
                            <c:choose>
                                <c:when test="${restaurant.status == 'Approved'}">
                                    <div class="badge-status approved">
                                        <i class="fas fa-check-circle"></i> Đã phê duyệt
                                    </div>
                                </c:when>
                                <c:when test="${restaurant.status == 'Rejected'}">
                                    <div class="badge-status rejected">
                                        <i class="fas fa-times-circle"></i> Bị từ chối
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="badge-status pending">
                                        <i class="fas fa-clock"></i> Đang chờ phê duyệt
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${restaurant.status == 'Approved'}">
                             <div class="alert alert-success mt-2 mb-4 text-center">
                                <i class="fas fa-check me-2"></i> Hồ sơ của bạn đã được duyệt. Bạn có thể quản lý nhà hàng ngay bây giờ!
                                <div class="mt-2">
                                    <a href="${pageContext.request.contextPath}/restaurant-analytics-dashboard" class="btn btn-sm btn-success text-white">Đi đến trang quản lý</a>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${not empty restaurant.licenseFileUrl}">
                            <div class="alert alert-warning mt-2 mb-4 text-center">
                                <i class="fas fa-info-circle me-2"></i> Bạn đã gửi hồ sơ! Chức năng quản lý món ăn sẽ mở sau khi Admin phê duyệt.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-center text-muted mb-4">Hãy cho chúng tôi biết về nhà hàng của bạn để bắt đầu.</p>
                        </c:otherwise>
                    </c:choose>

                    <form method="post" action="restaurant-profile-setup" enctype="multipart/form-data">
                        <div class="form-group">
                            <label><i class="fas fa-store me-2"></i> Tên nhà hàng</label>
                            <input type="text" name="name" placeholder="Nhập tên nhà hàng của bạn" 
                                   value="${not empty restaurant ? restaurant.name : ''}" 
                                   ${not empty restaurant.name ? 'readonly' : ''} required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-map-marker-alt me-2"></i> Địa chỉ</label>
                            <input type="text" name="address"
                                placeholder="Số nhà, Tên đường, Quận/Huyện, Tỉnh/Thành phố" 
                                value="${not empty restaurant ? restaurant.address : ''}" 
                                ${not empty restaurant.address ? 'readonly' : ''} required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-id-card me-2"></i> Mã số giấy phép kinh doanh (Bắt buộc)</label>
                            <input type="text" name="licenseNumber" placeholder="Nhập mã số giấy phép kinh doanh" 
                                   value="${not empty restaurant ? restaurant.licenseNumber : ''}" required>
                        </div>





                        <div class="form-group mb-4">
                            <label><i class="fas fa-file-upload me-2"></i> Giấy phép kinh doanh (Bắt buộc)</label>
                            
                            <c:if test="${not empty restaurant.licenseFileUrl}">
                                <div class="mb-2">
                                    <a href="${pageContext.request.contextPath}${restaurant.licenseFileUrl}" target="_blank" class="license-view-btn">
                                        <i class="fas fa-file-alt"></i> Xem giấy phép hiện tại
                                    </a>
                                </div>
                            </c:if>

                            <input type="file" name="licenseFile" class="form-control mt-2" accept=".jpg,.jpeg,.png,.pdf" 
                                   ${not empty restaurant.licenseFileUrl ? '' : 'required'}>
                            <small class="text-muted d-block mt-1">
                                ${not empty restaurant.licenseFileUrl ? 'Tải lên tệp mới nếu bạn muốn thay đổi.' : 'Vui lòng tải lên ảnh hoặc PDF giấy phép kinh doanh của bạn.'}
                            </small>
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

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const form = document.querySelector('form');
                    const nameInput = document.querySelector('input[name="name"]');
                    const addressInput = document.querySelector('input[name="address"]');
                    const licenseNumberInput = document.querySelector('input[name="licenseNumber"]');
                    const fileInput = document.querySelector('input[name="licenseFile"]');

                    form.addEventListener('submit', function (event) {
                        if (nameInput.value.trim() === '') {
                            event.preventDefault();
                            Swal.fire('Thiếu thông tin', 'Vui lòng nhập tên nhà hàng.', 'warning');
                            return;
                        }
                        if (addressInput.value.trim() === '') {
                            event.preventDefault();
                            Swal.fire('Thiếu thông tin', 'Vui lòng nhập địa chỉ nhà hàng.', 'warning');
                            return;
                        }
                        if (licenseNumberInput.value.trim() === '') {
                            event.preventDefault();
                            Swal.fire('Thiếu thông tin', 'Vui lòng nhập mã số giấy phép kinh doanh.', 'warning');
                            return;
                        }

                        const hasExistingFile = "${not empty restaurant.licenseFileUrl}";
                        if (fileInput.files.length === 0 && hasExistingFile !== "true") {
                            event.preventDefault();
                            Swal.fire('Thiếu hồ sơ', 'Vui lòng tải lên giấy phép kinh doanh.', 'warning');
                            return;
                        }

                        // Optional: Validate file extension client-side
                        const fileName = fileInput.files[0].name;
                        const ext = fileName.split('.').pop().toLowerCase();
                        if (!['jpg', 'jpeg', 'png', 'pdf'].includes(ext)) {
                            event.preventDefault();
                            Swal.fire('Định dạng không hỗ trợ', 'Chỉ chấp nhận file .jpg, .png hoặc .pdf', 'error');
                        }
                    });
                });
            </script>
        </body>

        </html>