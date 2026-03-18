<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="isCartPage" value="${fn:endsWith(pageContext.request.requestURI, '/cart')}" />
<c:set var="isOrderHistoryPage" value="${fn:endsWith(pageContext.request.requestURI, '/order-history')}" />

<header class="site-header">
    <div class="site-header__bar">
        <a href="home" class="logo">FoodieExpress</a>
        <nav class="nav-links">
            <a href="home">Home</a>
            <a href="home">Restaurants</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:if test="${sessionScope.user.roleID == 4}">
                        <a href="order-history" class="${isOrderHistoryPage ? 'nav-action' : ''}">
                            <i class="fas fa-history"></i> Order History
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.user.roleID == 2 || sessionScope.user.roleID == 3}">
                        <a href="categories?action=list" class="nav-action">
                            <i class="fas fa-tasks"></i> Management
                        </a>
                    </c:if>
                    <a href="cart" class="${isCartPage ? 'nav-action' : ''}">
                        <i class="fas fa-shopping-cart"></i> Cart
                        <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                            <span
                                style="background: #ff4757; color: white; border-radius: 50%; padding: 2px 6px; font-size: 0.8rem; margin-left: 5px;">
                                ${sessionScope.cart.size()}
                            </span>
                        </c:if>
                    </a>
                    <a href="profile" class="nav-action">
                        <i class="fas fa-user-circle"></i> ${sessionScope.user.fullName}
                    </a>
                    <a href="logout" title="Logout" style="color: #64748b; margin-left: 1rem;"><i class="fas fa-sign-out-alt"></i></a>
                </c:when>
                <c:otherwise>
                    <a href="login">Login</a>
                    <a href="register">Register</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>

<c:if test="${not empty sessionScope.user && (sessionScope.user.roleID == 2 || sessionScope.user.roleID == 3)}">
    <script>
        (function () {
            const POLL_INTERVAL_MS = 5000;
            let lastOrderId = 0;
            let initialized = false;

            function playNewOrderSound() {
                try {
                    const AudioContext = window.AudioContext || window.webkitAudioContext;
                    if (!AudioContext) {
                        return;
                    }
                    const ctx = new AudioContext();
                    const oscillator = ctx.createOscillator();
                    const gainNode = ctx.createGain();

                    oscillator.type = 'triangle';
                    oscillator.frequency.setValueAtTime(880, ctx.currentTime);

                    gainNode.gain.setValueAtTime(0.001, ctx.currentTime);
                    gainNode.gain.exponentialRampToValueAtTime(0.1, ctx.currentTime + 0.01);
                    gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.6);

                    oscillator.connect(gainNode);
                    gainNode.connect(ctx.destination);

                    oscillator.start();
                    oscillator.stop(ctx.currentTime + 0.6);
                } catch (e) {
                    console.warn('Unable to play notification sound', e);
                }
            }

            function showBrowserNotification(count) {
                if (!("Notification" in window)) {
                    return;
                }
                if (Notification.permission === "granted") {
                    const title = "New order received";
                    const body = count === 1
                        ? "You have 1 new order to prepare."
                        : "You have " + count + " new orders to prepare.";
                    new Notification(title, { body });
                }
            }

            function requestNotificationPermissionIfNeeded() {
                if (!("Notification" in window)) {
                    return;
                }
                if (Notification.permission === "default") {
                    Notification.requestPermission();
                }
            }

            async function checkNewOrders() {
                try {
                    const ctxPath = '${pageContext.request.contextPath}';
                    const url = ctxPath + '/restaurant/order-notifications?lastOrderId=' + encodeURIComponent(lastOrderId);

                    const res = await fetch(url, {
                        method: 'GET',
                        credentials: 'same-origin',
                        headers: {
                            'Accept': 'application/json'
                        }
                    });

                    if (!res.ok) {
                        return;
                    }

                    const data = await res.json();
                    if (!data || !data.success) {
                        return;
                    }

                    if (!initialized) {
                        // First response: just record the latest order id as baseline
                        if (typeof data.latestOrderId === 'number' && data.latestOrderId > 0) {
                            lastOrderId = data.latestOrderId;
                        }
                        initialized = true;
                        return;
                    }

                    if (typeof data.latestOrderId === 'number' && data.latestOrderId > lastOrderId) {
                        lastOrderId = data.latestOrderId;
                    }

                    if (data.hasNew && data.newOrdersCount > 0) {
                        playNewOrderSound();
                        showBrowserNotification(data.newOrdersCount);

                        if (window.Swal) {
                            Swal.fire({
                                icon: 'info',
                                title: 'New order received',
                                text: data.newOrdersCount === 1
                                    ? 'There is a new order waiting for preparation.'
                                    : 'There are ' + data.newOrdersCount + ' new orders waiting for preparation.',
                                timer: 4000,
                                showConfirmButton: false,
                                toast: true,
                                position: 'top-end'
                            });
                        }
                    }
                } catch (e) {
                    // Silently ignore errors to avoid breaking the header
                    console.warn('Error while checking new orders', e);
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                requestNotificationPermissionIfNeeded();

                // Initial small delay to let page settle
                setTimeout(checkNewOrders, 3000);
                setInterval(checkNewOrders, POLL_INTERVAL_MS);
            });
        })();
    </script>
</c:if>