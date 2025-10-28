<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Bài viết</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
    <style>
        .article-table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .article-table th, .article-table td { padding: 12px 15px; border: 1px solid #e0e0e0; text-align: left; vertical-align: middle;}
        .article-table thead th { background-color: #f4f7fc; font-weight: 600; }
        .article-table tbody tr:hover { background-color: #f9f9f9; }
        .article-table img { max-width: 100px; max-height: 60px; border-radius: 4px; object-fit: cover;}
        .action-buttons a { margin-right: 8px; color: #3498db; }
        .action-buttons a.delete { color: #e74c3c; }
        .add-bar { text-align: right; margin-bottom: 20px; }
        .btn-add-new { padding: 10px 20px; background: #2ecc71; color: white; border-radius: 4px; font-weight: bold;}
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
            <header class="admin-header"><h1>Quản lý Bài viết</h1></header>

            <div class="add-bar">
                <a href="articles?action=add" class="btn-add-new">+ Thêm Bài viết mới</a>
            </div>

            <table class="article-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ảnh bìa</th>
                        <th>Tiêu đề</th>
                        <th>Ngày đăng</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${articleList}" var="a">
                        <tr>
                            <td>${a.id}</td>
                            <td><img src="${pageContext.request.contextPath}/${a.imageUrl}" alt="${a.title}"></td>
                            <td>${a.title}</td>
                            <td><fmt:formatDate value="${a.createdDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="action-buttons">
                                <a href="articles?action=edit&id=${a.id}" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></a>
                                <a href="articles?action=delete&id=${a.id}" class="delete" title="Xóa" onclick="return confirm('Bạn chắc chắn muốn xóa bài viết này?')"><i class="fa-solid fa-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </main>
    </div>
</body>
</html>