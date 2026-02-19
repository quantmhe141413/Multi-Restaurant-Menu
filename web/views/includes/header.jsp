<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <header class="site-header">
        <div class="site-header__bar">
            <a href="home" class="logo">FoodieExpress</a>
            <nav class="nav-links">
                <a href="home">Home</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="nav-user">Welcome, ${sessionScope.user.fullName}</span>
                        <a href="logout" class="nav-action">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login">Login</a>
                        <a href="register">Register</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>