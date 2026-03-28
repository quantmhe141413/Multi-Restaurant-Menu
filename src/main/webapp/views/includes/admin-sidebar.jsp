<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<style>
    .sidebar {
        min-height: calc(100vh - 76px);
        background: #ffffff;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        padding: 1.5rem 0;
    }

    .sidebar-header {
        padding: 0 1.5rem 1.25rem;
        border-bottom: 2px solid #f1f5f9;
        margin-bottom: 1rem;
    }

    .sidebar-header h5 {
        color: #1e293b;
        font-weight: 600;
        font-size: 1rem;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.6rem;
    }

    .sidebar-header h5 i {
        color: #6366f1;
    }

    .sidebar .nav-link {
        color: #475569;
        padding: 0.6rem 1.25rem;
        margin: 0.15rem 0.75rem;
        border-radius: 10px;
        font-weight: 500;
        font-size: 0.875rem;
        transition: all 0.25s ease;
        display: flex;
        align-items: center;
        gap: 0.65rem;
    }

    .sidebar .nav-link i {
        font-size: 0.95rem;
        width: 18px;
        text-align: center;
        color: #6366f1;
        opacity: 0.8;
    }

    .sidebar .nav-link:hover {
        background: rgba(99, 102, 241, 0.08);
        color: #6366f1;
        transform: translateX(3px);
    }

    .sidebar .nav-link:hover i {
        opacity: 1;
    }

    .sidebar .nav-link.active {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.15), rgba(139, 92, 246, 0.12));
        color: #6366f1;
        font-weight: 600;
        box-shadow: 0 2px 8px rgba(99, 102, 241, 0.15);
    }

    .sidebar .nav-link.active i {
        opacity: 1;
        color: #6366f1;
    }

    .main-content {
        padding: 2rem;
        background-color: #f8fafc;
        min-height: 100vh;
    }

    .page-header {
        margin-bottom: 2rem;
        border-bottom: 1px solid #e2e8f0;
        padding-bottom: 1rem;
    }

    .page-header h1 {
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }
</style>

<!-- Sidebar -->
<nav class="col-md-3 col-lg-2 sidebar">
    <div class="sidebar-header">
        <h5><i class="fas fa-user-shield"></i> Admin Panel</h5>
    </div>
    <ul class="nav flex-column">
        <c:if test="${sessionScope.user != null and sessionScope.user.roleID == 1}">
            <li class="nav-item">
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
                <a class="nav-link ${pageContext.request.requestURI.contains('restaurant-applications') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/restaurant-applications?action=list">
                    <i class="fas fa-clipboard-check"></i>
                    Restaurant Applications
                </a>
            </li>

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
                    Commission Config
                </a>
            </li>
<!--            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.contains('storefront-customization') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/storefront-customization">
                    <i class="fas fa-paint-brush"></i>
                    Restaurant Branding
                </a>
            </li>-->
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.contains('/admin/commission-history') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/commission-history?action=list">
                    <i class="fas fa-clock-rotate-left"></i>
                    Commission History
                </a>
            </li>
        </c:if>
    </ul>
</nav>
