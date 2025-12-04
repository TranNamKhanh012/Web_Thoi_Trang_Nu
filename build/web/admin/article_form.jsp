<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%-- SỬA LỖI: Kiểm tra id > 0 thay vì 'empty' --%>
        <title>${article.id > 0 ? 'Sửa' : 'Thêm'} Bài viết</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
        <style>
            .form-section {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                max-width: 800px;
                margin: 0 auto;
            }
            .form-section h1 {
                margin-bottom: 20px;
                font-size: 24px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-group input[type="text"],
            .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .form-group textarea {
                min-height: 250px;
                resize: vertical;
            }
            .btn-submit {
                padding: 12px 25px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }
            .btn-save {
                background: #2ecc71;
                color: white;
            }
        </style>
        <%-- Script cho CKEditor (Tùy chọn) --%>
        <script src="https://cdn.ckeditor.com/4.16.2/standard/ckeditor.js"></script>
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
                        <li><a href="${pageContext.request.contextPath}/admin/settings" class="${activePage == 'settings' ? 'active' : ''}"><i class="fa-solid fa-gear"></i> Quản lý ngày giảm giá</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/inventory" class="${activePage == 'inventory' ? 'active' : ''}"><i class="fa-solid fa-boxes-stacked"></i> Thống kê Hàng tồn</a></li>
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                    </ul>
                </nav>
            </aside>

            <%-- MAIN CONTENT --%>
            <main class="admin-main-content">
                <%-- SỬA LỖI: Kiểm tra id > 0 --%>
                <header class="admin-header"><h1>${article.id > 0 ? 'Chỉnh sửa Bài viết' : 'Thêm Bài viết mới'}</h1></header>

                <div class="form-section">
                    <form action="articles" method="POST" onsubmit="CKEDITOR.instances.content.updateElement();">
                        <input type="hidden" name="action" value="save">
                        
                        <%-- SỬA LỖI: Chỉ gửi 'id' nếu id > 0 (là form Sửa) --%>
                        <c:if test="${article.id > 0}">
                            <input type="hidden" name="id" value="${article.id}">
                        </c:if>

                        <div class="form-group">
                            <label for="title">Tiêu đề *</label>
                            <input type="text" id="title" name="title" value="${article.title}" required>
                        </div>
                        <div class="form-group">
                            <label for="imageUrl">URL Ảnh bìa</label>
                            <input type="text" id="imageUrl" name="imageUrl" value="${article.imageUrl}">
                        </div>
                        <div class="form-group">
                            <label for="content">Nội dung *</label>
                            <textarea id="content" name="content" required>${article.content}</textarea>
                        </div>
                        <button type="submit" class="btn-submit btn-save">Lưu Bài viết</button>
                        <a href="articles" style="margin-left: 10px;">Hủy</a>
                    </form>
                </div>

                <%-- Kích hoạt CKEditor (Tùy chọn) --%>
                <script>CKEDITOR.replace('content');</script>
            </main>
        </div>
    </body>
</html>