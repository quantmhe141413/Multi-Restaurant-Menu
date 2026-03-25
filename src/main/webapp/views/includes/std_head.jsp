<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Fonts: Inter & Poppins -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- FontAwesome 6 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- QuanTM Tasks Custom Styles -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/quan-tasks.css">

<style>
    :root {
        --primary-color: #ff4757;
        --secondary-color: #ff6b81;
        --accent-color: #ff7f50;
        --bg-light: #f8fafc;
        --text-main: #1e293b;
        --text-muted: #64748b;
        --white: #ffffff;
        --sidebar-bg: #ffffff;
        --gradient-primary: linear-gradient(135deg, #ff4757 0%, #ff6b81 100%);
    }

    body {
        font-family: 'Poppins', 'Inter', -apple-system, sans-serif;
        color: var(--text-main);
        background-color: #f1f5f9;
        line-height: 1.5;
        margin: 0;
        min-height: 100vh;
    }

    /* Header Styles */
    .site-header {
        background: var(--gradient-primary);
        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
        position: sticky;
        top: 0;
        z-index: 1000;
        padding: 0.85rem 0;
    }

    .site-header__bar {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .logo {
        font-size: 1.6rem;
        font-weight: 700;
        color: var(--white);
        text-decoration: none;
        letter-spacing: -0.025em;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .logo i {
        font-size: 1.8rem;
    }

    .nav-links {
        display: flex;
        gap: 1.25rem;
        align-items: center;
    }

    .nav-links a {
        text-decoration: none;
        color: rgba(255, 255, 255, 0.9);
        font-weight: 500;
        font-size: 0.95rem;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .nav-links a:hover {
        background: rgba(255, 255, 255, 0.15);
        color: var(--white);
    }

    .nav-action {
        background: rgba(255, 255, 255, 0.2);
        color: var(--white) !important;
    }
    
    /* Admin Sidebar Styles */
    .sidebar {
        min-height: calc(100vh - 76px);
        background: var(--sidebar-bg);
        box-shadow: 4px 0 15px rgba(0, 0, 0, 0.03);
        padding: 2rem 0;
        border-right: 1px solid #e2e8f0;
    }

    .sidebar-header {
        padding: 0 1.5rem 1.5rem;
        border-bottom: 2px solid #f1f5f9;
        margin-bottom: 1.5rem;
    }

    .sidebar-header h5 {
        color: var(--text-main);
        font-weight: 700;
        font-size: 1.1rem;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .sidebar-header h5 i {
        color: var(--primary-color);
    }

    .sidebar .nav-link {
        color: var(--text-muted);
        padding: 0.75rem 1.25rem;
        margin: 0.25rem 1rem;
        border-radius: 12px;
        font-weight: 500;
        font-size: 0.9rem;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.85rem;
    }

    .sidebar .nav-link i {
        font-size: 1.1rem;
        width: 24px;
        text-align: center;
        transition: transform 0.3s ease;
    }

    .sidebar .nav-link:hover {
        background: #f1f5f9;
        color: var(--primary-color);
        transform: translateX(5px);
    }

    .sidebar .nav-link.active {
        background: var(--gradient-primary);
        color: var(--white);
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
    }
    
    .sidebar .nav-link.active i {
        color: var(--white);
    }

    .main-content {
        padding: 2.5rem;
        min-height: 100vh;
    }

    /* Card Styles */
    .card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        overflow: hidden;
        margin-bottom: 2rem;
    }

    .card-header {
        background: var(--gradient-primary);
        color: var(--white);
        padding: 1.25rem 1.5rem;
        font-weight: 600;
        border: none;
    }

    .card-header h1, .card-header h2, .card-header h3, .card-header h4, .card-header h5 {
        margin: 0;
        color: var(--white);
    }

    .page-header {
        margin-bottom: 2.5rem;
    }

    .page-header h1 {
        font-weight: 800;
        color: var(--text-main);
        font-size: 2.25rem;
        letter-spacing: -0.025em;
    }
    
    /* Table Styles */
    .table thead th {
        background: #f8fafc;
        color: var(--text-muted);
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.75rem;
        letter-spacing: 0.1em;
        padding: 1rem 1.5rem;
        border-bottom: 1px solid #e2e8f0;
    }
</style>
