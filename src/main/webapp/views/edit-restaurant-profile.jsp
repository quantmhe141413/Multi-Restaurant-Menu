<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

                <div class="form-group">
                    <label>Restaurant Image URL <small class="text-muted">(for display on home page)</small></label>
                    <input type="url" name="logoUrl" id="logoUrlInput" value="${restaurant.logoUrl}"
                           placeholder="https://example.com/image.jpg" required>
                    <div class="mt-2" id="logoPreviewWrap" style="${empty restaurant.logoUrl ? 'display:none' : ''}">
                        <img id="logoPreview" src="${restaurant.logoUrl}" alt="Logo Preview"
                             style="width:100%;max-height:200px;object-fit:cover;border-radius:8px;border:1px solid #eee;">
                    </div>
                </div>

                <div class="mt-4 pt-2">
                    <button type="submit" class="btn-submit">Save Changes</button>
                    <div class="d-flex justify-content-end mt-3">
                        <a href="profile" class="text-decoration-none text-muted fw-bold">
                            <i class="fas fa-arrow-left me-1"></i> Back to Profile
                        </a>
                    </div>
                </div>
            </form>

            <%-- Business License Upload Section --%>
            <div class="mt-4 pt-2" style="border-top: 2px solid #f1f5f9;">
                <h5 style="font-weight:700; color:#1e293b; margin-bottom:0.5rem;">
                    <i class="fas fa-file-certificate me-2 text-danger"></i>Giấy phép kinh doanh
                </h5>
                <p class="text-muted small mb-3">Bắt buộc để admin có thể phê duyệt nhà hàng của bạn.</p>

                <c:choose>
                    <c:when test="${not empty restaurant.licenseFileUrl}">
                        <c:set var="licHref" value="${restaurant.licenseFileUrl}" />
                        <c:choose>
                            <c:when test="${fn:startsWith(licHref, 'http://') || fn:startsWith(licHref, 'https://')}">
                                <c:set var="licResolved" value="${licHref}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="licResolved" value="${pageContext.request.contextPath}${licHref}" />
                            </c:otherwise>
                        </c:choose>
                        <div class="alert alert-success d-flex align-items-center gap-3 mb-3">
                            <i class="fas fa-check-circle fs-5"></i>
                            <div>
                                <strong>Đã upload</strong><br>
                                <a href="${licResolved}" target="_blank" rel="noopener noreferrer" class="text-success small">
                                    <i class="fas fa-external-link-alt me-1"></i>Xem file giấy phép
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning d-flex align-items-center gap-3 mb-3">
                            <i class="fas fa-exclamation-triangle fs-5"></i>
                            <div><strong>Chưa upload</strong> — Cần upload để được phê duyệt.</div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <form method="post" action="${pageContext.request.contextPath}/business-license-upload"
                      enctype="multipart/form-data">
                    <div class="form-group mb-3">
                        <label><i class="fas fa-file-alt me-1"></i> Chọn file (PDF/JPG/PNG, tối đa 10MB)</label>
                        <input type="file" name="licenseFile" accept="application/pdf,image/*" required
                               style="margin-top:0.4rem;">
                    </div>
                    <button type="submit" class="btn-submit" style="background: linear-gradient(135deg,#e31837,#c0392b);">
                        <i class="fas fa-upload me-1"></i> Upload Giấy phép
                    </button>
                </form>

                <c:if test="${not empty licenseError}">
                    <div class="alert alert-danger mt-3"><i class="fas fa-exclamation-triangle me-2"></i>${licenseError}</div>
                </c:if>
                <c:if test="${not empty licenseSuccess}">
                    <div class="alert alert-success mt-3"><i class="fas fa-check-circle me-2"></i>${licenseSuccess}</div>
                </c:if>
            </div>


            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3"><i class="fas fa-exclamation-triangle me-2"></i>${error}</div>
            </c:if>
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
    <script>
        (function() {
            var input = document.getElementById('logoUrlInput');
            var preview = document.getElementById('logoPreview');
            var wrap = document.getElementById('logoPreviewWrap');
            if (input && preview && wrap) {
                input.addEventListener('input', function() {
                    var url = input.value.trim();
                    if (url) {
                        preview.src = url;
                        wrap.style.display = '';
                    } else {
                        wrap.style.display = 'none';
                    }
                });
                preview.addEventListener('error', function() {
                    wrap.style.display = 'none';
                });
            }

            // Validation logic
            const form = document.querySelector('form[action="edit-restaurant-profile"]');
            const phoneInput = document.querySelector('input[name="phone"]');
            const nameInput = document.querySelector('input[name="name"]');
            const addressInput = document.querySelector('input[name="address"]');
            const descInput = document.querySelector('textarea[name="description"]');
            const logoInput = document.getElementById('logoUrlInput');

            form.addEventListener('submit', function(event) {
                const phonePattern = /^0[0-9]{9}$/;
                const urlPattern = /^(https?|ftp):\/\/[^\s\/$.?#].[^\s]*$/;

                if (nameInput.value.trim() === '') {
                    event.preventDefault();
                    Swal.fire('Lỗi', 'Tên nhà hàng không được để trống.', 'warning');
                    return;
                }

                if (addressInput.value.trim() === '') {
                    event.preventDefault();
                    Swal.fire('Lỗi', 'Địa chỉ không được để trống.', 'warning');
                    return;
                }

                if (!phonePattern.test(phoneInput.value.trim())) {
                    event.preventDefault();
                    Swal.fire('Lỗi', 'Số điện thoại Việt Nam không hợp lệ (phải bắt đầu bằng 0 và có 10 chữ số).', 'warning');
                    return;
                }

                if (descInput.value.length > 500) {
                    event.preventDefault();
                    Swal.fire('Lỗi', 'Mô tả không được vượt quá 500 ký tự.', 'warning');
                    return;
                }

                if (logoInput.value.trim() === '') {
                    event.preventDefault();
                    Swal.fire('Lỗi', 'Vui lòng cung cấp URL ảnh nhà hàng.', 'warning');
                    return;
                }

                if (!urlPattern.test(logoInput.value.trim())) {
                    event.preventDefault();
                    Swal.fire('Lỗi', 'Định dạng URL ảnh không hợp lệ.', 'warning');
                    return;
                }
            });
        })();
    </script>
</body>
</html>
