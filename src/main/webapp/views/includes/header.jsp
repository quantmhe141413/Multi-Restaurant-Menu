<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="isCartPage" value="${fn:endsWith(pageContext.request.requestURI, '/cart')}" />
<c:set var="isOrderHistoryPage" value="${fn:endsWith(pageContext.request.requestURI, '/order-history')}" />

<header class="site-header">
    <div class="site-header__bar">
        <a href="${pageContext.request.contextPath}/home" class="logo">FoodieExpress</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/home">Restaurants</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:if test="${sessionScope.user.roleID == 1}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link px-3 py-2 text-dark fw-bold">
                            <i class="fas fa-chart-pie me-2"></i>Admin
                        </a>
                    </c:if>

                    <c:if test="${sessionScope.user.roleID == 2}">
                        <a href="${pageContext.request.contextPath}/categories?action=list" class="btn btn-danger rounded-pill px-4 py-2 ms-2 fw-bold text-white shadow-sm" style="font-size: 0.85rem; border: none; min-width: 130px;">
                            <i class="fas fa-tasks me-1"></i> Management
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.user.roleID == 3}">
                        <a href="${pageContext.request.contextPath}/order-management" class="btn btn-danger rounded-pill px-4 py-2 ms-2 fw-bold text-white shadow-sm" style="font-size: 0.85rem; border: none; min-width: 130px;">
                            <i class="fas fa-tasks me-1"></i> Management
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/cart" class="nav-link px-3 py-2 text-dark position-relative ms-2">
                        <i class="fas fa-shopping-cart fs-5"></i>
                        <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem; border: 1.5px solid #fff;">
                                ${sessionScope.cart.size()}
                            </span>
                        </c:if>
                    </a>

                    <!-- Robust User Dropdown -->
                    <div class="dropdown ms-3" id="userAccountDropdown">
                        <button class="btn btn-white d-flex align-items-center border rounded-pill px-3 py-2 shadow-sm" 
                                type="button" id="userMenuBtn"
                                style="background: #fff; border: 1.5px solid #eee !important; cursor: pointer;">
                            <i class="fas fa-user-circle me-2 text-danger fs-5"></i>
                            <span class="fw-bold text-dark me-1" style="font-size: 0.92rem;">${sessionScope.user.fullName}</span>
                            <i class="fas fa-chevron-down ms-1 small text-muted"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2 mt-2" id="userMenuContent" style="border-radius: 12px; min-width: 220px; z-index: 2000;">
                            <c:if test="${sessionScope.user.roleID != 1}">
                                <li><a class="dropdown-item rounded-3 py-2" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user-edit me-2 opacity-75"></i> My Profile</a></li>
                                </c:if>
                                <c:if test="${sessionScope.user.roleID == 2 || sessionScope.user.roleID == 3}">
                                <li><a class="dropdown-item rounded-3 py-2" href="${pageContext.request.contextPath}/edit-restaurant-profile"><i class="fas fa-store-alt me-2 opacity-75"></i> Edit Restaurant</a></li>
                                </c:if>
                            <li><hr class="dropdown-divider my-2"></li>
                            <li><a class="dropdown-item rounded-3 py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
                        </ul>
                    </div>

                    <!-- Fail-safe Toggle Script -->
                    <script>
                        (function () {
                            const btn = document.getElementById('userMenuBtn');
                            const menu = document.getElementById('userMenuContent');

                            if (btn && menu) {
                                btn.addEventListener('click', function (e) {
                                    e.stopPropagation();
                                    const isShown = menu.classList.contains('show');
                                    // Close all other dropdowns if any
                                    document.querySelectorAll('.dropdown-menu.show').forEach(m => m.classList.remove('show'));
                                    if (!isShown)
                                        menu.classList.add('show');
                                });

                                document.addEventListener('click', function () {
                                    menu.classList.remove('show');
                                });
                            }
                        })();
                    </script>

                    <style>
                        /* Ensure the 'show' class works even if Bootstrap JS fails */
                        .dropdown-menu.show {
                            display: block !important;
                            opacity: 1 !important;
                            visibility: visible !important;
                            transform: translateY(0) !important;
                        }
                    </style>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                    <a href="${pageContext.request.contextPath}/register">Register</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>

<c:if test="${not empty sessionScope.user && sessionScope.user.roleID == 3}">
    <script>
        (function () {
            const POLL_INTERVAL_MS = 5000;
            const TOAST_DURATION_MS = 15000;
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
                    new Notification(title, {body});
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

            function showOrderToast(count) {
                const ctxPath = '${pageContext.request.contextPath}';
                const orderListUrl = ctxPath + '/order-management';

                const msg = count === 1
                        ? 'There is 1 new order waiting for preparation.'
                        : 'There are ' + count + ' new orders waiting for preparation.';

                // Prefer iziToast if available (already used by the system)
                if (window.iziToast && typeof window.iziToast.info === 'function') {
                    window.iziToast.info({
                        title: 'New Order!',
                        message: msg,
                        position: 'topRight',
                        timeout: TOAST_DURATION_MS,
                        close: true,
                        drag: true,
                        pauseOnHover: true,
                        onClosing: function () { /* noop */
                        },
                        onClosed: function () { /* noop */
                        },
                        onClick: function () {
                            window.location.href = orderListUrl;
                        }
                    });
                    return;
                }

                // Fallback custom toast (no external dependency)
                const existing = document.getElementById('__order-notif__');
                if (existing)
                    existing.remove();

                const wrap = document.createElement('div');
                wrap.id = '__order-notif__';
                wrap.style.cssText =
                        'position:fixed;top:80px;right:20px;z-index:2147483647;width:320px;' +
                        'font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;' +
                        'opacity:0;transform:translateX(30px);transition:opacity 0.25s ease,transform 0.25s ease;';

                wrap.innerHTML =
                        '<div style="background:#fff;border-radius:14px;box-shadow:0 10px 30px rgba(15,23,42,.15);overflow:hidden;cursor:pointer;">' +
                        '  <div style="background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:12px 14px;display:flex;align-items:center;justify-content:space-between;">' +
                        '    <div style="display:flex;align-items:center;gap:10px;">' +
                        '      <div style="background:rgba(255,255,255,.18);border-radius:12px;width:34px;height:34px;display:flex;align-items:center;justify-content:center;">' +
                        '        <i class="fas fa-shopping-bag" style="color:#fff;font-size:14px;"></i>' +
                        '      </div>' +
                        '      <div>' +
                        '        <div style="color:#fff;font-weight:700;font-size:.92rem;line-height:1.2;">New Order!</div>' +
                        '        <div style="color:rgba(255,255,255,.85);font-size:.75rem;">Tap to open order list</div>' +
                        '      </div>' +
                        '    </div>' +
                        '    <button id="__order-notif-close__" type="button" aria-label="Close" style="background:rgba(255,255,255,.18);border:none;color:#fff;width:28px;height:28px;border-radius:10px;font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;line-height:1;padding:0;">&times;</button>' +
                        '  </div>' +
                        '  <div style="padding:12px 14px 10px;">' +
                        '    <div style="color:#334155;font-size:.85rem;line-height:1.45;">' + msg + '</div>' +
                        '    <div style="margin-top:8px;display:flex;align-items:center;gap:6px;color:#6366f1;font-size:.78rem;font-weight:600;">' +
                        '      <span>View order list</span><span style="font-size:.95rem;">&#8594;</span>' +
                        '    </div>' +
                        '  </div>' +
                        '  <div style="padding:0 14px 12px;">' +
                        '    <div style="background:#e2e8f0;border-radius:999px;height:4px;overflow:hidden;">' +
                        '      <div id="__order-notif-bar__" style="height:100%;background:linear-gradient(90deg,#6366f1,#8b5cf6);width:100%;transition:width linear ' + TOAST_DURATION_MS + 'ms;"></div>' +
                        '    </div>' +
                        '  </div>' +
                        '</div>';

                document.body.appendChild(wrap);

                // Animate in
                requestAnimationFrame(function () {
                    wrap.style.opacity = '1';
                    wrap.style.transform = 'translateX(0)';
                });

                const closeBtn = wrap.querySelector('#__order-notif-close__');
                const bar = wrap.querySelector('#__order-notif-bar__');
                let closed = false;

                function closeToast() {
                    if (closed)
                        return;
                    closed = true;
                    wrap.style.opacity = '0';
                    wrap.style.transform = 'translateX(30px)';
                    setTimeout(function () {
                        if (wrap && wrap.parentNode)
                            wrap.parentNode.removeChild(wrap);
                    }, 280);
                }

                if (closeBtn) {
                    closeBtn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        closeToast();
                    });
                }

                wrap.addEventListener('click', function () {
                    window.location.href = orderListUrl;
                });

                // Start progress bar
                if (bar) {
                    requestAnimationFrame(function () {
                        bar.style.width = '0%';
                    });
                }

                setTimeout(closeToast, TOAST_DURATION_MS);
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
