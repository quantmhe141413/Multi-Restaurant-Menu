<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Invoice Detail" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} - FoodieExpress</title>
    <jsp:include page="/views/includes/std_head.jsp" />
</head>
<body>
    <jsp:include page="/views/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/views/includes/restaurant-sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-file-invoice-dollar text-primary"></i> Invoice Detail</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/invoice?action=list">Invoices</a></li>
                            <li class="breadcrumb-item active">${invoice.invoiceNumber}</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/invoice?action=list" class="btn btn-secondary me-2">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                    <a href="${pageContext.request.contextPath}/invoice?action=export&id=${invoice.invoiceId}" 
                       class="btn btn-success">
                        <i class="fas fa-file-pdf"></i> Export PDF
                    </a>
                </div>
            </div>

            <!-- Invoice Detail Card -->
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <!-- Invoice Header -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h3 class="mb-3" style="color: #6366f1;">
                                <i class="fas fa-file-invoice"></i> INVOICE
                            </h3>
                            <p class="mb-1"><strong>Invoice Number:</strong> ${invoice.invoiceNumber}</p>
                            <p class="mb-1">
                                <strong>Issued Date:</strong> 
                                <fmt:formatDate value="${invoice.issuedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </p>
                            <p class="mb-1">
                                <strong>Order ID:</strong> 
                                <span class="badge bg-secondary">#${invoice.orderId}</span>
                            </p>
                        </div>
                        <div class="col-md-6 text-end">
                            <h4 style="color: #6366f1;">${invoice.restaurantName}</h4>
                            <p class="text-muted mb-0">Restaurant Invoice</p>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Customer & Order Information -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5 class="mb-3">
                                <i class="fas fa-user-circle text-primary"></i> Customer Information
                            </h5>
                            <p class="mb-1"><strong>Name:</strong> ${invoice.customerName}</p>
                            <p class="mb-1"><strong>Customer ID:</strong> #${invoice.customerId}</p>
                            <c:if test="${not empty invoice.deliveryAddress}">
                                <p class="mb-1">
                                    <strong>Delivery Address:</strong><br>
                                    <span class="text-muted">${invoice.deliveryAddress}</span>
                                </p>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <h5 class="mb-3">
                                <i class="fas fa-shopping-cart text-primary"></i> Order Information
                            </h5>
                            <p class="mb-1">
                                <strong>Order Type:</strong> 
                                <span class="badge" style="background: #6366f1;">${invoice.orderType}</span>
                            </p>
                            <p class="mb-1">
                                <strong>Order Status:</strong> 
                                <c:choose>
                                    <c:when test="${invoice.orderStatus == 'Completed'}">
                                        <span class="badge bg-success">${invoice.orderStatus}</span>
                                    </c:when>
                                    <c:when test="${invoice.orderStatus == 'Cancelled'}">
                                        <span class="badge bg-danger">${invoice.orderStatus}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">${invoice.orderStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p class="mb-1">
                                <strong>Order Date:</strong> 
                                <fmt:formatDate value="${invoice.orderDate}" pattern="yyyy-MM-dd HH:mm" />
                            </p>
                            <c:if test="${not empty invoice.deliveryStatus}">
                                <p class="mb-1">
                                    <strong>Delivery Status:</strong> 
                                    <span class="badge bg-info">${invoice.deliveryStatus}</span>
                                </p>
                            </c:if>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Financial Breakdown -->
                    <div class="row mb-4">
                        <div class="col-md-6 offset-md-6">
                            <h5 class="mb-3">
                                <i class="fas fa-calculator text-primary"></i> Financial Breakdown
                            </h5>
                            
                            <table class="table table-borderless">
                                <tbody>
                                    <tr>
                                        <td><strong>Subtotal:</strong></td>
                                        <td class="text-end">
                                            $<fmt:formatNumber value="${invoice.subtotal}" pattern="#,##0.00" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>Tax Amount:</strong></td>
                                        <td class="text-end">
                                            $<fmt:formatNumber value="${invoice.taxAmount}" pattern="#,##0.00" />
                                        </td>
                                    </tr>
                                    <tr class="border-top border-2">
                                        <td><h5><strong>Final Amount:</strong></h5></td>
                                        <td class="text-end">
                                            <h5 class="mb-0" style="color: #10b981;">
                                                <strong>$<fmt:formatNumber value="${invoice.finalAmount}" pattern="#,##0.00" /></strong>
                                            </h5>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Payment Information -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <h5 class="mb-3">
                                <i class="fas fa-credit-card text-primary"></i> Payment Information
                            </h5>
                            <div class="row">
                                <div class="col-md-4">
                                    <p class="mb-1">
                                        <strong>Payment Method:</strong> 
                                        <c:choose>
                                            <c:when test="${invoice.paymentType == 'Card'}">
                                                <span class="badge" style="background: #3b82f6;">
                                                    <i class="fas fa-credit-card"></i> Card
                                                </span>
                                            </c:when>
                                            <c:when test="${invoice.paymentType == 'Cash' or invoice.paymentType == 'COD'}">
                                                <span class="badge" style="background: #10b981;">
                                                    <i class="fas fa-money-bill"></i> ${invoice.paymentType}
                                                </span>
                                            </c:when>
                                            <c:when test="${invoice.paymentType == 'EWallet'}">
                                                <span class="badge" style="background: #8b5cf6;">
                                                    <i class="fas fa-wallet"></i> E-Wallet
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${invoice.paymentType}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="col-md-4">
                                    <p class="mb-1">
                                        <strong>Payment Status:</strong> 
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
                                                <span class="badge bg-secondary">${invoice.paymentStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <c:if test="${not empty invoice.transactionRef}">
                                    <div class="col-md-4">
                                        <p class="mb-1">
                                            <strong>Transaction Ref:</strong> 
                                            <code>${invoice.transactionRef}</code>
                                        </p>
                                    </div>
                                </c:if>
                                <c:if test="${not empty invoice.paidAt}">
                                    <div class="col-md-4">
                                        <p class="mb-1">
                                            <strong>Paid At:</strong> 
                                            <fmt:formatDate value="${invoice.paidAt}" pattern="yyyy-MM-dd HH:mm" />
                                        </p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Notice -->
                    <div class="alert alert-info mt-4" role="alert">
                        <i class="fas fa-info-circle"></i>
                        <strong>Note:</strong> This invoice is read-only and cannot be modified to ensure financial transparency.
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/invoice?action=list" class="btn btn-secondary btn-lg">
                    <i class="fas fa-arrow-left"></i> Back to Invoice List
                </a>
                <a href="${pageContext.request.contextPath}/invoice?action=export&id=${invoice.invoiceId}" 
                   class="btn btn-success btn-lg">
                    <i class="fas fa-file-pdf"></i> Export to PDF
                </a>
            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
