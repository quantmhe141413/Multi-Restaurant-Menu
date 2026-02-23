<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>

        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 sidebar">
            <div class="sidebar-header">
                <h5><i class="fas fa-utensils"></i> Restaurant Management</h5>
            </div>
            <ul class="nav flex-column">
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
                        <i class="fas fa-hamburger"></i>
                        Menu Items
                    </a>
                </li>
            </ul>
        </nav>