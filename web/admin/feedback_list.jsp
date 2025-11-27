<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Phản hồi</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
        <style>
            .feedback-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            .feedback-table th, .feedback-table td {
                padding: 12px 15px;
                border: 1px solid #e0e0e0;
                text-align: left;
                vertical-align: middle;
            }
            .feedback-table thead th {
                background-color: #f4f7fc;
                font-weight: 600;
            }
            .feedback-table tbody tr:hover {
                background-color: #f9f9f9;
            }
            .feedback-message {
                max-width: 300px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .status-new {
                color: orange;
                font-weight: bold;
            }
            .status-read {
                color: blue;
            }
            .status-replied {
                color: green;
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
                        <li><a href="${pageContext.request.contextPath}/admin/feedback" class="${activePage == 'feedback' ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Quản lý Phản hồi</a></li> <%-- Link mới --%>
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                    </ul>
                </nav>
            </aside>

            <%-- MAIN CONTENT --%>
            <main class="admin-main-content">
                <header class="admin-header"><h1>Quản lý Phản hồi Khách hàng</h1></header>

                <table class="feedback-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người gửi</th>
                            <th>Email</th>
                            <th>Chủ đề</th>
                            <th>Nội dung</th>
                            <th>Ngày nhận</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${feedbackList}" var="fb">
                            <tr>
                                <td>${fb.id}</td>
                                <%-- SỬA CÁC DÒNG NÀY --%>
                                <td>${fb.userName} <br> (ID: ${fb.userId})</td>
                                <td>${fb.userEmail}</td>
                                <td>${fb.subject}</td>
                                <td class="feedback-message" title="${fb.message}">${fb.message}</td>
                                <td><fmt:formatDate value="${fb.receivedDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>
                                    <%-- Dropdown đổi trạng thái --%>
                                    <form action="feedback" method="GET" style="display: inline;">
                                        <input type="hidden" name="action" value="update_status">
                                        <input type="hidden" name="id" value="${fb.id}">
                                        <select name="status" class="status-select" onchange="this.form.submit()">
                                            <option value="new" ${fb.status == 'new' ? 'selected' : ''} class="status-new">Mới</option>
                                            <option value="read" ${fb.status == 'read' ? 'selected' : ''} class="status-read">Đã đọc</option>
                                            <option value="replied" ${fb.status == 'replied' ? 'selected' : ''} class="status-replied">Đã trả lời</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty feedbackList}">
                            <tr><td colspan="7" style="text-align: center;">Chưa có phản hồi nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>

            </main>
        </div>
    </body>
</html>