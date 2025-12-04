<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Khuyến mãi</title>
    <link href="../css/admin_style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .setting-card { background: white; padding: 30px; border-radius: 8px; max-width: 600px; margin: 30px auto; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; }
        .days-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
        .btn-save { background: #28a745; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 4px; font-size: 16px; }
    </style>
</head>
<body>
    <div class="admin-layout">
            <%-- SIDEBAR --%>
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
    <div class="admin-main-content">
        <h2 style="text-align: center;">Chương trình Khuyến mãi</h2>
        
        <div class="setting-card">
            <form action="settings" method="POST">
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select name="enable" style="padding: 8px; width: 100%;">
                        <option value="1" ${promoEnable == '1' ? 'selected' : ''}>ĐANG BẬT</option>
                        <option value="0" ${promoEnable == '0' ? 'selected' : ''}>TẮT</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Mức giảm giá (%):</label>
                    <input type="number" name="percent" value="${promoPercent}" style="padding: 8px; width: 100%;">
                </div>

                <div class="form-group">
                    <label>Áp dụng vào các ngày:</label>
                    <div class="days-grid">
                        <label><input type="checkbox" name="days" value="MONDAY" ${promoDays.contains('MONDAY') ? 'checked' : ''}> Thứ 2</label>
                        <label><input type="checkbox" name="days" value="TUESDAY" ${promoDays.contains('TUESDAY') ? 'checked' : ''}> Thứ 3</label>
                        <label><input type="checkbox" name="days" value="WEDNESDAY" ${promoDays.contains('WEDNESDAY') ? 'checked' : ''}> Thứ 4</label>
                        <label><input type="checkbox" name="days" value="THURSDAY" ${promoDays.contains('THURSDAY') ? 'checked' : ''}> Thứ 5</label>
                        <label><input type="checkbox" name="days" value="FRIDAY" ${promoDays.contains('FRIDAY') ? 'checked' : ''}> Thứ 6</label>
                        <label><input type="checkbox" name="days" value="SATURDAY" ${promoDays.contains('SATURDAY') ? 'checked' : ''}> Thứ 7</label>
                        <label><input type="checkbox" name="days" value="SUNDAY" ${promoDays.contains('SUNDAY') ? 'checked' : ''}> Chủ nhật</label>
                    </div>
                </div>

                <button type="submit" class="btn-save">Lưu Cấu Hình</button>
            </form>
            
            <c:if test="${not empty msg}">
                <p style="color: green; text-align: center; margin-top: 15px;">${msg}</p>
            </c:if>
        </div>
    </div>
    </div>
</body>
</html>