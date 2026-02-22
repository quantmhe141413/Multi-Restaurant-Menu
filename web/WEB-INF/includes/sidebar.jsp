<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!-- Sidebar -->
<nav class="col-md-3 col-lg-2 sidebar">
    <div class="sidebar-header">
        <h5><i class="fas fa-truck-fast"></i> Delivery Management</h5>
    </div>
    <ul class="nav flex-column">
        <c:if test="${sessionScope.user != null and sessionScope.user.roleID == 1}">
            <li class="nav-item">
<<<<<<< HEAD
=======
                <a class="nav-link ${pageContext.request.requestURI.contains('/admin/dashboard') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-chart-line"></i>
                    System Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.contains('/admin/system-report') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/system-report?action=view">
                    <i class="fas fa-file-lines"></i>
                    System Report
                </a>
            </li>
            <li class="nav-item">
>>>>>>> TrangNP
                <a class="nav-link ${pageContext.request.requestURI.contains('restaurant-applications') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/restaurant-applications?action=list">
                    <i class="fas fa-clipboard-check"></i>
                    Restaurant Applications
                </a>
            </li>
<<<<<<< HEAD
=======
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.contains('/admin/complaints') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/complaints?action=list">
                    <i class="fas fa-triangle-exclamation"></i>
                    Complaint Management
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${(pageContext.request.requestURI.contains('/admin/commission') and not pageContext.request.requestURI.contains('/admin/commission-history')) ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/commission?action=list">
                    <i class="fas fa-percent"></i>
                    Commission Configuration
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.contains('/admin/commission-history') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/commission-history?action=list">
                    <i class="fas fa-clock-rotate-left"></i>
                    Commission History
                </a>
            </li>
>>>>>>> TrangNP
        </c:if>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('coverage-zone') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/coverage-zone?action=list">
                <i class="fas fa-map-marked-alt"></i>
                Coverage Zones
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('delivery-fee') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/delivery-fee?action=list">
                <i class="fas fa-dollar-sign"></i>
                Delivery Fees
            </a>
        </li>
    </ul>
</nav>
