<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Sản phẩm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/> <%-- Link CSS admin --%>
        <%-- CSS riêng cho bảng --%>
        <style>
            .product-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            .product-table th, .product-table td {
                padding: 12px 15px;
                border: 1px solid #e0e0e0;
                text-align: left;
                vertical-align: middle;
            }
            .product-table thead th {
                background-color: #f4f7fc;
                font-weight: 600;
            }
            .product-table tbody tr:hover {
                background-color: #f9f9f9;
            }
            .product-table img {
                max-width: 60px;
                max-height: 60px;
                border-radius: 4px;
            }
            .action-buttons a {
                margin-right: 8px;
                color: #3498db;
            }
            .action-buttons a.delete {
                color: #e74c3c;
            }
            .search-add-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .search-form input {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .search-form button {
                padding: 8px 15px;
                background: #3498db;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                margin-left: 5px;
            }
            .btn-add-new {
                padding: 10px 20px;
                background: #2ecc71;
                color: white;
                border-radius: 4px;
                font-weight: bold;
                /* --- DÁN VÀO <style> CỦA admin/product_list.jsp --- */
            }
            .pagination {
                display: flex;
                justify-content: center; /* Căn giữa */
                align-items: center;
                list-style: none; /* Bỏ dấu chấm */
                padding: 0;
                margin-top: 20px; /* Khoảng cách với bảng */
            }
            .pagination li {
                margin: 0 5px;
            }
            .pagination li a {
                display: block;
                padding: 8px 14px;
                text-decoration: none;
                color: #3498db; /* Màu xanh dương (màu admin) */
                border: 1px solid #e0e0e0; /* Viền xám nhạt */
                border-radius: 4px;
                transition: all 0.2s;
                font-weight: bold;
            }
            .pagination li a:hover {
                background-color: #f4f7fc; /* Màu nền xám xanh nhạt */
                color: #2980b9;
            }
            .pagination li.active a {
                background-color: #3498db; /* Nền xanh */
                color: white; /* Chữ trắng */
                border-color: #3498db;
            }
            .pagination li.disabled a {
                color: #aaa;
                pointer-events: none; /* Không cho bấm */
                border-color: #eee;
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
                <header class="admin-header"><h1>Danh sách Sản phẩm</h1></header>

                <div class="search-add-bar">
                    <form action="#" method="GET" class="search-form"> <%-- Action tìm kiếm sẽ làm sau --%>
                        <input type="text" name="keyword" placeholder="Tìm theo tên sản phẩm...">
                        <button type="submit">Tìm kiếm</button>
                    </form>
                    <a href="products?action=add" class="btn-add-new">+ Thêm Sản phẩm mới</a>
                </div>

                <table class="product-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá bán</th>
                            <th>Giá gốc</th>
                            <th>Kho hàng</th>
                            <th>Đã bán</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${productList}" var="p">
                            <tr>
                                <td>${p.id}</td>
                                <td><img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}"></td>
                                <td>${p.name}</td>
                                <td><fmt:formatNumber value="${p.salePrice > 0 ? p.salePrice : p.originalPrice}" type="number"/>đ</td>
                                <td><fmt:formatNumber value="${p.originalPrice}" type="number"/>đ</td>
                                <td>${p.totalStock}</td>
                                <td>${p.soldQuantity}</td>
                                <td class="action-buttons">
                                    <a href="products?action=edit&pid=${p.id}" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></a>
                                    <a href="products?action=delete&pid=${p.id}" class="delete" title="Xóa" onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <%-- PHẦN PHÂN TRANG (ADMIN) --%>
                <ul class="pagination">
                    <%-- Nút Lùi (Previous) --%>
                    <li class="${currentPage == 1 ? 'disabled' : ''}">
                        <c:url var="prevUrl" value="products">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:if test="${not empty searchKeyword}"><c:param name="keyword" value="${searchKeyword}"/></c:if>
                        </c:url>
                        <a href="${prevUrl}">&laquo;</a>
                    </li>
                    <%-- Các nút số trang --%>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="${currentPage == i ? 'active' : ''}">
                            <c:url var="pageUrl" value="products">
                                <c:param name="page" value="${i}"/>
                                <c:if test="${not empty searchKeyword}"><c:param name="keyword" value="${searchKeyword}"/></c:if>
                            </c:url>
                            <a href="${pageUrl}">${i}</a>
                        </li>
                    </c:forEach>
                    <%-- Nút Tới (Next) --%>
                    <li class="${currentPage == totalPages ? 'disabled' : ''}">
                        <c:url var="nextUrl" value="products">
                            <c:param name="page" value="${currentPage + 1}"/>
                            <c:if test="${not empty searchKeyword}"><c:param name="keyword" value="${searchKeyword}"/></c:if>
                        </c:url>
                        <a href="${nextUrl}">&raquo;</a>
                    </li>
                </ul>
            </main>
        </div>

        <%-- JavaScript (nếu cần) --%>
    </body>
</html>