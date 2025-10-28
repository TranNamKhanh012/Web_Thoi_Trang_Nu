<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty userToEdit.id ? 'Thêm' : 'Sửa'} Người dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
    <style>
        .form-section { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); max-width: 600px; margin: 0 auto; }
        .form-section h1 { margin-bottom: 20px; font-size: 24px;}
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group input[type="password"],
        .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-submit { padding: 12px 25px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-save { background: #2ecc71; color: white; }
        .form-error { color: red; margin-bottom: 15px; font-weight: bold;}
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
                    <li><a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="fa-solid fa-users"></i> Quản lý Người dùng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders" class="${activePage == 'orders' ? 'active' : ''}"><i class="fa-solid fa-receipt"></i> Quản lý Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/articles" class="${activePage == 'articles' ? 'active' : ''}"><i class="fa-solid fa-newspaper"></i> Quản lý Bài viết</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/feedback" class="${activePage == 'feedback' ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Quản lý Phản hồi</a></li>
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                </ul>
            </nav>
        </aside>

        <%-- MAIN CONTENT --%>
        <main class="admin-main-content">
             <header class="admin-header"><h1>${empty userToEdit.id ? 'Thêm Người dùng mới' : 'Chỉnh sửa Người dùng'}</h1></header>
            
            <div class="form-section">
                 <c:if test="${not empty formError}">
                    <p class="form-error">${formError}</p>
                </c:if>
                <form action="users" method="POST">
                    <input type="hidden" name="action" value="save">
                    <c:if test="${not empty userToEdit.id}">
                        <input type="hidden" name="uid" value="${userToEdit.id}">
                    </c:if>

                    <div class="form-group">
                        <label for="fullname">Họ và Tên *</label>
                        <input type="text" id="fullname" name="fullname" value="${userToEdit.fullname}" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" value="${userToEdit.email}" required ${not empty userToEdit.id ? 'readonly' : ''}> <%-- Không cho sửa email nếu là edit --%>
                    </div>
                     <div class="form-group">
                        <label for="password">Mật khẩu ${empty userToEdit.id ? '*' : '(Để trống nếu không đổi)'}</label>
                        <input type="password" id="password" name="password" ${empty userToEdit.id ? 'required' : ''}>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" value="${userToEdit.phoneNumber}">
                    </div>
                     <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" value="${userToEdit.address}">
                    </div>
                     <div class="form-group">
                        <label for="role">Vai trò *</label>
                        <select id="role" name="role" required>
                             <option value="customer" ${userToEdit.role == 'customer' ? 'selected' : ''}>Customer</option>
                             <option value="admin" ${userToEdit.role == 'admin' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-submit btn-save">Lưu</button>
                    <a href="users" style="margin-left: 10px;">Hủy</a>
                </form>
            </div>
            
        </main>
    </div>
</body>
</html>