<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>

        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 sidebar">
            <div class="sidebar-header">
                <h5><i class="fas fa-truck-fast"></i> Delivery Management</h5>
            </div>
            <ul class="nav flex-column">
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
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('category') ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/categories?action=list">
                        <i class="fas fa-list"></i>
                        Menu Categories
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('items') ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/items?action=list">
                        <i class="fas fa-utensils"></i>
                        Menu Items
                    </a>
                </li>
            </ul>
        </nav>