<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Đơn hàng</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
        <%-- CSS riêng cho bảng --%>
        <style>
            .order-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            .order-table th, .order-table td {
                padding: 12px 15px;
                border: 1px solid #e0e0e0;
                text-align: left;
                vertical-align: middle;
            }
            .order-table thead th {
                background-color: #f4f7fc;
                font-weight: 600;
            }
            .order-table tbody tr:hover {
                background-color: #f9f9f9;
            }
            .action-buttons a {
                margin-right: 8px;
                color: #3498db;
            }
            .search-filter-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            /* Style cho dropdown trạng thái */
            .status-pending {
                color: orange;
                font-weight: bold;
            }
            .status-completed {
                color: green;
                font-weight: bold;
            }
            .status-cancelled {
                color: red;
                font-weight: bold;
            }
            .status-select {
                padding: 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
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
                <header class="admin-header"><h1>Danh sách Đơn hàng</h1></header>

                <div class="search-filter-bar">
                    <%-- Form tìm kiếm/lọc sẽ làm sau --%>
                    <div></div>
                </div>

                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Mã Đơn</th>
                                <%-- <th>Tên Khách Hàng</th> --%> <%-- Bỏ comment nếu đã thêm userFullname vào Order.java --%>
                            <th>Ngày Đặt</th>
                            <th>Tổng Tiền</th>
                            <th>Địa Chỉ Giao Hàng</th>
                            <th>Trạng Thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orderList}" var="order">
                            <tr>
                                <td>#${order.id}</td>
                                <%-- <td>${order.userFullname}</td> --%>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatNumber value="${order.totalMoney}" type="number"/>đ</td>
                                <td>${order.shippingAddress}</td>
                                <td>
                                    <%-- Dropdown để đổi trạng thái --%>
                                    <form action="orders" method="GET" style="display: inline;">
                                        <input type="hidden" name="action" value="update_status">
                                        <input type="hidden" name="oid" value="${order.id}">
                                        <select name="status" class="status-select" onchange="this.form.submit()">
                                            <option value="pending" ${order.status == 'pending' ? 'selected' : ''} class="status-pending">Pending</option>
                                            <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Processing</option>
                                            <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Shipped</option>
                                            <option value="completed" ${order.status == 'completed' ? 'selected' : ''} class="status-completed">Completed</option>
                                            <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''} class="status-cancelled">Cancelled</option>
                                        </select>
                                    </form>
                                </td>
                                <td class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=view&oid=${order.id}" class="btn btn-view" title="Xem chi tiết">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

            </main>
        </div>
    </body>
</html>