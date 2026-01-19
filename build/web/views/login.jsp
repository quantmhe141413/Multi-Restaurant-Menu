<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            max-width: 400px;
            width: 100%;
        }
        .login-header {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .login-header i {
            font-size: 48px;
            margin-bottom: 10px;
        }
        .login-body {
            padding: 30px;
        }
        .btn-login {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
        }
        .btn-login:hover {
            background: linear-gradient(135deg, #4169e1 0%, #1e90ff 100%);
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <i class="bi bi-book-half"></i>
            <h3 class="mb-0">Library Management</h3>
            <p class="mb-0 mt-2">Please login to continue</p>
        </div>
        <div class="login-body">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if ("success".equals(request.getParameter("registered"))) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    Registration successful! Please login with your credentials.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">
                        <i class="bi bi-person-fill"></i> Username
                    </label>
                    <input type="text" class="form-control" id="username" name="username" 
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                           required autofocus>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">
                        <i class="bi bi-lock-fill"></i> Password
                    </label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-login">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Login
                    </button>
                </div>
            </form>
            
            <div class="text-center mt-3">
                <p class="mb-0">Don't have an account? 
                    <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold">
                        Register here
                    </a>
                </p>
            </div>
            
            <hr class="my-4">
            
            <div class="text-center small text-muted">
                <p class="mb-1"><strong>Demo Accounts:</strong></p>
                <p class="mb-0">Admin: admin / 123456</p>
                <p class="mb-0">Librarian: librarian1 / 123456</p>
                <p class="mb-0">Reader: reader1 / 123456</p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
