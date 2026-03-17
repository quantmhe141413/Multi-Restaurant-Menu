<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Commission Configuration" scope="request" />
<jsp:include page="/views/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/views/includes/admin-sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-percent text-primary"></i> Commission Configuration</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Commission Configuration</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <%-- Edit Commission Rate Form --%>
            <jsp:include page="/views/commission/commission-edit-form.jsp" />

            <%-- Build pagination URL --%>
            <c:url value="/admin/commission" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
            </c:url>

            <%-- Search / Filter --%>
            <jsp:include page="/views/commission/commission-search-filter.jsp" />

            <%-- Restaurant Commission Table --%>
            <jsp:include page="/views/commission/commission-table.jsp" />

            <%-- Pagination --%>
            <c:set var="paginationTotal" value="${totalRestaurants}" scope="request" />
            <c:set var="paginationLabel" value="restaurants" scope="request" />
            <jsp:include page="/views/includes/common/pagination.jsp" />

        </main>
    </div>
</div>

<jsp:include page="/views/includes/footer.jsp" />
