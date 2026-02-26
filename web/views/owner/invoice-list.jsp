<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Invoice Management" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />
<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-file-invoice text-primary"></i> Invoice Management</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item active">Invoices</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <!-- Filter Card -->
            <c:url value="/invoice" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.fromDate}">
                    <c:param name="fromDate" value="${param.fromDate}" />
                </c:if>
                <c:if test="${not empty param.toDate}">
                    <c:param name="toDate" value="${param.toDate}" />
                </c:if>
            </c:url>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/invoice" method="GET">
                        <input type="hidden" name="action" value="list">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label text-muted small mb-1">
                                    <i class="fas fa-calendar-alt"></i> From Date
                                </label>
                                <input type="date" class="form-control" name="fromDate" value="${param.fromDate}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted small mb-1">
                                    <i class="fas fa-calendar-alt"></i> To Date
                                </label>
                                <input type="date" class="form-control" name="toDate" value="${param.toDate}">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter"></i> Apply Filters
                                </button>
                            </div>
                            <div class="col-md-2">
                                <a href="${pageContext.request.contextPath}/invoice?action=list" class="btn btn-secondary w-100">
                                    <i class="fas fa-redo"></i> Reset
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Invoices Table Card -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                <tr>
                                    <th>Invoice Number</th>
                                    <th>Issued Date</th>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Final Amount</th>
                                    <th>Payment Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty invoices}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">No invoices found</p>
                                                <c:if test="${not empty param.fromDate or not empty param.toDate}">
                                                    <a href="${pageContext.request.contextPath}/invoice?action=list" class="btn btn-sm btn-primary">
                                                        <i class="fas fa-redo"></i> Clear Filters
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="invoice" items="${invoices}">
                                            <tr>
                                                <td>
                                                    <strong>${invoice.invoiceNumber}</strong>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${invoice.issuedDate}" pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary">#${invoice.orderId}</span>
                                                </td>
                                                <td>
                                                    <i class="fas fa-user text-muted"></i>
                                                    ${invoice.customerName}
                                                </td>
                                                <td>
                                                    <strong style="color: #10b981;">
                                                        $<fmt:formatNumber value="${invoice.finalAmount}" pattern="#,##0.00" />
                                                    </strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${invoice.isPaid}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check-circle"></i> Paid
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${invoice.paymentStatus == 'Pending'}">
                                                            <span class="badge bg-warning">
                                                                <i class="fas fa-clock"></i> Pending
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${invoice.paymentStatus == 'Failed'}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-times-circle"></i> Failed
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                ${invoice.paymentStatus}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/invoice?action=detail&id=${invoice.invoiceId}" 
                                                           class="btn btn-sm btn-info" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/invoice?action=export&id=${invoice.invoiceId}" 
                                                           class="btn btn-sm btn-success" title="Export PDF">
                                                            <i class="fas fa-file-pdf"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <!-- First Page -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=1" title="First Page">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" title="Previous">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <!-- Page Numbers with smart pagination -->
                        <c:choose>
                            <c:when test="${totalPages <= 7}">
                                <!-- Show all pages if total <= 7 -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Smart pagination for many pages -->
                                <c:if test="${currentPage > 3}">
                                    <li class="page-item">
                                        <a class="page-link" href="${paginationUrl}&page=1">1</a>
                                    </li>
                                    <c:if test="${currentPage > 4}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                </c:if>

                                <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}" 
                                           end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" 
                                           var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <c:if test="${currentPage < totalPages - 3}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                    <li class="page-item">
                                        <a class="page-link" href="${paginationUrl}&page=${totalPages}">${totalPages}</a>
                                    </li>
                                </c:if>
                            </c:otherwise>
                        </c:choose>

                        <!-- Last Page -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" title="Next">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${totalPages}" title="Last Page">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                    <div class="text-center text-muted mt-2">
                        <small>Page ${currentPage} of ${totalPages} (Total: ${totalInvoices} invoices)</small>
                    </div>
                </nav>
            </c:if>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
