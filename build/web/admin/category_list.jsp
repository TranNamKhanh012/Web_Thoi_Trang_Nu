<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
    <style>
        .category-table { width: 100%; max-width: 600px; margin-bottom: 30px; border-collapse: collapse; background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .category-table th, .category-table td { padding: 12px 15px; border: 1px solid #e0e0e0; text-align: left; vertical-align: middle;}
        .category-table thead th { background-color: #f4f7fc; font-weight: 600; }
        .category-table tbody tr:hover { background-color: #f9f9f9; }
        .action-buttons a { margin-right: 8px; color: #3498db; }
        .action-buttons a.delete { color: #e74c3c; }
        .form-section { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); max-width: 600px; }
        .form-section h3 { margin-bottom: 15px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-submit { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-add { background: #2ecc71; color: white; }
        .btn-update { background: #3498db; color: white; }
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
            <header class="admin-header"><h1>Quản lý Danh mục</h1></header>

            <%-- FORM THÊM / SỬA --%>
            <div class="form-section">
                <c:choose>
                    <c:when test="${not empty categoryToEdit}">
                        <%-- Form Sửa --%>
                        <h3>Chỉnh sửa Danh mục</h3>
                        <form action="categories" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${categoryToEdit.id}">
                            <div class="form-group">
                                <label for="catNameEdit">Tên Danh mục</label>
                                <input type="text" id="catNameEdit" name="name" value="${categoryToEdit.name}" required>
                            </div>
                            <button type="submit" class="btn-submit btn-update">Cập nhật</button>
                            <a href="categories" style="margin-left: 10px;">Hủy</a>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <%-- Form Thêm --%>
                        <h3>Thêm Danh mục mới</h3>
                        <form action="categories" method="POST">
                            <input type="hidden" name="action" value="add">
                            <div class="form-group">
                                <label for="catNameAdd">Tên Danh mục</label>
                                <input type="text" id="catNameAdd" name="name" required>
                            </div>
                            <button type="submit" class="btn-submit btn-add">Thêm mới</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>

            <hr style="margin: 30px 0;">

            <%-- BẢNG DANH SÁCH --%>
            <h3>Danh sách Danh mục hiện có</h3>
            <table class="category-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên Danh mục</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${categoryList}" var="c">
                        <tr>
                            <td>${c.id}</td>
                            <td>${c.name}</td>
                            <td class="action-buttons">
                                <a href="categories?action=edit&id=${c.id}" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></a>
                                <a href="categories?action=delete&id=${c.id}" class="delete" title="Xóa" onclick="return confirm('Xóa danh mục này?')"><i class="fa-solid fa-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </main>
    </div>
</body>
</html>