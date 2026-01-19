<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .register-header {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .register-body {
            padding: 40px;
        }
        .form-control:focus {
            border-color: #4169e1;
            box-shadow: 0 0 0 0.2rem rgba(65, 105, 225, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #1e90ff 0%, #4169e1 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
        }
        .btn-register:hover {
            background: linear-gradient(135deg, #4169e1 0%, #1e90ff 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="register-card">
                    <div class="register-header">
                        <h2><i class="bi bi-person-plus-fill"></i> Create Account</h2>
                        <p class="mb-0">Join our library community</p>
                    </div>
                    <div class="register-body">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-triangle"></i> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="bi bi-person"></i> Username <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       value="${username}" required placeholder="Choose a username">
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">
                                        <i class="bi bi-lock"></i> Password <span class="text-danger">*</span>
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           required placeholder="Enter password">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="confirmPassword" class="form-label">
                                        <i class="bi bi-lock-fill"></i> Confirm Password <span class="text-danger">*</span>
                                    </label>
                                    <input type="password" class="form-control" id="confirmPassword" 
                                           name="confirmPassword" required placeholder="Confirm password">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fullName" class="form-label">
                                    <i class="bi bi-person-badge"></i> Full Name <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${fullName}" required placeholder="Enter your full name">
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope"></i> Email
                                </label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${email}" placeholder="your.email@example.com">
                            </div>
                            
                            <div class="mb-3">
                                <label for="phone" class="form-label">
                                    <i class="bi bi-telephone"></i> Phone
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${phone}" placeholder="0901234567">
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> <small>By registering, you will be able to browse and borrow books from our library.</small>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-register w-100 mb-3">
                                <i class="bi bi-check-circle"></i> Register
                            </button>
                            
                            <div class="text-center">
                                <p class="mb-0">Already have an account? 
                                    <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                                        <strong>Login here</strong>
                                    </a>
                                </p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Client-side password validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                document.getElementById('confirmPassword').focus();
            }
        });
    </script>
</body>
</html>
