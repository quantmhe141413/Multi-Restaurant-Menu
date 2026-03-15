<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Mật Khẩu - Multi-Restaurant Menu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #ff4757;
            --secondary: #2f3542;
            --background: #f1f2f6;
            --white: #ffffff;
            --success: #2ecc71;
            --danger: #e74c3c;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
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

        main.auth-layout {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1rem;
        }

        .reset-password-container {
            background-color: var(--white);
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .icon-container {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .icon-container i {
            font-size: 3rem;
            color: var(--primary);
        }

        h1 {
            margin-top: 0;
            font-size: 1.8rem;
            color: var(--secondary);
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            text-align: center;
            color: #57606f;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            line-height: 1.5;
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

        .input-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #95a5a6;
            cursor: pointer;
            transition: color 0.3s;
        }

        .toggle-password:hover {
            color: var(--primary);
        }

        .form-group input {
            width: 100%;
            padding: 0.8rem;
            padding-right: 35px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            border-color: var(--primary);
        }

        .password-requirements {
            margin-top: 1rem;
            margin-bottom: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 0.85rem;
        }

        .password-requirements h4 {
            color: var(--secondary);
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .requirement {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 5px 0;
            color: #666;
        }

        .requirement i {
            font-size: 12px;
        }

        .requirement.valid {
            color: var(--success);
        }

        .requirement.invalid {
            color: #666;
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
            margin-top: 0.5rem;
        }

        .btn-submit:hover:not(:disabled) {
            background-color: #ff6b81;
        }

        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .back-to-login {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: #57606f;
        }

        .back-to-login a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .alert {
            padding: 0.8rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .success-icon {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .success-icon i {
            font-size: 4rem;
            color: var(--success);
        }

        .site-footer {
            background-color: var(--secondary);
            color: var(--white);
            padding: 1.5rem 5%;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <main class="auth-layout">
    <div class="reset-password-container">
        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null) { %>
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h1>Thành Công!</h1>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= success %>
            </div>
            <div class="back-to-login">
                Success! <a href="<%= request.getContextPath() %>/login">Login Now</a>
            </div>
        <% } else { %>
            <div class="icon-container">
                <i class="fas fa-lock"></i>
            </div>
            
            <h1>Reset Mật Khẩu</h1>
            <p class="subtitle">
                Nhập mật khẩu mới của bạn. Đảm bảo mật khẩu đủ mạnh để bảo vệ tài khoản.
            </p>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>

            <% String token = (String) request.getAttribute("token"); %>
            <% if (token != null) { %>
                <form method="post" action="reset-password" id="resetPasswordForm">
                    <input type="hidden" name="token" value="<%= token %>">
                    
                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới</label>
                        <div class="input-wrapper">
                            <input type="password" 
                                   id="newPassword" 
                                   name="newPassword" 
                                   placeholder="Nhập mật khẩu mới"
                                   required>
                            <i class="fas fa-eye toggle-password" onclick="togglePassword('newPassword')"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <div class="input-wrapper">
                            <input type="password" 
                                   id="confirmPassword" 
                                   name="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu mới"
                                   required>
                            <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword')"></i>
                        </div>
                    </div>

                    <div class="password-requirements">
                        <h4><i class="fas fa-shield-alt"></i> Yêu cầu mật khẩu:</h4>
                        <div class="requirement" id="req-length">
                            <i class="fas fa-circle"></i>
                            <span>Ít nhất 6 ký tự</span>
                        </div>
                        <div class="requirement" id="req-uppercase">
                            <i class="fas fa-circle"></i>
                            <span>Có ít nhất 1 chữ hoa</span>
                        </div>
                        <div class="requirement" id="req-number">
                            <i class="fas fa-circle"></i>
                            <span>Có ít nhất 1 số</span>
                        </div>
                        <div class="requirement" id="req-match">
                            <i class="fas fa-circle"></i>
                            <span>Mật khẩu xác nhận khớp</span>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit" id="submitBtn">
                        <i class="fas fa-save"></i> Đặt Lại Mật Khẩu
                    </button>
                </form>

                <div class="back-to-login">
                    Don't remember? <a href="<%= request.getContextPath() %>/login">Back to Login</a>
                </div>
            <% } else { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> 
                    Link reset không hợp lệ hoặc đã hết hạn.
                </div>
                <div class="back-to-login">
                    Need new link? <a href="<%= request.getContextPath() %>/forgot-password">Request Reset Link</a>
                </div>
            <% } %>
        <% } %>
    </div>
    </main>

    <jsp:include page="includes/footer.jsp" />

    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling;
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');

        function validatePassword() {
            const password = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            
            // Check length
            const reqLength = document.getElementById('req-length');
            if (password.length >= 6) {
                reqLength.classList.add('valid');
                reqLength.classList.remove('invalid');
                reqLength.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqLength.classList.remove('valid');
                reqLength.classList.add('invalid');
                reqLength.querySelector('i').className = 'fas fa-circle';
            }
            
            // Check uppercase
            const reqUppercase = document.getElementById('req-uppercase');
            if (/[A-Z]/.test(password)) {
                reqUppercase.classList.add('valid');
                reqUppercase.classList.remove('invalid');
                reqUppercase.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqUppercase.classList.remove('valid');
                reqUppercase.classList.add('invalid');
                reqUppercase.querySelector('i').className = 'fas fa-circle';
            }
            
            // Check number
            const reqNumber = document.getElementById('req-number');
            if (/[0-9]/.test(password)) {
                reqNumber.classList.add('valid');
                reqNumber.classList.remove('invalid');
                reqNumber.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqNumber.classList.remove('valid');
                reqNumber.classList.add('invalid');
                reqNumber.querySelector('i').className = 'fas fa-circle';
            }
            
            // Check match
            const reqMatch = document.getElementById('req-match');
            if (password && confirmPassword && password === confirmPassword) {
                reqMatch.classList.add('valid');
                reqMatch.classList.remove('invalid');
                reqMatch.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqMatch.classList.remove('valid');
                reqMatch.classList.add('invalid');
                reqMatch.querySelector('i').className = 'fas fa-circle';
            }
            
            // Enable/disable submit button
            const allValid = password.length >= 6 && /[A-Z]/.test(password) && 
                           /[0-9]/.test(password) && password === confirmPassword;
            submitBtn.disabled = !allValid;
        }

        if (newPasswordInput) {
            newPasswordInput.addEventListener('input', validatePassword);
            confirmPasswordInput.addEventListener('input', validatePassword);
        }

        const form = document.getElementById('resetPasswordForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                const password = newPasswordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                if (password.length < 6) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Mật khẩu quá ngắn',
                        text: 'Mật khẩu phải có ít nhất 6 ký tự',
                        confirmButtonColor: '#ff4757'
                    });
                    return;
                }
                
                if (!/[A-Z]/.test(password)) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Mật khẩu không đủ mạnh',
                        text: 'Mật khẩu phải có ít nhất 1 chữ hoa',
                        confirmButtonColor: '#ff4757'
                    });
                    return;
                }
                
                if (!/[0-9]/.test(password)) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Mật khẩu không đủ mạnh',
                        text: 'Mật khẩu phải có ít nhất 1 số',
                        confirmButtonColor: '#ff4757'
                    });
                    return;
                }
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Mật khẩu không khớp',
                        text: 'Mật khẩu xác nhận không khớp với mật khẩu mới',
                        confirmButtonColor: '#ff4757'
                    });
                }
            });
        }
    </script>
</body>
</html>
