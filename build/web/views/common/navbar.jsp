<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
.navbar {
    background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
</style>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-book-half"></i> Library System
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/books">
                        <i class="bi bi-book"></i> Books
                    </a>
                </li>
                <c:if test="${sessionScope.user.reader}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/my-borrows">
                            <i class="bi bi-clock-history"></i> Lịch sử mượn sách
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user.librarian || sessionScope.user.admin}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/borrow">
                            <i class="bi bi-arrow-left-right"></i> Borrow
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/readers">
                            <i class="bi bi-credit-card"></i> Reader Cards
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user.admin}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/users">
                            <i class="bi bi-people"></i> Staff
                        </a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
                        <span class="badge bg-light text-primary ms-1">${sessionScope.user.role}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
