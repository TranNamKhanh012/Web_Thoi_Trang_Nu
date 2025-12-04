<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cảnh báo Hàng tồn kho - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
    <style>
        /* --- COPY STYLE CƠ BẢN TỪ DASHBOARD --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7fc; color: #333; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        .admin-layout { display: flex; min-height: 100vh; }
        
        /* Sidebar Style */
        .admin-sidebar { width: 250px; background-color: #2c3e50; color: #ecf0f1; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-header { padding: 20px; text-align: center; background-color: #34495e; }
        .sidebar-header h2 { font-size: 24px; }
        .sidebar-nav ul { padding-top: 20px; }
        .sidebar-nav li a { display: block; padding: 15px 20px; color: #bdc3c7; transition: background-color 0.3s, color 0.3s; }
        .sidebar-nav li a i { margin-right: 15px; width: 20px; text-align: center; }
        .sidebar-nav li a:hover, .sidebar-nav li a.active { background-color: #3498db; color: #fff; }
        
        /* Main Content Style */
        .admin-main-content { flex-grow: 1; padding: 30px; background-color: #f4f7fc; }
        .admin-header { margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #e0e0e0; }
        .admin-header h1 { font-size: 28px; color: #2c3e50; }

        /* --- STYLE RIÊNG CHO TRANG HÀNG TỒN --- */
        .warning-box {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .warning-icon { font-size: 24px; margin-right: 15px; }
        
        /* Table Style */
        .chart-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .table { width: 100%; border-collapse: collapse; }
        .table th, .table td { padding: 12px 15px; border-bottom: 1px solid #eee; text-align: left; }
        .table th { background-color: #f8f9fa; font-weight: 600; }
        .table img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
        .stock-high { color: #dc3545; font-weight: bold; }
        .btn-sale { background-color: #28a745; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 12px; }
        .btn-sale:hover { background-color: #218838; }
    </style>
</head>
<body>
    <div class="admin-layout">
        
        <%-- SIDEBAR (Dán trực tiếp vào đây thay vì include) --%>
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>Fashion Admin</h2>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/admin" class="${activePage == 'dashboard' ? 'active' : ''}"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/products" class="${activePage == 'products' ? 'active' : ''}"><i class="fa-solid fa-box"></i> Quản lý Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories" class="${activePage == 'categories' ? 'active' : ''}"><i class="fa-solid fa-tags"></i> Quản lý Danh mục</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users" class="${activePage == 'users' ? 'active' : ''}"><i class="fa-solid fa-users"></i> Quản lý Người dùng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders" class="${activePage == 'orders' ? 'active' : ''}"><i class="fa-solid fa-receipt"></i> Quản lý Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/articles" class="${activePage == 'articles' ? 'active' : ''}"><i class="fa-solid fa-newspaper"></i> Quản lý Bài viết</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/feedback" class="${activePage == 'feedback' ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Quản lý Phản hồi</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/settings" class="${activePage == 'settings' ? 'active' : ''}"><i class="fa-solid fa-gear"></i> Quản lý ngày giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/inventory" class="${activePage == 'inventory' ? 'active' : ''}"><i class="fa-solid fa-boxes-stacked"></i> Thống kê Hàng tồn</a></li>
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                </ul>
            </nav>
        </aside>

        <%-- MAIN CONTENT --%>
        <main class="admin-main-content">
            <header class="admin-header">
                <h1>Thống kê Hàng tồn kho (30 ngày chưa bán)</h1>
            </header>

            <div class="warning-box">
                <div style="display: flex; align-items: center;">
                    <i class="fa-solid fa-triangle-exclamation warning-icon"></i>
                    <div>
                        <strong>Cảnh báo hàng chậm luân chuyển!</strong><br>
                        Có <b>${productList.size()}</b> mã sản phẩm không phát sinh đơn hàng trong 30 ngày qua.
                    </div>
                </div>
                <div style="text-align: right;">
                    Tổng vốn đang bị chôn:<br>
                    <strong style="font-size: 20px; color: #dc3545;">
                        <fmt:formatNumber value="${totalSlowValue}" type="number"/>đ
                    </strong>
                </div>
            </div>

            <div class="chart-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá gốc</th>
                            <th>Giá bán hiện tại</th>
                            <th>Tồn kho thực tế</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty productList}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 20px;">
                                    Tuyệt vời! Không có sản phẩm nào bị tồn kho quá lâu.
                                </td>
                            </tr>
                        </c:if>
                        
                        <c:forEach items="${productList}" var="p">
                            <tr>
                                <td>
                                    <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}">
                                </td>
                                <td>
                                    <strong>${p.name}</strong><br>
                                    <span style="font-size: 12px; color: #888;">ID: ${p.id}</span>
                                </td>
                                <td><fmt:formatNumber value="${p.originalPrice}" type="number"/>đ</td>
                                <td>
                                    <c:if test="${p.salePrice > 0}">
                                        <fmt:formatNumber value="${p.salePrice}" type="number"/>đ
                                    </c:if>
                                    <c:if test="${p.salePrice == 0}">
                                        Chưa giảm
                                    </c:if>
                                </td>
                                <td class="stock-high">
                                    ${p.soldQuantity}
                                    <span style="font-size: 11px; color: #666; font-weight: normal;"></span>
                                </td>
                                <td>
                                    <a href="products?action=edit&id=${p.id}" class="btn-sale">
                                        <i class="fa-solid fa-tag"></i> Giảm giá ngay
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>