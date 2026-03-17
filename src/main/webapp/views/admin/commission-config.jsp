<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Commission Configuration" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/includes/std_head.jsp" />
    <title>${pageTitle}</title>
</head>
<body>
<jsp:include page="/views/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/views/includes/admin-sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header">
                <h1><i class="fas fa-percent text-primary"></i> Commission Configuration</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item active">Commission Configuration</li>
                    </ol>
                </nav>
            </div>

            <jsp:include page="/views/commission/commission-edit-form.jsp" />

            <jsp:include page="/views/commission/commission-search-filter.jsp" />

            <jsp:include page="/views/commission/commission-table.jsp" />

            <c:set var="paginationUrl" value="${pageContext.request.contextPath}/admin/commission?action=list" scope="request" />
            <c:if test="${not empty param.status}">
                <c:set var="paginationUrl" value="${paginationUrl}&status=${param.status}" scope="request" />
            </c:if>
            <c:if test="${not empty param.search}">
                <c:set var="paginationUrl" value="${paginationUrl}&search=${param.search}" scope="request" />
            </c:if>

            <c:set var="paginationTotal" value="${totalRestaurants}" scope="request" />
            <c:set var="paginationLabel" value="restaurants" scope="request" />
            <jsp:include page="/views/includes/common/pagination.jsp" />

        </main>
    </div>
</div>

<jsp:include page="/views/includes/footer.jsp" />
</body>
</html>
