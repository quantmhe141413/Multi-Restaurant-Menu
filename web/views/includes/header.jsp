<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="isCartPage" value="${fn:endsWith(pageContext.request.requestURI, '/cart')}" />
<header class="site-header">
    <div class="site-header__bar">
        <a href="home" class="logo">FoodieExpress</a>
        <nav class="nav-links">
            <a href="home">Home</a>
            <a href="home">Restaurants</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="cart" class="${isCartPage ? 'nav-action' : ''}">
                        <i class="fas fa-shopping-cart"></i> Cart
                        <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                            <span style="background: #ff4757; color: white; border-radius: 50%; padding: 2px 6px; font-size: 0.8rem; margin-left: 5px;">
                                ${sessionScope.cart.size()}
                            </span>
                        </c:if>
                    </a>
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
