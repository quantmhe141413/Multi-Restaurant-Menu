<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

    </div> <!-- Close main-content -->
</div> <!-- Close row -->
</div> <!-- Close container-fluid -->

<!-- Footer -->
<footer class="mt-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <p class="footer-text">
                    <i class="fas fa-utensils text-primary"></i>
                    <strong>Multi Restaurant Manager</strong> © 2026. All rights reserved.
                </p>
            </div>
            <div class="col-md-6 text-end">
                <div class="footer-links">
                    <a href="#"><i class="fas fa-book"></i> Documentation</a>
                    <a href="#"><i class="fas fa-life-ring"></i> Support</a>
                    <a href="#"><i class="fas fa-shield-alt"></i> Privacy</a>
                </div>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-12 text-center">
                <small class="text-muted">
                    Powered by modern web technologies • Built with ❤️ for restaurant management
                </small>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- iziToast JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>

<!-- Toast Notification Handler -->
<script>
    // Toast message display
    var toastMessage = '${sessionScope.toastMessage}';
    var toastType = '${sessionScope.toastType}';
    if (toastMessage && toastMessage !== '') {
        iziToast.show({
            title: toastType === 'success' ? 'Success!' : 'Error!',
            message: toastMessage,
            position: 'topRight',
            backgroundColor: toastType === 'success' ? '#10b981' : '#ef4444',
            titleColor: '#fff',
            messageColor: '#fff',
            iconColor: '#fff',
            icon: toastType === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle',
            timeout: 5000,
            progressBar: true,
            transitionIn: 'fadeInLeft',
            transitionOut: 'fadeOutRight'
        });
        // Clear session attributes
        <% 
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        %>
    }
</script>

</body>
</html>
