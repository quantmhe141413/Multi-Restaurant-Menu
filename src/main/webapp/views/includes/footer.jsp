<footer class="site-footer mt-auto py-5 text-white">
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-4 col-md-6">
                <a href="${pageContext.request.contextPath}/home" class="logo mb-3 d-inline-block">FoodieExpress</a>
                <p class="text-muted mb-4">Discover the best food near you. We connect you with the top-rated
                    restaurants in your city.</p>
                <div class="social-links">
                    <a href="#" class="me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-3 col-6">
                <h6 class="text-uppercase fw-bold mb-4">Company</h6>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/home" class="text-muted">Home</a></li>
                    <li><a href="#" class="text-muted">Explore</a></li>
                    <li><a href="#" class="text-muted">About Us</a></li>
                    <li><a href="#" class="text-muted">Contact</a></li>
                </ul>
            </div>

            <div class="col-lg-2 col-md-3 col-6">
                <h6 class="text-uppercase fw-bold mb-4">Support</h6>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-muted">Help Center</a></li>
                    <li><a href="#" class="text-muted">Terms of Service</a></li>
                    <li><a href="#" class="text-muted">Privacy Policy</a></li>
                    <li><a href="#" class="text-muted">FAQ</a></li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-12">
                <h6 class="text-uppercase fw-bold mb-4">Get in Touch</h6>
                <p class="text-muted"><i class="fas fa-map-marker-alt me-2"></i> 123 Foodie Street, Kitchen City, FC
                    45678</p>
                <p class="text-muted"><i class="fas fa-phone me-2"></i> +1 234 567 890</p>
                <p class="text-muted"><i class="fas fa-envelope me-2"></i> support@foodieexpress.com</p>
            </div>
        </div>
        <hr class="my-4 border-secondary">
        <div class="row">
            <div class="col-md-12 text-center text-muted">
                <small>&copy; 2026 FoodieExpress. All rights reserved.</small>
            </div>
        </div>
    </div>
</footer>

<style>
    .site-footer {
        background-color: #0f172a;
        color: #f8fafc;
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        padding: 3rem 0;
        margin-top: auto;
    }

    /* Self-contained Grid System */
    .site-footer .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 1.5rem;
    }

    .site-footer .row {
        display: flex;
        flex-wrap: wrap;
        margin-left: -15px;
        margin-right: -15px;
    }

    .site-footer [class*="col-"] {
        padding: 0 15px;
        box-sizing: border-box;
    }

    /* Column Definitions */
    .site-footer .col-lg-4 {
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }

    .site-footer .col-lg-2 {
        flex: 0 0 16.666667%;
        max-width: 16.666667%;
    }

    @media (max-width: 991px) {
        .site-footer .col-md-6 {
            flex: 0 0 50%;
            max-width: 50%;
        }

        .site-footer .col-md-3 {
            flex: 0 0 25%;
            max-width: 25%;
        }

        .site-footer .col-lg-4,
        .site-footer .col-lg-2 {
            flex: 0 0 50%;
            max-width: 50%;
        }
    }

    @media (max-width: 575px) {
        .site-footer .col-6 {
            flex: 0 0 100%;
            max-width: 100%;
        }

        .site-footer [class*="col-"] {
            flex: 0 0 100%;
            max-width: 100%;
            margin-bottom: 2rem;
        }
    }

    .site-footer .logo {
        font-size: 1.75rem;
        font-weight: 800;
        color: #ef4444;
        letter-spacing: -0.025em;
        text-decoration: none;
        display: inline-block;
        margin-bottom: 1rem;
    }

    .site-footer h6 {
        font-size: 0.875rem;
        letter-spacing: 0.05em;
        color: #f1f5f9;
        text-transform: uppercase;
        font-weight: 700;
        margin-bottom: 1.5rem;
        margin-top: 0;
    }

    .site-footer .text-muted {
        color: #94a3b8 !important;
        text-decoration: none;
        transition: color 0.2s;
        font-size: 0.9375rem;
    }

    .site-footer a.text-muted:hover {
        color: #ffffff !important;
    }

    .site-footer .social-links {
        display: flex;
        gap: 0.75rem;
        margin-top: 1rem;
    }

    .site-footer .social-links a {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        background-color: rgba(255, 255, 255, 0.05);
        border-radius: 50%;
        color: #cbd5e1;
        transition: all 0.3s;
        text-decoration: none;
    }

    .site-footer .social-links a:hover {
        background-color: #ef4444;
        color: #ffffff;
        transform: translateY(-3px);
    }

    /* List Resets */
    .site-footer ul {
        padding-left: 0;
        margin-top: 0;
        margin-bottom: 0;
        list-style: none !important;
        /* Force remove bullets */
    }

    .site-footer ul li {
        margin-bottom: 0.75rem;
        list-style-type: none !important;
        /* Extra safety */
    }

    .site-footer hr {
        border: 0;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        margin: 2rem 0;
    }

    .site-footer .text-center {
        text-align: center;
    }

    .site-footer .mt-auto {
        margin-top: auto;
    }

    .site-footer .mb-4 {
        margin-bottom: 1.5rem;
    }

    .site-footer .d-inline-block {
        display: inline-block;
    }
</style>