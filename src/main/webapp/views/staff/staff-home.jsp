<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Staff Dashboard</title>
                    <style>
                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }

                        body {
                            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                            background: #f5f7fa;
                        }

                        .layout {
                            display: flex;
                            min-height: 100vh;
                        }

                        /* Sidebar */
                        .sidebar {
                            width: 140px;
                            background: #1e3a5f;
                            position: fixed;
                            height: 100vh;
                            display: flex;
                            flex-direction: column;
                        }

                        .sidebar-header {
                            padding: 1.25rem 0.75rem;
                            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .brand {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 0.5rem;
                            text-align: center;
                        }

                        .brand-icon {
                            width: 36px;
                            height: 36px;
                            background: #4a90e2;
                            border-radius: 8px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .brand-text {
                            display: flex;
                            flex-direction: column;
                            line-height: 1.3;
                        }

                        .brand-name {
                            font-size: 0.875rem;
                            font-weight: 600;
                            color: white;
                        }

                        .brand-subtitle {
                            font-size: 0.625rem;
                            color: #94a3b8;
                            text-transform: uppercase;
                        }

                        .nav-menu {
                            flex: 1;
                            padding: 0.75rem 0;
                        }

                        .nav-item {
                            margin: 0.25rem 0.5rem;
                        }

                        .nav-link {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 0.5rem;
                            padding: 0.75rem 0.5rem;
                            color: #94a3b8;
                            border-radius: 8px;
                            cursor: pointer;
                            transition: all 0.2s;
                            text-decoration: none;
                            font-size: 0.75rem;
                            font-weight: 500;
                            text-align: center;
                        }

                        .nav-link:hover {
                            background: rgba(74, 144, 226, 0.1);
                            color: #cbd5e1;
                        }

                        .nav-link.active {
                            background: #4a90e2;
                            color: white;
                        }

                        .nav-icon {
                            width: 20px;
                            height: 20px;
                        }

                        .sidebar-footer {
                            padding: 0.75rem;
                            border-top: 1px solid rgba(255, 255, 255, 0.1);
                            margin-top: auto;
                        }

                        .user-info {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            padding: 0.625rem;
                            background: rgba(74, 144, 226, 0.15);
                            border-radius: 8px;
                            margin-bottom: 0.625rem;
                        }

                        .user-avatar {
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            background: #4a90e2;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 600;
                            margin-bottom: 0.375rem;
                            color: white;
                            font-size: 0.75rem;
                        }

                        .user-name {
                            font-size: 0.75rem;
                            font-weight: 600;
                            color: white;
                            text-align: center;
                        }

                        .user-role {
                            font-size: 0.625rem;
                            color: #94a3b8;
                        }

                        .btn-logout {
                            width: 100%;
                            padding: 0.5rem;
                            background: rgba(239, 68, 68, 0.1);
                            color: #f87171;
                            border: 1px solid rgba(239, 68, 68, 0.2);
                            border-radius: 6px;
                            text-align: center;
                            text-decoration: none;
                            display: block;
                            transition: all 0.15s;
                            font-size: 0.75rem;
                            font-weight: 500;
                        }

                        .btn-logout:hover {
                            background: #ef4444;
                            color: white;
                            border-color: #ef4444;
                        }

                        /* Main Content */
                        .main-content {
                            flex: 1;
                            margin-left: 140px;
                            padding: 1.5rem;
                            background: #f5f7fa;
                        }

                        .tab-pane {
                            display: none;
                        }

                        .tab-pane.active {
                            display: block;
                        }

                        /* Dashboard */
                        .page-header {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 1.5rem;
                        }

                        .page-title {
                            font-size: 1.5rem;
                            font-weight: 600;
                            color: #1e293b;
                        }

                        .header-actions {
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                        }

                        .search-box {
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                            padding: 0.5rem 1rem;
                            background: white;
                            border: 1px solid #e2e8f0;
                            border-radius: 8px;
                            font-size: 0.875rem;
                            color: #94a3b8;
                        }

                        .search-icon {
                            width: 16px;
                            height: 16px;
                        }

                        .notification-icon {
                            position: relative;
                            width: 36px;
                            height: 36px;
                            background: white;
                            border: 1px solid #e2e8f0;
                            border-radius: 8px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                        }

                        .notification-badge {
                            position: absolute;
                            top: -4px;
                            right: -4px;
                            width: 18px;
                            height: 18px;
                            background: #ef4444;
                            color: white;
                            border-radius: 50%;
                            font-size: 0.625rem;
                            font-weight: 600;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .stats-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                            gap: 1.25rem;
                            margin-bottom: 1.5rem;
                        }

                        .stat-card {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            border: 1px solid #e2e8f0;
                            display: flex;
                            align-items: flex-start;
                            justify-content: space-between;
                        }

                        .stat-content {
                            flex: 1;
                        }

                        .stat-label {
                            font-size: 0.75rem;
                            color: #64748b;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                            margin-bottom: 0.5rem;
                            font-weight: 500;
                        }

                        .stat-value {
                            font-size: 2rem;
                            font-weight: 700;
                            color: #1e293b;
                            line-height: 1;
                            margin-bottom: 0.5rem;
                        }

                        .stat-description {
                            font-size: 0.8125rem;
                            color: #64748b;
                        }

                        .stat-link {
                            color: #4a90e2;
                            text-decoration: none;
                            font-weight: 500;
                        }

                        .stat-link:hover {
                            text-decoration: underline;
                        }

                        .stat-icon {
                            width: 48px;
                            height: 48px;
                            border-radius: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            flex-shrink: 0;
                        }

                        .stat-icon.blue {
                            background: #dbeafe;
                        }

                        .stat-icon.green {
                            background: #d1fae5;
                        }

                        .stat-icon.orange {
                            background: #fed7aa;
                        }

                        .stat-icon svg {
                            width: 24px;
                            height: 24px;
                        }

                        .stat-icon.blue svg {
                            color: #3b82f6;
                        }

                        .stat-icon.green svg {
                            color: #10b981;
                        }

                        .stat-icon.orange svg {
                            color: #f97316;
                        }

                        .restaurant-card {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            border: 1px solid #e2e8f0;
                            margin-bottom: 1.5rem;
                        }

                        .restaurant-header {
                            display: flex;
                            align-items: flex-start;
                            gap: 1rem;
                            margin-bottom: 1rem;
                        }

                        .restaurant-icon {
                            width: 48px;
                            height: 48px;
                            background: #fee2e2;
                            border-radius: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            flex-shrink: 0;
                        }

                        .restaurant-icon svg {
                            width: 24px;
                            height: 24px;
                            color: #ef4444;
                        }

                        .restaurant-info h3 {
                            font-size: 1.125rem;
                            font-weight: 600;
                            color: #1e293b;
                            margin-bottom: 0.25rem;
                        }

                        .restaurant-location {
                            font-size: 0.875rem;
                            color: #64748b;
                            display: flex;
                            align-items: center;
                            gap: 0.375rem;
                        }

                        .restaurant-location svg {
                            width: 14px;
                            height: 14px;
                        }

                        .restaurant-status {
                            margin-top: 1rem;
                            padding-top: 1rem;
                            border-top: 1px solid #f1f5f9;
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .status-label {
                            font-size: 0.875rem;
                            color: #64748b;
                        }

                        .status-badge {
                            padding: 0.25rem 0.75rem;
                            border-radius: 6px;
                            font-size: 0.75rem;
                            font-weight: 600;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.375rem;
                        }

                        .status-badge.open {
                            background: #d1fae5;
                            color: #065f46;
                        }

                        .status-badge.closed {
                            background: #fee2e2;
                            color: #991b1b;
                        }

                        .status-dot {
                            width: 6px;
                            height: 6px;
                            border-radius: 50%;
                            background: currentColor;
                        }

                        /* Tables Section */
                        .tables-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                            gap: 1.25rem;
                        }

                        .table-card {
                            position: relative;
                            background: white;
                            border-radius: 16px;
                            padding: 1.5rem 1.25rem 1.25rem;
                            text-align: center;
                            text-decoration: none;
                            color: inherit;
                            cursor: pointer;
                            border: 2px solid transparent;
                            transition: all 0.25s;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                        }

                        .table-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
                        }

                        .table-available {
                            border-color: #a7f3d0;
                            background: linear-gradient(160deg, #fff 60%, #f0fdf4 100%);
                        }

                        .table-available:hover {
                            border-color: #10b981;
                        }

                        .table-occupied {
                            border-color: #fecdd3;
                            background: linear-gradient(160deg, #fff 60%, #fff1f2 100%);
                        }

                        .table-occupied:hover {
                            border-color: #ef4444;
                        }

                        .table-icon-wrap {
                            width: 64px;
                            height: 64px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 0.875rem;
                        }

                        .table-available .table-icon-wrap {
                            background: linear-gradient(135deg, #34d399 0%, #059669 100%);
                            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
                        }

                        .table-occupied .table-icon-wrap {
                            background: linear-gradient(135deg, #f87171 0%, #dc2626 100%);
                            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.35);
                        }

                        .table-icon-wrap svg {
                            width: 30px;
                            height: 30px;
                            color: white;
                            fill: currentColor;
                        }

                        .table-number {
                            font-size: 1.5rem;
                            font-weight: 800;
                            color: #0f172a;
                            margin-bottom: 0.25rem;
                        }

                        .table-label {
                            font-size: 0.6875rem;
                            font-weight: 600;
                            text-transform: uppercase;
                            letter-spacing: 0.08em;
                            color: #94a3b8;
                            margin-bottom: 0.5rem;
                        }

                        .table-capacity {
                            font-size: 0.8125rem;
                            color: #64748b;
                            margin-bottom: 0.875rem;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 0.25rem;
                        }

                        .table-status {
                            padding: 0.35rem 0.875rem;
                            border-radius: 999px;
                            font-size: 0.75rem;
                            font-weight: 700;
                            display: inline-block;
                            letter-spacing: 0.04em;
                            text-transform: uppercase;
                        }

                        .status-available {
                            background: linear-gradient(135deg, #34d399 0%, #10b981 100%);
                            color: white;
                            box-shadow: 0 2px 6px rgba(16, 185, 129, 0.3);
                        }

                        .status-occupied {
                            background: linear-gradient(135deg, #f87171 0%, #ef4444 100%);
                            color: white;
                            box-shadow: 0 2px 6px rgba(239, 68, 68, 0.3);
                        }

                        /* Orders */
                        .orders-container {
                            background: white;
                            border-radius: 12px;
                            border: 1px solid #e2e8f0;
                        }

                        .orders-container .table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        .orders-container .table th {
                            background: #f8fafc;
                            padding: 0.875rem 1rem;
                            text-align: left;
                            font-weight: 600;
                            color: #64748b;
                            border-bottom: 1px solid #e2e8f0;
                            font-size: 0.75rem;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                        }

                        .orders-container .table td {
                            padding: 1rem;
                            border-bottom: 1px solid #f1f5f9;
                            color: #0f172a;
                            font-size: 0.875rem;
                        }

                        .orders-container .table tbody tr:hover {
                            background: #f8fafc;
                        }

                        .orders-container .badge {
                            padding: 0.375rem 0.75rem;
                            border-radius: 6px;
                            font-size: 0.75rem;
                            font-weight: 600;
                            display: inline-block;
                        }

                        .orders-container .bg-warning {
                            background: #fef3c7;
                            color: #92400e;
                        }

                        .orders-container .bg-success {
                            background: #d1fae5;
                            color: #065f46;
                        }

                        .orders-container .bg-danger {
                            background: #fee2e2;
                            color: #991b1b;
                        }

                        .filter-card {
                            background: white;
                            border: 1px solid #e2e8f0;
                            border-radius: 8px;
                            padding: 1.25rem;
                            margin-bottom: 1rem;
                        }

                        .filter-row {
                            display: flex;
                            gap: 1rem;
                            align-items: flex-end;
                            flex-wrap: wrap;
                        }

                        .filter-group {
                            flex: 1;
                            min-width: 200px;
                        }

                        .filter-group label {
                            display: block;
                            font-size: 0.8125rem;
                            font-weight: 600;
                            color: #374151;
                            margin-bottom: 0.5rem;
                        }

                        .filter-select {
                            width: 100%;
                            padding: 0.625rem 0.875rem;
                            border: 1px solid #d1d5db;
                            border-radius: 6px;
                            font-size: 0.875rem;
                            color: #111827;
                            background: white;
                        }

                        .filter-select:focus {
                            outline: none;
                            border-color: #3b82f6;
                            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                        }

                        .btn-filter {
                            padding: 0.625rem 1.25rem;
                            background: #4a90e2;
                            color: white;
                            border: none;
                            border-radius: 6px;
                            font-size: 0.875rem;
                            font-weight: 500;
                            cursor: pointer;
                        }

                        .btn-filter:hover {
                            background: #3b7bc9;
                        }

                        .btn-filter-clear {
                            padding: 0.625rem 1.25rem;
                            background: white;
                            color: #6b7280;
                            border: 1px solid #d1d5db;
                            border-radius: 6px;
                            font-size: 0.875rem;
                            font-weight: 500;
                            cursor: pointer;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 3rem 1.5rem;
                            color: #9ca3af;
                        }

                        /* Modal */
                        .modal {
                            display: none;
                            position: fixed;
                            z-index: 10000;
                            left: 0;
                            top: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                        }

                        .modal.show {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .modal-content {
                            background: white;
                            border-radius: 8px;
                            width: 90%;
                            max-width: 800px;
                            max-height: 90vh;
                            overflow: hidden;
                            display: flex;
                            flex-direction: column;
                        }

                        .modal-header {
                            padding: 1.25rem 1.5rem;
                            border-bottom: 1px solid #e5e7eb;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .modal-header h3 {
                            margin: 0;
                            font-size: 1.25rem;
                            font-weight: 600;
                            color: #111827;
                        }

                        .modal-close {
                            font-size: 1.75rem;
                            color: #9ca3af;
                            cursor: pointer;
                            line-height: 1;
                        }

                        .modal-close:hover {
                            color: #111827;
                        }

                        .modal-body {
                            padding: 1.5rem;
                            overflow-y: auto;
                        }

                        /* Toast */
                        .toast {
                            position: fixed;
                            top: 1rem;
                            right: 1rem;
                            background: white;
                            padding: 0.875rem 1.25rem;
                            border-radius: 6px;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                            border: 1px solid #e5e7eb;
                            display: none;
                            z-index: 9999;
                            min-width: 280px;
                            font-size: 0.875rem;
                        }

                        .toast.show {
                            display: block;
                            animation: slideIn 0.2s ease;
                        }

                        @keyframes slideIn {
                            from {
                                transform: translateX(400px);
                                opacity: 0;
                            }

                            to {
                                transform: translateX(0);
                                opacity: 1;
                            }
                        }

                        .toast-success {
                            border-left: 3px solid #10b981;
                        }

                        .toast-error {
                            border-left: 3px solid #ef4444;
                        }
                    </style>
                </head>

                <body>
                    <div class="layout">
                        <!-- Sidebar -->
                        <aside class="sidebar">
                            <div class="sidebar-header">
                                <div class="brand">
                                    <div class="brand-icon">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="white">
                                            <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" />
                                        </svg>
                                    </div>
                                    <div class="brand-text">
                                        <div class="brand-name">Restaurant POS</div>
                                        <div class="brand-subtitle">Staff Dashboard</div>
                                    </div>
                                </div>
                            </div>

                            <nav class="nav-menu">
                                <div class="nav-item">
                                    <div class="nav-link active" data-tab="dashboard">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <rect x="3" y="3" width="7" height="7" />
                                            <rect x="14" y="3" width="7" height="7" />
                                            <rect x="14" y="14" width="7" height="7" />
                                            <rect x="3" y="14" width="7" height="7" />
                                        </svg>
                                        Dashboard
                                    </div>
                                </div>
                                <div class="nav-item">
                                    <div class="nav-link" data-tab="tables">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                        </svg>
                                        Danh Sách Bàn
                                    </div>
                                </div>
                                <div class="nav-item">
                                    <div class="nav-link" data-tab="orders">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                            <polyline points="14 2 14 8 20 8" />
                                        </svg>
                                        Lịch Sử Đơn
                                    </div>
                                </div>
                            </nav>

                            <div class="sidebar-footer">
                                <div class="user-info">
                                    <div class="user-avatar">${sessionScope.user.fullName.substring(0,1).toUpperCase()}
                                    </div>
                                    <div class="user-name">${sessionScope.user.fullName}</div>
                                    <div class="user-role">Nhân viên</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
                            </div>
                        </aside>

                        <!-- Main Content -->
                        <main class="main-content">
                            <!-- Dashboard Tab -->
                            <div class="tab-pane active" id="dashboard">
                                <div class="page-header">
                                    <h1 class="page-title">Staff Dashboard</h1>
                                    <div class="header-actions">
                                        <div class="search-box">
                                            <svg class="search-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="11" cy="11" r="8" />
                                                <path d="m21 21-4.35-4.35" />
                                            </svg>
                                            Tìm kiếm...
                                        </div>
                                        <div class="notification-icon">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                                <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                                            </svg>
                                            <span class="notification-badge">3</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Stats Grid -->
                                <div class="stats-grid">
                                    <div class="stat-card">
                                        <div class="stat-content">
                                            <div class="stat-label">Tổng Bàn</div>
                                            <div class="stat-value">
                                                <c:out value="${fn:length(tables)}" default="0" />
                                            </div>
                                            <div class="stat-description">Tổng số bàn trong nhà hàng</div>
                                        </div>
                                        <div class="stat-icon blue">
                                            <svg viewBox="0 0 24 24" fill="currentColor">
                                                <path
                                                    d="M3 13h2v-2H3v2zm0 4h2v-2H3v2zm0-8h2V7H3v2zm4 4h14v-2H7v2zm0 4h14v-2H7v2zM7 7v2h14V7H7z" />
                                            </svg>
                                        </div>
                                    </div>

                                    <div class="stat-card">
                                        <div class="stat-content">
                                            <div class="stat-label">Bàn Trống</div>
                                            <div class="stat-value" id="availableCount">0</div>
                                            <div class="stat-description">
                                                <a href="#" class="stat-link"
                                                    onclick="document.querySelector('[data-tab=tables]').click(); return false;">»
                                                    Sẵn sàng phục vụ</a>
                                            </div>
                                        </div>
                                        <div class="stat-icon green">
                                            <svg viewBox="0 0 24 24" fill="currentColor">
                                                <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z" />
                                            </svg>
                                        </div>
                                    </div>

                                    <div class="stat-card">
                                        <div class="stat-content">
                                            <div class="stat-label">Đang Phục Vụ</div>
                                            <div class="stat-value" id="occupiedCount">0</div>
                                            <div class="stat-description">● Đang có khách</div>
                                        </div>
                                        <div class="stat-icon orange">
                                            <svg viewBox="0 0 24 24" fill="currentColor">
                                                <path
                                                    d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
                                            </svg>
                                        </div>
                                    </div>
                                </div>

                                <!-- Restaurant Info -->
                                <div class="restaurant-card">
                                    <div class="restaurant-header">
                                        <div class="restaurant-icon">
                                            <svg viewBox="0 0 24 24" fill="currentColor">
                                                <path
                                                    d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2v7zm5-3v8h2.5v8H21V2c-2.76 0-5 2.24-5 4z" />
                                            </svg>
                                        </div>
                                        <div class="restaurant-info">
                                            <h3>${restaurant.name}</h3>
                                            <div class="restaurant-location">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                                    <circle cx="12" cy="10" r="3" />
                                                </svg>
                                                ${restaurant.address}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="restaurant-status">
                                        <span class="status-label">Trạng thái:</span>
                                        <c:choose>
                                            <c:when test="${restaurant.isOpen}">
                                                <span class="status-badge open">
                                                    <span class="status-dot"></span>
                                                    Đang mở cửa
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge closed">
                                                    <span class="status-dot"></span>
                                                    Đã đóng cửa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Tables Tab -->
                            <div class="tab-pane" id="tables">
                                <div class="page-header">
                                    <h1 class="page-title">Danh Sách Bàn</h1>
                                </div>

                                <div class="tables-grid">
                                    <c:forEach var="table" items="${tables}">
                                        <c:choose>
                                            <c:when test="${table.tableStatus == 'Available'}">
                                                <a href="${pageContext.request.contextPath}/staff/pos?tableId=${table.tableID}"
                                                    class="table-card table-available" data-status="available">
                                                    <div class="table-icon-wrap">
                                                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                            <path
                                                                d="M3 6h18v2H3V6zm2 4h14v2H5v-2zm-2 4h18v2H3v-2zm4 4h10v2H7v-2z" />
                                                        </svg>
                                                    </div>
                                                    <div class="table-label">Bàn số</div>
                                                    <div class="table-number">${table.tableNumber}</div>
                                                    <div class="table-capacity">
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2.2">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                            <circle cx="9" cy="7" r="4" />
                                                        </svg>
                                                        ${table.capacity} chỗ
                                                    </div>
                                                    <span class="table-status status-available">Còn trống</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/staff/table/order?tableId=${table.tableID}"
                                                    class="table-card table-occupied" data-status="occupied">
                                                    <div class="table-icon-wrap">
                                                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                            <path
                                                                d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z" />
                                                        </svg>
                                                    </div>
                                                    <div class="table-label">Bàn số</div>
                                                    <div class="table-number">${table.tableNumber}</div>
                                                    <div class="table-capacity">
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2.2">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                            <circle cx="9" cy="7" r="4" />
                                                        </svg>
                                                        ${table.capacity} chỗ
                                                    </div>
                                                    <span class="table-status status-occupied">Có khách</span>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Orders Tab -->
                            <div class="tab-pane" id="orders">
                                <div class="page-header">
                                    <h1 class="page-title">Lịch Sử Đơn Hàng</h1>
                                </div>

                                <div class="filter-card">
                                    <div class="filter-row">
                                        <div class="filter-group">
                                            <label>Từ ngày</label>
                                            <input type="date" id="fromDateFilter" class="filter-select">
                                        </div>
                                        <div class="filter-group">
                                            <label>Đến ngày</label>
                                            <input type="date" id="toDateFilter" class="filter-select">
                                        </div>
                                        <div class="filter-group">
                                            <label>Loại đơn</label>
                                            <select id="orderTypeFilter" class="filter-select">
                                                <option value="All">Tất cả</option>
                                                <option value="DineIn">Ăn tại chỗ</option>
                                                <option value="Pickup">Mang đi</option>
                                                <option value="Online">Giao hàng</option>
                                            </select>
                                        </div>
                                        <div>
                                            <button class="btn-filter" onclick="applyFilters()">Lọc</button>
                                            <button class="btn-filter-clear" onclick="clearFilters()">Xóa</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="orders-container">
                                    <div id="ordersContent"></div>
                                </div>
                            </div>
                        </main>
                    </div>

                    <!-- Toast -->
                    <div id="toast" class="toast"></div>

                    <!-- Modal -->
                    <div id="orderModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Chi Tiết Đơn Hàng</h3>
                                <span class="modal-close" onclick="closeModal()">&times;</span>
                            </div>
                            <div class="modal-body" id="orderModalContent">
                                <div class="empty-state">Đang tải...</div>
                            </div>
                        </div>
                    </div>

                    <script>
                        const ctx = '${pageContext.request.contextPath}';

                        // Tab switching
                        document.querySelectorAll('[data-tab]').forEach(link => {
                            link.addEventListener('click', function () {
                                const tab = this.dataset.tab;
                                document.querySelectorAll('[data-tab]').forEach(l => l.classList.remove('active'));
                                this.classList.add('active');
                                document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
                                document.getElementById(tab).classList.add('active');
                                if (tab === 'orders') {
                                    if (!window.ordersLoaded) {
                                        loadOrders();
                                        window.ordersLoaded = true;
                                    }
                                }
                            });
                        });

                        // Count tables
                        (function updateTableCounts() {
                            const cards = document.querySelectorAll('.table-card');
                            let avail = 0, occ = 0;
                            cards.forEach(c => {
                                if (c.dataset.status === 'available') avail++;
                                else occ++;
                            });
                            const elAvail = document.getElementById('availableCount');
                            const elOcc = document.getElementById('occupiedCount');
                            if (elAvail) elAvail.textContent = avail;
                            if (elOcc) elOcc.textContent = occ;
                        })();

                        // Load orders
                        function loadOrders(tableId = null, fromDate = null, toDate = null, orderType = 'All', page = 1) {
                            let url = ctx + '/staff/orders?';
                            if (tableId) url += 'tableId=' + tableId + '&';
                            if (fromDate) url += 'fromDate=' + fromDate + '&';
                            if (toDate) url += 'toDate=' + toDate + '&';
                            if (orderType && orderType !== 'All') url += 'orderType=' + orderType + '&';
                            if (page) url += 'page=' + page;

                            document.getElementById('ordersContent').innerHTML = '<div class="empty-state">Đang tải...</div>';

                            fetch(url)
                                .then(r => {
                                    if (r.ok) return r.text();
                                    return r.text().then(body => {
                                        console.error('loadOrders failed: HTTP ' + r.status, body);
                                        return Promise.reject(new Error('HTTP ' + r.status + ': ' + body.substring(0, 300)));
                                    });
                                })
                                .then(html => {
                                    document.getElementById('ordersContent').innerHTML = html;
                                })
                                .catch(err => {
                                    console.error('loadOrders error:', err);
                                    document.getElementById('ordersContent').innerHTML = '<div class="empty-state">Lỗi tải dữ liệu</div>';
                                });
                        }

                        function applyFilters() {
                            const fromDate = document.getElementById('fromDateFilter').value;
                            const toDate = document.getElementById('toDateFilter').value;
                            const orderType = document.getElementById('orderTypeFilter').value;
                            loadOrders(null, fromDate, toDate, orderType);
                        }

                        function clearFilters() {
                            document.getElementById('fromDateFilter').value = '';
                            document.getElementById('toDateFilter').value = '';
                            document.getElementById('orderTypeFilter').value = 'All';
                            loadOrders();
                        }

                        function closeModal() {
                            document.getElementById('orderModal').classList.remove('show');
                        }

                        function viewOrderDetail(orderId) {
                            const modal = document.getElementById('orderModal');
                            const modalContent = document.getElementById('orderModalContent');

                            modal.classList.add('show');
                            modalContent.innerHTML = '<div class="empty-state">Đang tải...</div>';

                            fetch(ctx + '/staff/order/detail?orderId=' + orderId)
                                .then(r => {
                                    console.log('Response status:', r.status);
                                    if (!r.ok) {
                                        return r.text().then(text => {
                                            console.error('Server error:', text);
                                            throw new Error('HTTP ' + r.status);
                                        });
                                    }
                                    return r.json();
                                })
                                .then(data => {
                                    console.log('Order detail data:', data);
                                    const order = data.order;
                                    const items = data.items;

                                    const statusLabel = {
                                        'Pending':    'Chờ xử lý',
                                        'Preparing':  'Đang chuẩn bị',
                                        'Delivering': 'Đang giao',
                                        'Completed':  'Hoàn thành',
                                        'Cancelled':  'Đã hủy'
                                    };
                                    const statusColor = {
                                        'Pending':    { bg: '#fef3c7', color: '#92400e' },
                                        'Preparing':  { bg: '#fef3c7', color: '#92400e' },
                                        'Delivering': { bg: '#ede9fe', color: '#5b21b6' },
                                        'Completed':  { bg: '#d1fae5', color: '#065f46' },
                                        'Cancelled':  { bg: '#fee2e2', color: '#991b1b' }
                                    };
                                    // next allowed statuses (chỉ dùng values DB cho phép)
                                    // Đơn Online: phải qua Delivering trước rồi mới Completed
                                    // Đơn DineIn/Pickup: Preparing -> Completed trực tiếp
                                    const nextStatuses = (order.orderType === 'Online')
                                        ? {
                                            'Pending':    ['Preparing', 'Cancelled'],
                                            'Preparing':  ['Delivering', 'Cancelled'],
                                            'Delivering': ['Completed', 'Cancelled'],
                                            'Completed':  [],
                                            'Cancelled':  []
                                          }
                                        : {
                                            'Pending':    ['Preparing', 'Cancelled'],
                                            'Preparing':  ['Completed', 'Cancelled'],
                                            'Delivering': ['Completed', 'Cancelled'],
                                            'Completed':  [],
                                            'Cancelled':  []
                                          };

                                    const sc = statusColor[order.orderStatus] || { bg: '#f1f5f9', color: '#64748b' };
                                    const nexts = nextStatuses[order.orderStatus] || [];

                                    let html = '<div style="padding: 0.5rem;">';

                                    // Status bar
                                    html += '<div style="display:flex;align-items:center;justify-content:space-between;background:#f8fafc;padding:0.875rem 1rem;border-radius:8px;margin-bottom:1rem;">';
                                    html += '<div style="display:flex;align-items:center;gap:0.75rem;">';
                                    html += '<span style="font-size:0.8125rem;color:#64748b;">Trạng thái:</span>';
                                    html += '<span style="padding:0.3rem 0.8rem;border-radius:999px;font-size:0.8125rem;font-weight:600;background:' + sc.bg + ';color:' + sc.color + ';">' + (statusLabel[order.orderStatus] || order.orderStatus) + '</span>';
                                    html += '</div>';
                                    if (nexts.length > 0) {
                                        html += '<div style="display:flex;gap:0.5rem;" id="statusActionBtns">';
                                        nexts.forEach(function(s) {
                                            const isCancell = s === 'Cancelled';
                                            const btnStyle = isCancell
                                                ? 'padding:0.4rem 0.9rem;border-radius:6px;border:1px solid #fca5a5;background:#fff;color:#dc2626;font-size:0.8125rem;font-weight:600;cursor:pointer;'
                                                : 'padding:0.4rem 0.9rem;border-radius:6px;border:none;background:#4a90e2;color:#fff;font-size:0.8125rem;font-weight:600;cursor:pointer;';
                                            const btnLabel = isCancell ? 'Hủy đơn' : (s === 'Preparing' ? 'Xác nhận chuẩn bị' : s === 'Delivering' ? 'Bắt đầu giao' : 'Hoàn thành');
                                            html += '<button style="' + btnStyle + '" onclick="updateOrderStatus(' + order.orderID + ',\'' + s + '\')">' + btnLabel + '</button>';
                                        });
                                        html += '</div>';
                                    }
                                    html += '</div>';

                                    // Order info
                                    html += '<div style="background: #f8fafc; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">';
                                    html += '<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; font-size: 0.875rem;">';
                                    html += '<div><span style="color: #64748b;">Mã đơn:</span> <strong>#' + order.orderID + '</strong></div>';
                                    html += '<div><span style="color: #64748b;">Loại:</span> <strong>' + (order.orderType === 'DineIn' ? 'Ăn tại chỗ' : order.orderType === 'Pickup' ? 'Mang đi' : 'Giao hàng') + '</strong></div>';
                                    if (order.tableID) {
                                        html += '<div><span style="color: #64748b;">Bàn:</span> <strong>Bàn ' + order.tableID + '</strong></div>';
                                    }
                                    html += '<div><span style="color: #64748b;">Thời gian:</span> <strong>' + new Date(order.createdAt).toLocaleString('vi-VN') + '</strong></div>';
                                    html += '</div></div>';

                                    // Order items
                                    html += '<h4 style="margin-bottom: 0.75rem; font-size: 1rem; color: #1e293b;">Món ăn</h4>';
                                    html += '<table style="width: 100%; border-collapse: collapse; margin-bottom: 1rem;">';
                                    html += '<thead><tr style="background: #f8fafc; border-bottom: 2px solid #e2e8f0;">';
                                    html += '<th style="padding: 0.625rem; text-align: left; font-size: 0.8125rem; color: #64748b;">Tên món</th>';
                                    html += '<th style="padding: 0.625rem; text-align: center; font-size: 0.8125rem; color: #64748b;">SL</th>';
                                    html += '<th style="padding: 0.625rem; text-align: left; font-size: 0.8125rem; color: #64748b;">Ghi chú</th>';
                                    html += '<th style="padding: 0.625rem; text-align: right; font-size: 0.8125rem; color: #64748b;">Đơn giá</th>';
                                    html += '<th style="padding: 0.625rem; text-align: right; font-size: 0.8125rem; color: #64748b;">Thành tiền</th>';
                                    html += '</tr></thead><tbody>';

                                    items.forEach(item => {
                                        const price = parseFloat(item.unitPrice) || 0;
                                        const quantity = parseInt(item.quantity) || 0;
                                        html += '<tr style="border-bottom: 1px solid #f1f5f9;">';
                                        html += '<td style="padding: 0.625rem; font-size: 0.875rem;">' + (item.itemName || 'N/A') + '</td>';
                                        html += '<td style="padding: 0.625rem; text-align: center; font-size: 0.875rem;">' + quantity + '</td>';
                                        html += '<td style="padding: 0.625rem; font-size: 0.8125rem; color: #64748b; font-style: italic;">' + (item.note ? item.note : '<span style="color:#cbd5e1;">—</span>') + '</td>';
                                        html += '<td style="padding: 0.625rem; text-align: right; font-size: 0.875rem;">' + price.toLocaleString('vi-VN') + 'đ</td>';
                                        html += '<td style="padding: 0.625rem; text-align: right; font-weight: 600; font-size: 0.875rem;">' + (price * quantity).toLocaleString('vi-VN') + 'đ</td>';
                                        html += '</tr>';
                                    });

                                    html += '</tbody></table>';

                                    // Order summary
                                    html += '<div style="background: #f8fafc; padding: 1rem; border-radius: 8px;">';
                                    html += '<div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; font-size: 0.875rem;">';
                                    html += '<span style="color: #64748b;">Tổng tiền món:</span>';
                                    html += '<span style="font-weight: 600;">' + order.totalAmount.toLocaleString('vi-VN') + 'đ</span>';
                                    html += '</div>';
                                    if (order.discountAmount > 0) {
                                        html += '<div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; font-size: 0.875rem;">';
                                        html += '<span style="color: #64748b;">Giảm giá:</span>';
                                        html += '<span style="color: #10b981; font-weight: 600;">-' + order.discountAmount.toLocaleString('vi-VN') + 'đ</span>';
                                        html += '</div>';
                                    }
                                    if (order.deliveryFee > 0) {
                                        html += '<div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; font-size: 0.875rem;">';
                                        html += '<span style="color: #64748b;">Phí giao hàng:</span>';
                                        html += '<span style="font-weight: 600;">' + order.deliveryFee.toLocaleString('vi-VN') + 'đ</span>';
                                        html += '</div>';
                                    }
                                    html += '<div style="display: flex; justify-content: space-between; padding-top: 0.75rem; border-top: 2px solid #e2e8f0; font-size: 1rem;">';
                                    html += '<span style="font-weight: 600; color: #1e293b;">Tổng cộng:</span>';
                                    html += '<span style="font-weight: 700; color: #4a90e2; font-size: 1.25rem;">' + order.finalAmount.toLocaleString('vi-VN') + 'đ</span>';
                                    html += '</div>';
                                    html += '</div>';

                                    html += '</div>';
                                    modalContent.innerHTML = html;
                                })
                                .catch(err => {
                                    console.error('Error loading order detail:', err);
                                    modalContent.innerHTML = '<div class="empty-state"><p style="color: #ef4444;">Lỗi tải dữ liệu</p><p style="font-size: 0.875rem; color: #94a3b8; margin-top: 0.5rem;">' + err.message + '</p></div>';
                                });
                        }

                        function showToast(message, type = 'success') {
                            const toast = document.getElementById('toast');
                            toast.textContent = message;
                            toast.className = 'toast toast-' + type + ' show';
                            setTimeout(() => toast.classList.remove('show'), 3000);
                        }

                        function updateOrderStatus(orderId, newStatus) {
                            const btns = document.querySelectorAll('#statusActionBtns button');
                            btns.forEach(b => { b.disabled = true; b.style.opacity = '0.6'; });

                            fetch(ctx + '/update-order-status', {
                                method: 'POST',
                                credentials: 'same-origin',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'orderId=' + encodeURIComponent(orderId) + '&status=' + encodeURIComponent(newStatus)
                            })
                            .then(r => r.json())
                            .then(data => {
                                if (data.success) {
                                    showToast('Cập nhật trạng thái thành công', 'success');
                                    // Reload modal with updated data
                                    viewOrderDetail(orderId);
                                    // Refresh order list if visible
                                    if (window.ordersLoaded) {
                                        const fromDate = document.getElementById('fromDateFilter').value;
                                        const toDate = document.getElementById('toDateFilter').value;
                                        const orderType = document.getElementById('orderTypeFilter').value;
                                        loadOrders(null, fromDate, toDate, orderType);
                                    }
                                } else {
                                    showToast(data.message || 'Cập nhật thất bại', 'error');
                                    btns.forEach(b => { b.disabled = false; b.style.opacity = '1'; });
                                }
                            })
                            .catch(() => {
                                showToast('Lỗi kết nối', 'error');
                                btns.forEach(b => { b.disabled = false; b.style.opacity = '1'; });
                            });
                        }

                        // Auto-switch tab based on URL hash (e.g. #orders)
                        (function () {
                            const hash = window.location.hash.replace('#', '');
                            if (hash) {
                                const targetLink = document.querySelector('[data-tab="' + hash + '"]');
                                if (targetLink) targetLink.click();
                            }
                        })();

                        window.onclick = function (event) {
                            const modal = document.getElementById('orderModal');
                            if (event.target === modal) closeModal();
                        }
                    </script>

                    <script>
                        (function () {
                            const POLL_INTERVAL_MS = 5000;
                            const TOAST_DURATION_MS = 15000;
                            let lastOrderId = 0;
                            let initialized = false;

                            function playNewOrderSound() {
                                try {
                                    const AudioContext = window.AudioContext || window.webkitAudioContext;
                                    if (!AudioContext) return;
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
                                } catch (e) {}
                            }

                            function updateNotificationBadge(count) {
                                const badge = document.querySelector('.notification-badge');
                                if (badge) {
                                    badge.textContent = count;
                                    badge.style.display = count > 0 ? '' : 'none';
                                }
                            }

                            function showOrderToast(count) {
                                const ctxPath = '${pageContext.request.contextPath}';
                                const orderListUrl = ctxPath + '/staff/home#orders';
                                const msg = count === 1
                                    ? 'Có 1 đơn hàng mới đang chờ xử lý.'
                                    : 'Có ' + count + ' đơn hàng mới đang chờ xử lý.';

                                const existing = document.getElementById('__order-notif__');
                                if (existing) existing.remove();

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
                                    '        <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>' +
                                    '      </div>' +
                                    '      <div>' +
                                    '        <div style="color:#fff;font-weight:700;font-size:.92rem;line-height:1.2;">Đơn hàng mới!</div>' +
                                    '        <div style="color:rgba(255,255,255,.85);font-size:.75rem;">Nhấn để xem danh sách đơn</div>' +
                                    '      </div>' +
                                    '    </div>' +
                                    '    <button id="__order-notif-close__" type="button" style="background:rgba(255,255,255,.18);border:none;color:#fff;width:28px;height:28px;border-radius:10px;font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;">&times;</button>' +
                                    '  </div>' +
                                    '  <div style="padding:12px 14px 10px;">' +
                                    '    <div style="color:#334155;font-size:.85rem;line-height:1.45;">' + msg + '</div>' +
                                    '    <div style="margin-top:8px;color:#6366f1;font-size:.78rem;font-weight:600;">Xem danh sách đơn &#8594;</div>' +
                                    '  </div>' +
                                    '  <div style="padding:0 14px 12px;">' +
                                    '    <div style="background:#e2e8f0;border-radius:999px;height:4px;overflow:hidden;">' +
                                    '      <div id="__order-notif-bar__" style="height:100%;background:linear-gradient(90deg,#6366f1,#8b5cf6);width:100%;transition:width linear ' + TOAST_DURATION_MS + 'ms;"></div>' +
                                    '    </div>' +
                                    '  </div>' +
                                    '</div>';

                                wrap.onclick = function () {
                                    const tabLink = document.querySelector('[data-tab="orders"]');
                                    if (tabLink) {
                                        tabLink.click();
                                        window.location.hash = 'orders';
                                    } else {
                                        window.location.href = orderListUrl;
                                    }
                                };
                                document.body.appendChild(wrap);

                                requestAnimationFrame(function () {
                                    wrap.style.opacity = '1';
                                    wrap.style.transform = 'translateX(0)';
                                    const bar = document.getElementById('__order-notif-bar__');
                                    if (bar) requestAnimationFrame(function () { bar.style.width = '0%'; });
                                });

                                let closed = false;
                                function closeToast() {
                                    if (closed) return;
                                    closed = true;
                                    wrap.style.opacity = '0';
                                    wrap.style.transform = 'translateX(30px)';
                                    setTimeout(function () { if (wrap.parentNode) wrap.remove(); }, 300);
                                }

                                const closeBtn = document.getElementById('__order-notif-close__');
                                if (closeBtn) closeBtn.onclick = function (e) { e.stopPropagation(); closeToast(); };
                                setTimeout(closeToast, TOAST_DURATION_MS);
                            }

                            async function checkNewOrders() {
                                try {
                                    const url = '${pageContext.request.contextPath}/restaurant/order-notifications?lastOrderId=' + lastOrderId;
                                    const res = await fetch(url, { credentials: 'same-origin' });
                                    if (!res.ok) return;
                                    const data = await res.json();
                                    if (!data || !data.success) return;

                                    if (!initialized) {
                                        lastOrderId = (typeof data.latestOrderId === 'number' && data.latestOrderId > 0) ? data.latestOrderId : 0;
                                        initialized = true;
                                        return;
                                    }

                                    if (typeof data.latestOrderId === 'number' && data.latestOrderId > lastOrderId) {
                                        lastOrderId = data.latestOrderId;
                                    }

                                    if (data.hasNew && data.newOrdersCount > 0) {
                                        playNewOrderSound();
                                        showOrderToast(data.newOrdersCount);
                                        updateNotificationBadge(data.newOrdersCount);
                                    }
                                } catch (e) {}
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                updateNotificationBadge(0);
                                setTimeout(checkNewOrders, 3000);
                                setInterval(checkNewOrders, POLL_INTERVAL_MS);
                            });
                        })();
                    </script>
                </body>

                </html>