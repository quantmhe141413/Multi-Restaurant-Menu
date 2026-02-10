<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Multi-Restaurant Menu</title>
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

        .forgot-password-container {
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

        .demo-link {
            margin-top: 15px;
            padding: 12px;
            background: #e3f2fd;
            border-radius: 8px;
            font-size: 13px;
        }

        .demo-link a {
            color: #1976d2;
            font-weight: 600;
            word-break: break-all;
        }

        .demo-note {
            margin-top: 8px;
            color: #666;
            font-size: 12px;
            font-style: italic;
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
    <div class="forgot-password-container">
        <div class="icon-container">
            <i class="fas fa-key"></i>
        </div>
        
        <h1>Forgot Password?</h1>
     

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>

        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= success %>
                
                <% String demoLink = (String) request.getAttribute("demoLink"); %>
                <% if (demoLink != null) { %>
                    <div class="demo-link">
                        <strong>Link reset (Demo):</strong><br>
                        <a href="<%= demoLink %>" target="_blank"><%= demoLink %></a>
                        <div class="demo-note">
                            * Trong thực tế, link này sẽ được gửi qua email
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <form method="post" action="forgot-password" id="forgotPasswordForm">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       placeholder="Nhập email của bạn"
                       required
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-paper-plane"></i> Gửi Link Reset
            </button>
        </form>

        <div class="back-to-login">
            Don't have an account? <a href="<%= request.getContextPath() %>/login">Back to Login</a>
        </div>
    </div>
    </main>

    <jsp:include page="includes/footer.jsp" />

    <script>
        document.getElementById('forgotPasswordForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            
            if (!email) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng nhập email',
                    confirmButtonColor: '#ff4757'
                });
                return;
            }
            
            const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Email không hợp lệ',
                    text: 'Vui lòng nhập đúng định dạng email',
                    confirmButtonColor: '#ff4757'
                });
            }
        });
    </script>
</body>
</html>
