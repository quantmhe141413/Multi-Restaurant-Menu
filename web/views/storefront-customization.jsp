<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="includes/std_head.jsp" />
    <title>Storefront Customization - FoodieExpress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">
    <style>
        .preview-box {
            border: 2px dashed var(--border);
            border-radius: var(--radius);
            padding: 1.5rem;
            background: #fff;
            margin-bottom: 2rem;
        }
        .color-bubble {
            width: 80px;
            height: 40px;
            border-radius: 8px;
            border: 2px solid var(--border);
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />

    <div class="container-fluid">
        <div class="row">
            <jsp:include page="includes/restaurant-sidebar.jsp" />
            
            <main class="col-md-9 col-lg-10 main-content p-4" style="background-color: #f8fafc; min-height: 100vh;">
                <div class="row justify-content-center">
                    <div class="col-md-10">
                        <div class="dashboard-card shadow-sm border-0 p-4 bg-white rounded-3">
                    <h1 class="mb-4">Storefront Customization</h1>
                    
                    <c:if test="${not empty currentLogo || not empty currentTheme}">
                        <div class="preview-box">
                            <h4 class="mb-3">Current Appearance</h4>
                            <div class="d-flex align-items-center gap-4">
                                <c:if test="${not empty currentLogo}">
                                    <div class="text-center">
                                        <div class="small text-muted mb-1">Logo</div>
                                        <img src="${pageContext.request.contextPath}${currentLogo}" alt="current logo" 
                                             class="img-thumbnail" style="max-height: 80px; transition: transform 0.3s;">
                                    </div>
                                </c:if>
                                <div>
                                    <div class="small text-muted mb-1">Theme Color</div>
                                    <div class="color-bubble" style="background-color: ${currentTheme};"></div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <form method="post" action="storefront-customization" enctype="multipart/form-data">
                        <div class="row g-4">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="fw-bold"><i class="fas fa-image me-2"></i> Update Logo</label>
                                    <input type="file" name="logoFile" accept="image/*" class="form-control">
                                    <small class="text-muted">High resolution PNG or JPG recommended (max 5MB).</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="fw-bold"><i class="fas fa-palette me-2"></i> Theme Color</label>
                                    <div class="d-flex align-items-center gap-2">
                                        <input type="color" name="themeColor" value="${not empty currentTheme ? currentTheme : '#ff4757'}" 
                                               style="width: 60px; height: 45px; cursor: pointer; border: none; padding: 0;">
                                        <span class="text-muted">Choose your brand color</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top">
                            <button type="submit" class="btn-submit" style="width: auto; padding-left: 3rem; padding-right: 3rem;">
                                Apply Changes
                            </button>
                        </div>
                    </form>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-4">
                            <i class="fas fa-times-circle me-2"></i> ${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success mt-4">
                            <i class="fas fa-check-circle me-2"></i> ${success}
                        </div>
                    </c:if>
                </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/std_scripts.jsp" />
</body>
</html>
