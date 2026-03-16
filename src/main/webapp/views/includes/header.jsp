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
                    <c:if test="${sessionScope.user.roleID == 2}">
                        <a href="categories?action=list" class="nav-action">
                            <i class="fas fa-tasks"></i> Management
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.user.roleID == 3}">
                        <a href="order-management" class="nav-action">
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

<c:if test="${not empty sessionScope.user && sessionScope.user.roleID == 3}">
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

            function showOrderToast(count) {
                const DURATION_MS = 15000;
                const orderListUrl = '${pageContext.request.contextPath}' + '/order-management';
                const msg = count === 1
                    ? 'There is 1 new order waiting for preparation.'
                    : 'There are ' + count + ' new orders waiting for preparation.';

                const existing = document.getElementById('__order-notif__');
                if (existing) existing.remove();

                const wrap = document.createElement('div');
                wrap.id = '__order-notif__';
                wrap.style.cssText = 'position:fixed;top:80px;right:20px;z-index:2147483647;width:320px;'
                    + 'font-family:Inter,system-ui,sans-serif;'
                    + 'opacity:0;transform:translateX(30px);transition:opacity 0.3s ease,transform 0.3s ease;';

                wrap.innerHTML = ''
                    + '<div style="background:#fff;border-radius:12px;box-shadow:0 10px 40px rgba(99,102,241,0.18),0 2px 12px rgba(0,0,0,0.1);overflow:hidden;cursor:pointer;">'
                    +   '<div style="background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:12px 14px;display:flex;align-items:center;justify-content:space-between;">'
                    +     '<div style="display:flex;align-items:center;gap:8px;">'
                    +       '<div style="background:rgba(255,255,255,0.2);border-radius:50%;width:32px;height:32px;display:flex;align-items:center;justify-content:center;"><i class="fas fa-shopping-bag" style="color:#fff;font-size:14px;"></i></div>'
                    +       '<div>'
                    +         '<div style="color:#fff;font-weight:700;font-size:0.88rem;line-height:1.2;">New Order!</div>'
                    +         '<div style="color:rgba(255,255,255,0.8);font-size:0.72rem;">Your restaurant</div>'
                    +       '</div>'
                    +     '</div>'
                    +     '<button id="__order-notif-close__" style="background:rgba(255,255,255,0.15);border:none;color:#fff;width:24px;height:24px;border-radius:50%;font-size:14px;cursor:pointer;display:flex;align-items:center;justify-content:center;line-height:1;padding:0;flex-shrink:0;">&times;</button>'
                    +   '</div>'
                    +   '<div style="padding:12px 14px 8px;">'
                    +     '<p style="margin:0 0 6px;color:#374151;font-size:0.83rem;line-height:1.5;">' + msg + '</p>'
                    +     '<div style="display:flex;align-items:center;gap:5px;color:#6366f1;font-size:0.78rem;font-weight:600;">'
                    +       '<span>View order list</span>'
                    +       '<span style="font-size:0.9rem;">&#8594;</span>'
                    +     '</div>'
                    +   '</div>'
                    +   '<div style="padding:0 14px 10px;">'
                    +     '<div style="background:#e5e7eb;border-radius:4px;height:4px;overflow:hidden;">'
                    +       '<div id="__order-notif-bar__" style="height:100%;background:linear-gradient(90deg,#6366f1,#8b5cf6);width:100%;transition:width linear ' + DURATION_MS + 'ms;border-radius:4px;"></div>'
                    +     '</div>'
                    +   '</div>'
                    + '</div>';

                document.body.appendChild(wrap);

                requestAnimationFrame(function () {
                    requestAnimationFrame(function () {
                        wrap.style.opacity = '1';
                        wrap.style.transform = 'translateX(0)';
                        const bar = document.getElementById('__order-notif-bar__');
                        if (bar) bar.style.width = '0%';
                    });
                });

                function dismiss() {
                    wrap.style.opacity = '0';
                    wrap.style.transform = 'translateX(30px)';
                    setTimeout(function () { if (wrap.parentNode) wrap.remove(); }, 350);
                }

                wrap.querySelector('div').addEventListener('click', function (e) {
                    if (e.target.id !== '__order-notif-close__') {
                        window.location.href = orderListUrl;
                    }
                });

                document.getElementById('__order-notif-close__').addEventListener('click', function (e) {
                    e.stopPropagation();
                    dismiss();
                });

                setTimeout(dismiss, DURATION_MS);
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
                        showOrderToast(data.newOrdersCount);
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