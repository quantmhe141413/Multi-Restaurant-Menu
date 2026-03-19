<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff POS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #f5f5f5;
        }
        .layout { display: flex; min-height: 100vh; }
        
        /* Sidebar */
        .sidebar {
            width: 240px;
            background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
            border-right: 1px solid #334155;
            position: fixed;
            height: 100vh;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
        }
        .sidebar-header {
            padding: 1.25rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .brand { 
            font-size: 1.25rem; 
            font-weight: 700; 
            background: linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .nav-menu { flex: 1; padding: 0.75rem 0; }
        .nav-item { margin: 0.25rem 0.5rem; }
        .nav-link {
            display: block;
            padding: 0.75rem 0.875rem;
            color: #cbd5e1;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.15s;
            text-decoration: none;
            font-size: 0.9375rem;
            font-weight: 500;
        }
        .nav-link:hover { 
            background: rgba(59, 130, 246, 0.1); 
            color: #60a5fa;
        }
        .nav-link.active { 
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.4);
        }
        .sidebar-footer {
            padding: 0.75rem;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        .user-info {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            background: rgba(255,255,255,0.05);
            border-radius: 6px;
            margin-bottom: 0.625rem;
        }
        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 0.625rem;
            color: white;
            font-size: 0.875rem;
            box-shadow: 0 2px 4px rgba(59, 130, 246, 0.3);
        }
        .user-name { 
            font-size: 0.875rem; 
            font-weight: 600; 
            color: white;
        }
        .user-role { 
            font-size: 0.75rem; 
            color: #94a3b8;
        }
        .btn-logout {
            width: 100%;
            padding: 0.625rem;
            background: rgba(239, 68, 68, 0.1);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.2);
            border-radius: 6px;
            text-align: center;
            text-decoration: none;
            display: block;
            transition: all 0.15s;
            font-size: 0.875rem;
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
            margin-left: 240px;
            padding: 1.5rem;
            background: #f5f5f5;
        }
        .tab-pane { display: none; }
        .tab-pane.active { display: block; }
        
        /* Dashboard */
        .page-title { 
            font-size: 1.5rem; 
            font-weight: 700; 
            margin-bottom: 1.25rem; 
            color: #111827;
        }
        .info-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }
        .info-card h3 { 
            margin-bottom: 0.625rem; 
            color: #111827;
            font-size: 1.125rem;
        }
        .info-card p { 
            margin-bottom: 0.375rem; 
            color: #6b7280;
            font-size: 0.9375rem;
        }
        
        /* ===== TABLES SECTION ===== */
        .tables-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .tables-section-header .page-title {
            margin-bottom: 0;
        }
        .table-stats-bar {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }
        .stat-pill {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 999px;
            font-size: 0.8125rem;
            font-weight: 600;
            letter-spacing: 0.01em;
        }
        .stat-pill-total  { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }
        .stat-pill-avail  { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .stat-pill-occ    { background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; }
        .stat-pill-dot    { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
        .dot-total  { background: #94a3b8; }
        .dot-avail  { background: #10b981; }
        .dot-occ    { background: #ef4444; animation: pulse-dot 1.5s ease-in-out infinite; }
        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.5; transform: scale(1.35); }
        }

        /* Grid */
        .tables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.25rem;
        }

        /* Table Card */
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
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            overflow: hidden;
        }
        .table-card::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: 14px;
            opacity: 0;
            transition: opacity 0.25s;
        }
        .table-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.12);
        }
        .table-card:hover::before { opacity: 1; }

        /* Available */
        .table-available {
            border-color: #a7f3d0;
            background: linear-gradient(160deg, #fff 60%, #f0fdf4 100%);
        }
        .table-available::before {
            background: linear-gradient(160deg, rgba(16,185,129,0.04) 0%, rgba(16,185,129,0.1) 100%);
        }
        .table-available:hover { border-color: #10b981; }

        /* Occupied */
        .table-occupied {
            border-color: #fecdd3;
            background: linear-gradient(160deg, #fff 60%, #fff1f2 100%);
        }
        .table-occupied::before {
            background: linear-gradient(160deg, rgba(239,68,68,0.04) 0%, rgba(239,68,68,0.1) 100%);
        }
        .table-occupied:hover { border-color: #ef4444; }

        /* Icon area */
        .table-icon-wrap {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.875rem;
            position: relative;
        }
        .table-available .table-icon-wrap {
            background: linear-gradient(135deg, #34d399 0%, #059669 100%);
            box-shadow: 0 4px 14px rgba(16,185,129,0.35);
        }
        .table-occupied .table-icon-wrap {
            background: linear-gradient(135deg, #f87171 0%, #dc2626 100%);
            box-shadow: 0 4px 14px rgba(239,68,68,0.35);
        }
        .table-icon-wrap svg {
            width: 30px;
            height: 30px;
            color: white;
            fill: currentColor;
        }

        /* Pulse ring on occupied */
        .table-occupied .table-icon-wrap::after {
            content: '';
            position: absolute;
            inset: -5px;
            border-radius: 50%;
            border: 2px solid rgba(239,68,68,0.4);
            animation: pulse-ring 2s ease-out infinite;
        }
        @keyframes pulse-ring {
            0%   { transform: scale(0.9); opacity: 0.8; }
            100% { transform: scale(1.25); opacity: 0; }
        }

        .table-number {
            font-size: 1.5rem;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.02em;
            line-height: 1.2;
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
            box-shadow: 0 2px 6px rgba(16,185,129,0.3);
        }
        .status-occupied {
            background: linear-gradient(135deg, #f87171 0%, #ef4444 100%);
            color: white;
            box-shadow: 0 2px 6px rgba(239,68,68,0.3);
        }

        /* CTA hint */
        .table-cta {
            margin-top: 0.75rem;
            font-size: 0.75rem;
            font-weight: 500;
            opacity: 0;
            transform: translateY(4px);
            transition: all 0.2s;
        }
        .table-available .table-cta { color: #059669; }
        .table-occupied  .table-cta { color: #dc2626; }
        .table-card:hover .table-cta { opacity: 1; transform: translateY(0); }

        /* Legacy btn-view / btn-close kept for JS compat */
        .btn-view  { display: none; }
        .btn-close { display: none; }
        
        /* Orders */
        .orders-container { 
            background: white; 
            border-radius: 8px; 
            border: 1px solid #e5e7eb;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .orders-container .table-responsive {
            overflow-x: auto;
        }
        .orders-container .table { 
            width: 100%; 
            border-collapse: collapse;
            margin: 0;
        }
        .orders-container .table th {
            background: linear-gradient(180deg, #f9fafb 0%, #f3f4f6 100%);
            padding: 0.875rem 0.75rem;
            text-align: left;
            font-weight: 600;
            color: #374151;
            border-bottom: 2px solid #e5e7eb;
            font-size: 0.8125rem;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }
        .orders-container .table td {
            padding: 0.875rem 0.75rem;
            border-bottom: 1px solid #f3f4f6;
            color: #6b7280;
            font-size: 0.875rem;
        }
        .orders-container .table tbody tr {
            transition: all 0.15s;
        }
        .orders-container .table tbody tr:hover { 
            background: #f9fafb;
            box-shadow: inset 0 0 0 1px #e5e7eb;
        }
        .orders-container .badge {
            padding: 0.3rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            letter-spacing: 0.025em;
        }
        .orders-container .bg-warning {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            color: white;
        }
        .orders-container .bg-info {
            background: linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%);
            color: white;
        }
        .orders-container .bg-success {
            background: linear-gradient(135deg, #34d399 0%, #10b981 100%);
            color: white;
        }
        .orders-container .bg-danger {
            background: linear-gradient(135deg, #f87171 0%, #ef4444 100%);
            color: white;
        }
        .orders-container .bg-light {
            background: #f3f4f6;
            color: #6b7280;
            border: 1px solid #e5e7eb;
        }
        .orders-container .btn-group {
            display: flex;
            gap: 0.375rem;
        }
        .orders-container .btn {
            padding: 0.4rem 0.875rem;
            border: 1px solid;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
            background: white;
            text-decoration: none;
        }
        .orders-container .btn-outline-primary { 
            color: #3b82f6; 
            border-color: #3b82f6; 
        }
        .orders-container .btn-outline-primary:hover { 
            background: #3b82f6; 
            color: white;
            box-shadow: 0 2px 4px rgba(59, 130, 246, 0.3);
            transform: translateY(-1px);
        }
        .orders-container .btn-outline-success { 
            color: #10b981; 
            border-color: #10b981; 
        }
        .orders-container .btn-outline-success:hover { 
            background: #10b981; 
            color: white;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.3);
            transform: translateY(-1px);
        }
        .orders-container .btn-outline-info { 
            color: #0ea5e9; 
            border-color: #0ea5e9; 
        }
        .orders-container .btn-outline-info:hover { 
            background: #0ea5e9; 
            color: white;
            box-shadow: 0 2px 4px rgba(14, 165, 233, 0.3);
            transform: translateY(-1px);
        }
        .orders-container .btn-outline-secondary { 
            color: #6b7280; 
            border-color: #d1d5db; 
        }
        .orders-container .btn-outline-secondary:hover { 
            background: #f3f4f6;
            border-color: #9ca3af;
            color: #374151;
        }
        .empty-state {
            text-align: center;
            padding: 3rem 1.5rem;
            color: #9ca3af;
        }
        .alert {
            padding: 1rem;
            border-radius: 6px;
            margin: 1rem;
        }
        .alert-light {
            background: #f9fafb;
            color: #6b7280;
            border: 1px solid #e5e7eb;
        }
        
        /* Filters */
        .filter-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
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
            transition: all 0.15s;
        }
        .filter-select:hover {
            border-color: #9ca3af;
        }
        .filter-select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .filter-actions {
            display: flex;
            gap: 0.5rem;
        }
        .btn-filter {
            padding: 0.625rem 1.25rem;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
            box-shadow: 0 1px 2px rgba(59, 130, 246, 0.3);
        }
        .btn-filter:hover {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            box-shadow: 0 2px 4px rgba(59, 130, 246, 0.4);
            transform: translateY(-1px);
        }
        .btn-filter:active {
            transform: translateY(0);
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
            transition: all 0.15s;
        }
        .btn-filter-clear:hover {
            background: #f9fafb;
            border-color: #9ca3af;
            color: #374151;
        }
        
        /* Toast */
        .toast {
            position: fixed;
            top: 1rem;
            right: 1rem;
            background: white;
            padding: 0.875rem 1.25rem;
            border-radius: 6px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: 1px solid #e5e7eb;
            display: none;
            z-index: 9999;
            min-width: 280px;
            font-size: 0.875rem;
        }
        .toast.show { display: block; animation: slideIn 0.2s ease; }
        @keyframes slideIn {
            from { transform: translateX(400px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .toast-success { border-left: 3px solid #10b981; }
        .toast-error { border-left: 3px solid #ef4444; }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }
        .modal.show { display: flex; align-items: center; justify-content: center; }
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
        .modal-close:hover { color: #111827; }
        .modal-body {
            padding: 1.5rem;
            overflow-y: auto;
        }
        .detail-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .detail-section h4 {
            font-size: 1rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.75rem;
        }
        .detail-item {
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        .detail-label {
            font-weight: 500;
            color: #6b7280;
        }
        .detail-value {
            color: #111827;
        }
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .items-table th {
            background: #f9fafb;
            padding: 0.625rem;
            text-align: left;
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
            border-bottom: 1px solid #e5e7eb;
        }
        .items-table td {
            padding: 0.625rem;
            font-size: 0.875rem;
            color: #6b7280;
            border-bottom: 1px solid #f3f4f6;
        }
        .total-section {
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 2px solid #e5e7eb;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        .total-row.final {
            font-size: 1rem;
            font-weight: 600;
            color: #111827;
            margin-top: 0.75rem;
            padding-top: 0.75rem;
            border-top: 1px solid #e5e7eb;
        }
    </style>
</head>
<body>
    <div class="layout">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand">Staff POS</div>
            </div>
            
            <nav class="nav-menu">
                <div class="nav-item">
                    <div class="nav-link active" data-tab="dashboard">Dashboard</div>
                </div>
                <div class="nav-item">
                    <div class="nav-link" data-tab="tables">Danh Sách Bàn</div>
                </div>
                <div class="nav-item">
                    <div class="nav-link" data-tab="orders">Lịch Sử Đơn Hàng</div>
                </div>
            </nav>
            
            <div class="sidebar-footer">
                <div class="user-info">
                    <div class="user-avatar">${sessionScope.user.fullName.substring(0,1).toUpperCase()}</div>
                    <div>
                        <div class="user-name">${sessionScope.user.fullName}</div>
                        <div class="user-role">Nhân viên</div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Dashboard Tab -->
            <div class="tab-pane active" id="dashboard">
                <h1 class="page-title">Dashboard</h1>
                <div class="info-card">
                    <h3>${restaurant.name}</h3>
                    <p>${restaurant.address}</p>
                    <p>Trạng thái: 
                        <c:choose>
                            <c:when test="${restaurant.isOpen}">
                                <span style="color: #10b981; font-weight: 600;">Đang mở cửa</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #ef4444; font-weight: 600;">Đã đóng cửa</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- Tables Tab -->
            <div class="tab-pane" id="tables">

                <!-- Header + Stats -->
                <div class="tables-section-header">
                    <h1 class="page-title">Danh Sách Bàn</h1>
                    <div class="table-stats-bar">
                        <span class="stat-pill stat-pill-total">
                            <span class="stat-pill-dot dot-total"></span>
                            Tổng: <strong><c:out value="${fn:length(tables)}" default="0"/></strong>
                        </span>
                        <span class="stat-pill stat-pill-avail">
                            <span class="stat-pill-dot dot-avail"></span>
                            Trống: <strong id="countAvail">0</strong>
                        </span>
                        <span class="stat-pill stat-pill-occ">
                            <span class="stat-pill-dot dot-occ"></span>
                            Có khách: <strong id="countOcc">0</strong>
                        </span>
                    </div>
                </div>

                <!-- Grid -->
                <div class="tables-grid" id="tablesGrid">
                    <c:forEach var="table" items="${tables}">
                        <c:choose>
                            <c:when test="${table.tableStatus == 'Available'}">
                                <a href="${pageContext.request.contextPath}/staff/pos?tableId=${table.tableID}"
                                   class="table-card table-available"
                                   data-status="available">
                                    <div class="table-icon-wrap">
                                        <!-- Table icon -->
                                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M3 6h18v2H3V6zm2 4h14v2H5v-2zm-2 4h18v2H3v-2zm4 4h10v2H7v-2z"/>
                                        </svg>
                                    </div>
                                    <div class="table-label">Bàn số</div>
                                    <div class="table-number">${table.tableNumber}</div>
                                    <div class="table-capacity">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                            <circle cx="9" cy="7" r="4"/>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                        </svg>
                                        ${table.capacity} chỗ ngồi
                                    </div>
                                    <span class="table-status status-available">&#10003;&nbsp;Còn trống</span>
                                    <div class="table-cta">Nhấn để gọi món &rarr;</div>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/staff/table/order?tableId=${table.tableID}"
                                   class="table-card table-occupied"
                                   data-status="occupied">
                                    <div class="table-icon-wrap">
                                        <!-- People icon -->
                                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                            <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
                                        </svg>
                                    </div>
                                    <div class="table-label">Bàn số</div>
                                    <div class="table-number">${table.tableNumber}</div>
                                    <div class="table-capacity">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                            <circle cx="9" cy="7" r="4"/>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                        </svg>
                                        ${table.capacity} chỗ ngồi
                                    </div>
                                    <span class="table-status status-occupied">&#9679;&nbsp;Đang có khách</span>
                                    <div class="table-cta">Xem đơn hàng &rarr;</div>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </div>

            <!-- Orders Tab -->
            <div class="tab-pane" id="orders">
                <h1 class="page-title">Lịch Sử Đơn Hàng</h1>
                
                <!-- Filters -->
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
                        <div class="filter-actions">
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

    <!-- Toast Notification -->
    <div id="toast" class="toast"></div>

    <!-- Order Detail Modal -->
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
            link.addEventListener('click', function() {
                const tab = this.dataset.tab;
                
                // Update nav
                document.querySelectorAll('[data-tab]').forEach(l => l.classList.remove('active'));
                this.classList.add('active');
                
                // Update content
                document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
                document.getElementById(tab).classList.add('active');
                
                // Load orders if needed
                if (tab === 'orders' && !window.ordersLoaded) {
                    loadOrders();
                    window.ordersLoaded = true;
                }
            });
        });

        // Count available / occupied tables
        (function updateTableCounts() {
            const cards = document.querySelectorAll('#tablesGrid .table-card');
            let avail = 0, occ = 0;
            cards.forEach(c => {
                if (c.dataset.status === 'available') avail++;
                else occ++;
            });
            const elAvail = document.getElementById('countAvail');
            const elOcc   = document.getElementById('countOcc');
            if (elAvail) elAvail.textContent = avail;
            if (elOcc)   elOcc.textContent   = occ;
        })();

        // Load orders
        function loadOrders(tableId = null, fromDate = null, toDate = null, orderType = 'All') {
            let url = ctx + '/staff/orders?';
            if (tableId) url += 'tableId=' + tableId + '&';
            if (fromDate) url += 'fromDate=' + fromDate + '&';
            if (toDate) url += 'toDate=' + toDate + '&';
            if (orderType && orderType !== 'All') url += 'orderType=' + orderType;
            
            document.getElementById('ordersContent').innerHTML = '<div class="empty-state">Đang tải...</div>';
            
            fetch(url)
                .then(r => {
                    if (!r.ok) throw new Error('Network error');
                    return r.text();
                })
                .then(html => {
                    document.getElementById('ordersContent').innerHTML = html;
                    attachOrderEventListeners();
                })
                .catch(err => {
                    console.error('Error loading orders:', err);
                    document.getElementById('ordersContent').innerHTML = '<div class="empty-state">Lỗi tải dữ liệu</div>';
                });
        }

        // Apply filters
        function applyFilters() {
            const fromDate = document.getElementById('fromDateFilter').value;
            const toDate = document.getElementById('toDateFilter').value;
            const orderType = document.getElementById('orderTypeFilter').value;
            loadOrders(null, fromDate, toDate, orderType);
        }

        // Clear filters
        function clearFilters() {
            document.getElementById('fromDateFilter').value = '';
            document.getElementById('toDateFilter').value = '';
            document.getElementById('orderTypeFilter').value = 'All';
            loadOrders();
        }

        // View table orders
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-view')) {
                const tableId = e.target.dataset.tableId;
                // Switch to orders tab
                document.querySelector('[data-tab="orders"]').click();
                // Load orders for this table
                loadOrders(tableId);
            }
        });

        // Close table
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-close')) {
                const tableId = e.target.dataset.tableId;
                if (confirm('Xác nhận đóng bàn? Tất cả đơn hàng phải đã thanh toán.')) {
                    fetch(ctx + '/staff/table/close?tableId=' + tableId, { method: 'POST' })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showToast('Đóng bàn thành công', 'success');
                                setTimeout(() => location.reload(), 1000);
                            } else {
                                showToast(data.message || 'Không thể đóng bàn', 'error');
                            }
                        })
                        .catch(() => showToast('Lỗi kết nối', 'error'));
                }
            }
        });

        // Attach event listeners to order buttons
        function attachOrderEventListeners() {
            // View order detail
            document.querySelectorAll('.view-order-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const orderId = this.dataset.orderId;
                    viewOrderDetail(orderId);
                });
            });
            
            // Update order status
            document.querySelectorAll('.update-status-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const orderId = this.dataset.orderId;
                    const newStatus = this.dataset.newStatus;
                    const statusText = newStatus === 'Delivering' ? 'Đang giao hàng' : 'Hoàn thành';
                    
                    if (confirm('Cập nhật trạng thái đơn hàng #' + orderId + ' thành "' + statusText + '"?')) {
                        this.disabled = true;
                        this.innerHTML = 'Đang xử lý...';
                        
                        fetch(ctx + '/staff/order/update-status', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'orderId=' + orderId + '&status=' + newStatus
                        })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showToast('Đã cập nhật trạng thái', 'success');
                                loadOrders();
                            } else {
                                showToast(data.message || 'Lỗi cập nhật', 'error');
                                this.disabled = false;
                                this.innerHTML = statusText;
                            }
                        })
                        .catch(() => {
                            showToast('Lỗi kết nối', 'error');
                            this.disabled = false;
                            this.innerHTML = statusText;
                        });
                    }
                });
            });
            
            // Mark as paid buttons
            document.querySelectorAll('.mark-paid-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const orderId = this.dataset.orderId;
                    const orderNumber = this.dataset.orderNumber;
                    
                    if (confirm('Xác nhận đơn hàng ' + orderNumber + ' đã thanh toán?')) {
                        this.disabled = true;
                        this.innerHTML = 'Đang xử lý...';
                        
                        fetch(ctx + '/staff/order/mark-paid', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'orderId=' + orderId
                        })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showToast('Đã đánh dấu thanh toán', 'success');
                                loadOrders();
                            } else {
                                showToast(data.message || 'Lỗi', 'error');
                                this.disabled = false;
                                this.innerHTML = 'Đã TT';
                            }
                        })
                        .catch(() => {
                            showToast('Lỗi kết nối', 'error');
                            this.disabled = false;
                            this.innerHTML = 'Đã TT';
                        });
                    }
                });
            });
        }

        // View order detail
        function viewOrderDetail(orderId) {
            const modal = document.getElementById('orderModal');
            const content = document.getElementById('orderModalContent');
            
            content.innerHTML = '<div class="empty-state">Đang tải...</div>';
            modal.classList.add('show');
            
            fetch(ctx + '/staff/order/detail?orderId=' + orderId)
                .then(r => r.json())
                .then(data => {
                    if (data.error) {
                        content.innerHTML = '<div class="alert alert-light">' + data.error + '</div>';
                        return;
                    }
                    content.innerHTML = renderOrderDetail(data);
                })
                .catch(err => {
                    content.innerHTML = '<div class="alert alert-light">Lỗi tải dữ liệu</div>';
                });
        }

        // Close modal
        function closeModal() {
            document.getElementById('orderModal').classList.remove('show');
        }

        // Render order detail
        function renderOrderDetail(data) {
            const order = data.order;
            const items = data.items;
            
            let html = '<div class="detail-row">';
            html += '<div class="detail-section">';
            html += '<h4>Thông tin đơn hàng</h4>';
            html += '<div class="detail-item"><span class="detail-label">Mã đơn:</span> <span class="detail-value">#' + order.orderID + '</span></div>';
            html += '<div class="detail-item"><span class="detail-label">Khách hàng:</span> <span class="detail-value">' + order.customerName + '</span></div>';
            html += '<div class="detail-item"><span class="detail-label">Loại đơn:</span> <span class="detail-value">' + getOrderTypeText(order.orderType) + '</span></div>';
            html += '<div class="detail-item"><span class="detail-label">Trạng thái:</span> <span class="detail-value">' + getOrderStatusText(order.orderStatus) + '</span></div>';
            if (order.tableID) {
                html += '<div class="detail-item"><span class="detail-label">Bàn:</span> <span class="detail-value">' + order.tableID + '</span></div>';
            }
            html += '</div>';
            
            html += '<div class="detail-section">';
            html += '<h4>Thanh toán</h4>';
            html += '<div class="detail-item"><span class="detail-label">Phương thức:</span> <span class="detail-value">' + getPaymentMethodText(order.paymentMethod) + '</span></div>';
            html += '<div class="detail-item"><span class="detail-label">Trạng thái:</span> <span class="detail-value">' + getPaymentStatusText(order.paymentStatus) + '</span></div>';
            html += '<div class="detail-item"><span class="detail-label">Thời gian:</span> <span class="detail-value">' + formatDate(order.createdAt) + '</span></div>';
            html += '</div>';
            html += '</div>';
            
            html += '<h4>Món ăn</h4>';
            html += '<table class="items-table">';
            html += '<thead><tr><th>Món</th><th class="text-center">SL</th><th class="text-end">Đơn giá</th><th class="text-end">Thành tiền</th></tr></thead>';
            html += '<tbody>';
            
            items.forEach(item => {
                html += '<tr>';
                html += '<td>' + item.itemName;
                if (item.note) {
                    html += '<br><small style="color: #9ca3af;">' + item.note + '</small>';
                }
                html += '</td>';
                html += '<td style="text-align: center;">' + item.quantity + '</td>';
                html += '<td style="text-align: right;">' + formatCurrency(item.unitPrice) + ' đ</td>';
                html += '<td style="text-align: right;">' + formatCurrency(item.quantity * item.unitPrice) + ' đ</td>';
                html += '</tr>';
            });
            
            html += '</tbody></table>';
            
            html += '<div class="total-section">';
            html += '<div class="total-row"><span>Tạm tính:</span><span>' + formatCurrency(order.totalAmount) + ' đ</span></div>';
            if (order.discountAmount > 0) {
                html += '<div class="total-row"><span>Giảm giá:</span><span style="color: #10b981;">-' + formatCurrency(order.discountAmount) + ' đ</span></div>';
            }
            if (order.deliveryFee > 0) {
                html += '<div class="total-row"><span>Phí giao hàng:</span><span>' + formatCurrency(order.deliveryFee) + ' đ</span></div>';
            }
            html += '<div class="total-row final"><span>Tổng cộng:</span><span>' + formatCurrency(order.finalAmount) + ' đ</span></div>';
            html += '</div>';
            
            return html;
        }

        function getOrderTypeText(type) {
            const types = { 'DineIn': 'Ăn tại chỗ', 'Pickup': 'Mang đi', 'Online': 'Giao hàng' };
            return types[type] || type;
        }

        function getOrderStatusText(status) {
            const statuses = { 'Preparing': 'Đang chuẩn bị', 'Delivering': 'Đang giao', 'Completed': 'Hoàn thành', 'Cancelled': 'Đã hủy' };
            return statuses[status] || status;
        }

        function getPaymentMethodText(method) {
            const methods = { 'Cash': 'Tiền mặt', 'Card': 'Thẻ', 'VNPay': 'VNPay' };
            return methods[method] || method;
        }

        function getPaymentStatusText(status) {
            const statuses = { 'Success': 'Đã thanh toán', 'Pending': 'Chờ thanh toán', 'Failed': 'Thất bại' };
            return statuses[status] || status;
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount);
        }

        function formatDate(dateStr) {
            const date = new Date(dateStr);
            return date.toLocaleString('vi-VN');
        }

        // Toast notification
        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast toast-' + type + ' show';
            setTimeout(() => toast.classList.remove('show'), 3000);
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('orderModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
