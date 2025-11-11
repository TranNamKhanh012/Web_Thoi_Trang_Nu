<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lịch sử mua hàng - ShopFashion</title>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <style>
            .page-container {
                margin-top: 135px;
                background: #f9f9f9;
                padding: 40px 0 80px 0;
            }
            .page-container .container {
                display: block;
            }
            .breadcrumbs {
                margin-bottom: 25px;
                color: #888;
                font-size: 14px;
            }
            .breadcrumbs a {
                color: #333;
            }
            .page-title {
                text-align: center;
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 40px;
            }

            .order-history-list {
                max-width: 900px;
                margin: 0 auto;
            }
            .order-card {
                background: white;
                border: 1px solid #ddd;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .order-header {
                padding: 15px 20px;
                background: #f7f7f7;
                border-bottom: 1px solid #ddd;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .order-header h4 {
                margin: 0;
            }
            .order-header span {
                font-weight: bold;
            }
            .order-body {
                padding: 20px;
            }
            .order-meta {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
            }
            .order-item {
                display: flex;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }
            .order-item:last-child {
                border-bottom: none;
            }
            .order-item img {
                width: 60px;
                height: 60px;
                margin-right: 15px;
            }
            .order-item-info {
                flex-grow: 1;
            }
            .order-item-info span {
                display: block;
            }
            .order-item-info .item-price {
                color: #888;
                /* Thêm style cho nút in hóa đơn */
                .btn-print-invoice {
                    display: inline-block;
                    padding: 5px 10px;
                    font-size: 12px;
                    font-weight: bold;
                    color: #007bff;
                    border: 1px solid #007bff;
                    border-radius: 4px;
                    text-decoration: none;
                    margin-right: 15px;
                    transition: all 0.2s;
                }
                .btn-print-invoice:hover {
                    background: #007bff;
                    color: white;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="page-container">
            <div class="container">
                <div class="breadcrumbs">
                    <a href="home">Trang chủ</a> > Lịch sử mua hàng
                </div>
                <h1 class="page-title">Lịch sử mua hàng</h1>

                <div class="order-history-list">
                    <c:if test="${empty orderList}">
                        <div style="text-align: center; padding: 50px; background: white;">
                            <h2 style="margin-bottom: 20px;">Bạn chưa có đơn hàng nào!</h2>
                            <a href="products" class="btn-action">TIẾP TỤC MUA SẮM</a>
                        </div>
                    </c:if>

                    <c:forEach items="${orderList}" var="order">
                        <div class="order-card">
                            <div class="order-header">
                                <h4>Mã đơn hàng: #${order.id}</h4>
                                <a href="${pageContext.request.contextPath}/download-invoice?orderId=${order.id}" class="btn-print-invoice">
                                    <i class="fa-solid fa-print"></i> In Hóa Đơn (.txt)
                                </a>
                                <span>Trạng thái: ${order.status}</span>
                            </div>
                            <div class="order-body">
                                <div class="order-meta">
                                    <span>Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <span style="font-weight: bold; color: #dc3545;">
                                        Tổng tiền: <fmt:formatNumber value="${order.totalMoney}" type="number"/>đ
                                    </span>
                                </div>
                                <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>

                                <c:forEach items="${order.details}" var="item">
                                    <div class="order-item">
                                        <img src="${item.productImageUrl}" alt="${item.productName}">
                                        <div class="order-item-info">
                                            <span>${item.productName}</span>
                                            <span class="item-price">
                                                <fmt:formatNumber value="${item.priceAtPurchase}" type="number"/>đ x ${item.quantity}
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>

            </div>
        </div>
        <jsp:include page="footer.jsp"/>
    </body>
</html>