<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
    <%-- CSS riêng cho bảng (tương tự trang sản phẩm) --%>
    <style>
        .user-table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .user-table th, .user-table td { padding: 12px 15px; border: 1px solid #e0e0e0; text-align: left; vertical-align: middle;}
        .user-table thead th { background-color: #f4f7fc; font-weight: 600; }
        .user-table tbody tr:hover { background-color: #f9f9f9; }
        .action-buttons a { margin-right: 8px; color: #3498db; }
        .action-buttons a.delete { color: #e74c3c; }
        .search-add-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .search-form input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .search-form button { padding: 8px 15px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; margin-left: 5px;}
        .btn-add-new { padding: 10px 20px; background: #2ecc71; color: white; border-radius: 4px; font-weight: bold;}
        .role-admin { background-color: #e74c3c; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;}
        .role-customer { background-color: #2ecc71; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;}
         /* CSS cho thông báo lỗi admin */
        .admin-error-message { padding: 10px; background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 4px; margin-bottom: 15px; text-align: center; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%-- SIDEBAR --%>
        <aside class="admin-sidebar">
            <div class="sidebar-header"><h2>Fashion Admin</h2></div>
            <nav class="sidebar-nav">
                 <ul>
                    <li><a href="${pageContext.request.contextPath}/admin" class="${activePage == 'dashboard' ? 'active' : ''}"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/products" class="${activePage == 'products' ? 'active' : ''}"><i class="fa-solid fa-box"></i> Quản lý Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories" class="${activePage == 'categories' ? 'active' : ''}"><i class="fa-solid fa-tags"></i> Quản lý Danh mục</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users" class="${activePage == 'users' ? 'active' : ''}"><i class="fa-solid fa-users"></i> Quản lý Người dùng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders" class="${activePage == 'orders' ? 'active' : ''}"><i class="fa-solid fa-receipt"></i> Quản lý Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/articles" class="${activePage == 'articles' ? 'active' : ''}"><i class="fa-solid fa-newspaper"></i> Quản lý Bài viết</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/feedback" class="${activePage == 'feedback' ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Quản lý Phản hồi</a></li>
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                </ul>
            </nav>
        </aside>

        <%-- MAIN CONTENT --%>
        <main class="admin-main-content">
            <header class="admin-header"><h1>Danh sách Người dùng</h1></header>

            <%-- Hiển thị thông báo lỗi (nếu có) --%>
            <c:if test="${not empty sessionScope.adminErrorMsg}">
                <div class="admin-error-message">${sessionScope.adminErrorMsg}</div>
                <c:remove var="adminErrorMsg" scope="session"/>
            </c:if>

            <div class="search-add-bar">
                <%-- Sửa lại form: dùng method GET cho tìm kiếm --%>
                <form action="users" method="GET" class="search-form">
                    <%-- Đặt value cho ô input để giữ lại từ khóa đã tìm --%>
                    <input type="text" name="keyword" placeholder="Tìm theo tên hoặc email..."
                           value="${not empty searchKeyword ? searchKeyword : ''}">
                    <button type="submit">Tìm kiếm</button>
                </form>
                <%-- Nút Thêm người dùng (đã bỏ) --%>
            </div>

            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ Tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${userList}" var="u">
                        <tr>
                            <td>${u.id}</td>
                            <td>${u.fullname}</td>
                            <td>${u.email}</td>
                            <td>${u.phoneNumber}</td>
                            <td>
                                <span class="${u.role == 'admin' ? 'role-admin' : 'role-customer'}">
                                    ${u.role == 'admin' ? 'ADMIN' : 'CUSTOMER'}
                                </span>
                            </td>
                            <td class="action-buttons">
                                <%-- >>> ĐẢM BẢO HREF NÀY ĐÚNG <<< --%>
                                <a href="users?action=edit&uid=${u.id}" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></a>

                                <%-- Code nút Xóa --%>
                                <c:if test="${sessionScope.acc.id != u.id}">
                                    <a href="users?action=delete&uid=${u.id}" class="delete" title="Xóa" onclick="return confirm('Bạn chắc chắn muốn xóa người dùng này?')"><i class="fa-solid fa-trash"></i></a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </main>
    </div>
</body>
</html>