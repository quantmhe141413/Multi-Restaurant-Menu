<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - Multi-Restaurant Menu</title>
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

            .register-card {
                background-color: var(--white);
                padding: 2.5rem;
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 450px;
            }

            .register-card h1 {
                margin-top: 0;
                font-size: 1.8rem;
                color: var(--secondary);
                text-align: center;
            }

            .form-group {
                margin-bottom: 1.2rem;
            }

            .form-group label {
                display: block;
                margin-bottom: 0.4rem;
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

            .form-hint {
                font-size: 0.85rem;
                color: #747d8c;
                margin-top: 0.25rem;
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
                margin-top: 1rem;
            }

            .btn-submit:hover {
                background-color: #ff6b81;
            }

            .login-link {
                text-align: center;
                margin-top: 1.5rem;
                font-size: 0.9rem;
                color: #57606f;
            }

            .login-link a {
                color: var(--primary);
                text-decoration: none;
                font-weight: 600;
            }

            .site-footer {
                background-color: var(--secondary);
                color: var(--white);
                padding: 1.5rem 5%;
                text-align: center;
            }
        </style>
    </head>

    <body data-register-error="${error}">

        <jsp:include page="includes/header.jsp" />

        <main class="auth-layout">
            <div class="register-card">
                <h1>Create Account</h1>
                <%
                    String roleParam = request.getParameter("role");
                    String initialRoleAttr = (String) request.getAttribute("initialRole");
                    boolean isOwnerReg = "owner".equals(roleParam) || "owner".equals(initialRoleAttr);
                    String roleIDValue = isOwnerReg ? "2" : "4";
                    String roleIcon = isOwnerReg ? "fa-store" : "fa-user";
                    String roleLabel = isOwnerReg ? "Restaurant Owner Registration" : "Customer Registration";
                %>
                <form action="register?role=<%= isOwnerReg ? "owner" : "customer" %>" method="post" id="registerForm">
                    <input type="hidden" name="roleID" id="roleIDHidden" value="<%= roleIDValue %>">
                    <div style="margin-bottom: 20px; padding: 10px; background-color: #f1f2f6; border-radius: 8px; text-align: center; border-left: 4px solid var(--primary);">
                        <h2 style="margin: 0; font-size: 1.2rem; color: var(--secondary);">
                            <i class="fas <%= roleIcon %>"></i> 
                            <%= roleLabel %>
                        </h2>
                    </div>
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>

                    <!-- Restaurant Details Section -->
                    <div id="restaurantDetails" style="display: none; border: 1px solid #ddd; padding: 15px; border-radius: 8px; margin-bottom: 20px; background-color: #f9f9f9;">
                        <h3 style="margin-top: 0; font-size: 1.1rem; color: var(--secondary); margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 8px;">
                            <i class="fas fa-store"></i> Restaurant Information
                        </h3>
                        <div class="form-group">
                            <label for="restaurantName">Restaurant Name</label>
                            <input type="text" id="restaurantName" name="restaurantName">
                        </div>
                        <div class="form-group">
                            <label for="restaurantAddress">Restaurant Address</label>
                            <input type="text" id="restaurantAddress" name="restaurantAddress">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">Register</button>
                </form>

                <div class="login-link">
                    Already have an account? <a href="login">Login here</a>
                </div>
            </div>
        </main>

        <jsp:include page="includes/footer.jsp" />

        <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('registerForm');
            const fullNameInput = document.getElementById('fullName');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            const restaurantDetails = document.getElementById('restaurantDetails');
            const roleIDInput = document.getElementById('roleIDHidden');
            const restaurantNameInput = document.getElementById('restaurantName');
            const restaurantAddressInput = document.getElementById('restaurantAddress');

            function toggleRestaurantFields() {
                const isOwner = roleIDInput.value === '2';
                
                if (isOwner) {
                    restaurantDetails.style.display = 'block';
                    restaurantNameInput.required = true;
                    restaurantAddressInput.required = true;
                } else {
                    restaurantDetails.style.display = 'none';
                    restaurantNameInput.required = false;
                    restaurantAddressInput.required = false;
                }
            }

            // Trigger initially to handle pre-selected roles
            toggleRestaurantFields();

            form.addEventListener('submit', function (event) {
                const fullName = fullNameInput.value.trim();
                const email = emailInput.value.trim();
                const password = passwordInput.value.trim();
                const confirmPassword = confirmPasswordInput.value.trim();

                const isOwner = roleIDInput.value === '2';

                if (fullName.length < 3) {
                    event.preventDefault();
                    Swal.fire('Invalid name', 'Full name must be at least 3 characters.', 'warning');
                    return;
                }

                if (!emailPattern.test(email)) {
                    event.preventDefault();
                    Swal.fire('Invalid email', 'Please enter a valid email address.', 'warning');
                    return;
                }

                if (password.length < 6) {
                    event.preventDefault();
                    Swal.fire('Weak password', 'Password must be at least 6 characters.', 'warning');
                    return;
                }

                if (password !== confirmPassword) {
                    event.preventDefault();
                    Swal.fire('Password mismatch', 'Password and Confirm Password do not match.', 'error');
                    return;
                }


                if (isOwner) {
                    const rName = restaurantNameInput.value.trim();
                    const rAddress = restaurantAddressInput.value.trim();
                    if (rName.length < 2) {
                        event.preventDefault();
                        Swal.fire('Invalid Restaurant Name', 'Please enter a valid restaurant name.', 'warning');
                        return;
                    }
                    if (rAddress.length < 5) {
                        event.preventDefault();
                        Swal.fire('Invalid Restaurant Address', 'Please enter a valid restaurant address.', 'warning');
                        return;
                    }
                }
            });

            const errorMessage = document.body.dataset.registerError;
            if (errorMessage) {
                Swal.fire('Registration issue', errorMessage, 'error');
            }
        });
        </script>

    </body>

    </html>