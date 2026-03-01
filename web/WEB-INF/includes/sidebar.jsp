<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!-- Sidebar -->
<nav class="col-md-3 col-lg-2 sidebar">
    <div class="sidebar-header">
        <h5><i class="fas fa-store"></i> Restaurant Management</h5>
    </div>
    <ul class="nav flex-column">
        <!-- Operational Configuration Section -->
        <li class="nav-item">
            <div class="nav-section-title">
                <i class="fas fa-cog"></i> Operations
            </div>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('business-hours') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/business-hours?action=list">
                <i class="fas fa-clock"></i>
                Business Hours
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('temporary-closure') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/temporary-closure?action=list">
                <i class="fas fa-door-closed"></i>
                Temporary Closure
            </a>
        </li>
        
        <!-- Workforce Management Section -->
        <li class="nav-item mt-3">
            <div class="nav-section-title">
                <i class="fas fa-users"></i> Workforce
            </div>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('shift-management') && param.action == 'templates' ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/shift-management?action=templates">
                <i class="fas fa-calendar-alt"></i>
                Shift Templates
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('shift-management') && param.action == 'assignments' ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/shift-management?action=assignments">
                <i class="fas fa-user-clock"></i>
                Shift Assignments
            </a>
        </li>
        
        <!-- Delivery Management Section -->
        <li class="nav-item mt-3">
            <div class="nav-section-title">
                <i class="fas fa-truck-fast"></i> Delivery
            </div>
        </li>
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
        
        <!-- Financial Management Section -->
        <li class="nav-item mt-3">
            <div class="nav-section-title">
                <i class="fas fa-money-bill-wave"></i> Financial
            </div>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('invoice') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/invoice?action=list">
                <i class="fas fa-file-invoice"></i>
                Invoices
            </a>
        </li>
    </ul>
</nav>
