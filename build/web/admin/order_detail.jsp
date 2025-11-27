<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết Đơn hàng #${order.id}</title>
        <link href="${pageContext.request.contextPath}/css/admin_style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <style>
            .main-content {
                padding: 20px;
            }
            .card {
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .card-header {
                padding: 15px 20px;
                border-bottom: 1px solid #eee;
            }
            .card-header h3 {
                margin: 0;
            }
            .card-body {
                padding: 20px;
            }
            .order-info, .customer-info {
                line-height: 1.8;
            }
            .order-info p, .customer-info p {
                margin: 0 0 10px 0;
            }
            .order-info p strong, .customer-info p strong {
                display: inline-block;
                min-width: 150px;
            }
            .product-list table {
                width: 100%;
                border-collapse: collapse;
            }
            .product-list th, .product-list td {
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
                text-align: left;
            }
            .product-list th {
                background-color: #f9f9f9;
            }
            .product-list img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 5px;
                vertical-align: middle;
                margin-right: 10px;
            }
            .total-row td {
                font-size: 1.2em;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="admin-wrapper">
            <%-- Giả sử bạn có một file admin_sidebar.jsp --%>


            <div class="main-content">
                <a href="${pageContext.request.contextPath}/admin/orders" style="margin-bottom: 20px; display: inline-block;">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại Danh sách Đơn hàng
                </a>

                <div class="card">
                    <div class="card-header">
                        <h3>Chi tiết Đơn hàng #${order.id}</h3>
                    </div>
                    <div class="card-body" style="display: flex; gap: 20px;">
                        <div class="customer-info" style="flex: 1;">
                            <h4>Thông tin khách hàng</h4>
                            <p><strong>Khách hàng:</strong> ${customer.fullname}</p>
                            <p><strong>Email:</strong> ${customer.email}</p>
                            <p><strong>Số điện thoại:</strong> ${customer.phoneNumber != null ? customer.phoneNumber : 'N/A'}</p>
                            <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>
                        </div>
                        <div class="order-info" style="flex: 1;">
                            <h4>Thông tin đơn hàng</h4>
                            <p><strong>Mã đơn hàng:</strong> #${order.id}</p>
                            <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="HH:mm dd/MM/yyyy"/></p>
                            <p><strong>Trạng thái:</strong> <span class="status ${order.status}">${order.status}</span></p>
                            <p><strong>Tổng tiền:</strong> 
                                <span style="color: #dc3545; font-weight: bold;">
                                    <fmt:formatNumber value="${order.totalMoney}" type="number"/>đ
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="card product-list">
                    <div class="card-header">
                        <h3>Các sản phẩm đã đặt</h3>
                    </div>
                    <div class="card-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Kích cỡ</th>
                                    <th>Số lượng</th>
                                    <th>Giá lúc mua</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderItems}" var="item">
                                    <tr>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/${item.product.imageUrl}" alt="${item.product.name}">
                                            ${item.product.name}
                                        </td>
                                        <td>${item.size}</td>
                                        <td>x ${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.product.salePrice}" type="number"/>đ</td>
                                        <td><fmt:formatNumber value="${item.totalPrice}" type="number"/>đ</td>
                                    </tr>
                                </c:forEach>
                                <tr class="total-row">
                                    <td colspan="4" style="text-align: right; border-bottom: none;"><strong>Tổng cộng:</strong></td>
                                    <td style="color: #dc3545; border-bottom: none;"><fmt:formatNumber value="${order.totalMoney}" type="number"/>đ</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>