<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Multi-Restaurant Menu</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <style>
                :root {
                    --primary: #ff4757;
                    --secondary: #2f3542;
                    --background: #f1f2f6;
                    --white: #ffffff;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    margin: 0;
                    background-color: var(--background);
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                .site-header {
                    background-color: var(--white);
                    padding: 1rem 5%;
                    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                    position: sticky;
                    top: 0;
                    z-index: 100;
                }

                .site-header__bar {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .logo {
                    font-size: 1.5rem;
                    font-weight: bold;
                    color: var(--primary);
                    text-decoration: none;
                }

                .nav-links a {
                    text-decoration: none;
                    color: var(--secondary);
                    margin-left: 1.5rem;
                    font-weight: 500;
                    transition: color 0.3s;
                }

                .nav-links a:hover {
                    color: var(--primary);
                }

                .nav-user {
                    color: #57606f;
                }

                .nav-action {
                    color: var(--primary);
                    font-weight: 600;
                }

                main.auth-layout {
                    flex: 1;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    padding: 2rem 1rem;
                }

                .login-card {
                    background-color: var(--white);
                    padding: 2.5rem;
                    border-radius: 16px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 400px;
                }

                .login-card h1 {
                    margin-top: 0;
                    font-size: 1.8rem;
                    color: var(--secondary);
                    text-align: center;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.5rem;
                    font-weight: 500;
                    color: #57606f;
                }

                .form-group input {
                    width: 100%;
                    padding: 0.8rem;
                    border: 1px solid #ced4da;
                    border-radius: 8px;
                    box-sizing: border-box;
                    outline: none;
                    transition: border-color 0.3s;
                }

                .form-group input:focus {
                    border-color: var(--primary);
                }

                .btn-submit {
                    width: 100%;
                    padding: 0.9rem;
                    background-color: var(--primary);
                    color: var(--white);
                    border: none;
                    border-radius: 8px;
                    font-size: 1rem;
                    font-weight: bold;
                    cursor: pointer;
                    transition: background 0.3s;
                }

                .btn-submit:hover {
                    background-color: #ff6b81;
                }

                .register-link {
                    text-align: center;
                    margin-top: 1.5rem;
                    font-size: 0.9rem;
                    color: #57606f;
                }

                .register-link a {
                    color: var(--primary);
                    text-decoration: none;
                    font-weight: 600;
                }

                .forgot-password-link {
                    text-align: right;
                    margin-top: 0.5rem;
                    margin-bottom: 1rem;
                }

                .forgot-password-link a {
                    color: var(--primary);
                    text-decoration: none;
                    font-size: 0.85rem;
                    transition: color 0.3s;
                }

                .forgot-password-link a:hover {
                    color: #ff6b81;
                    text-decoration: underline;
                }

                .site-footer {
                    background-color: var(--secondary);
                    color: var(--white);
                    padding: 1.5rem 5%;
                    text-align: center;
                }
            </style>
        </head>

        <body data-login-error="${error}" data-registered="${param.registered}" data-logout="${param.logout}">

            <jsp:include page="includes/header.jsp" />

            <main class="auth-layout">
                <div class="login-card">
                    <h1>Login to Foodie</h1>
                    <form action="login" method="post" id="loginForm">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        <div class="forgot-password-link">
                            <a href="forgot-password"><i class="fas fa-key"></i> Forgot Password?</a>
                        </div>
                        <button type="submit" class="btn-submit">Login</button>
                    </form>

                    <div class="register-link">
                        Don't have an account? <a href="register">Register here</a>
                    </div>
                </div>
            </main>

            <jsp:include page="includes/footer.jsp" />

            <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('loginForm');
                const emailInput = document.getElementById('email');
                const passwordInput = document.getElementById('password');
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                form.addEventListener('submit', function (event) {
                    const email = emailInput.value.trim();
                    const password = passwordInput.value.trim();

                    if (!emailPattern.test(email)) {
                        event.preventDefault();
                        Swal.fire('Invalid email', 'Please enter a valid email address.', 'warning');
                        return;
                    }

                    if (password.length < 6) {
                        event.preventDefault();
                        Swal.fire('Weak password', 'Password must be at least 6 characters.', 'warning');
                    }
                });

                const errorMessage = document.body.dataset.loginError;
                if (errorMessage) {
                    Swal.fire('Login failed', errorMessage, 'error');
                }

                if (document.body.dataset.registered === '1') {
                    Swal.fire('Account created', 'You can now log in with your credentials.', 'success');
                }

                if (document.body.dataset.logout === '1') {
                    Swal.fire('Signed out', 'You have been logged out successfully.', 'info');
                }
            });
            </script>

        </body>

        </html>