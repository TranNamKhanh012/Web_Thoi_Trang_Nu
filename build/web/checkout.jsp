<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thanh toán - ShopFashion</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .page-container { margin-top: 135px; background: #f9f9f9; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .checkout-wrapper { display: flex; gap: 30px; }
        .billing-details { flex-grow: 1; background: white; padding: 20px; }
        .order-summary { width: 400px; flex-shrink: 0; background: white; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; }
        .btn-place-order { width: 100%; padding: 15px; background: #007bff; color: white; border: none; font-size: 16px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="page-container">
        <div class="container">
            <c:if test="${empty sessionScope.cart || sessionScope.cart.totalQuantity == 0}">
                <div style="text-align: center; padding: 50px; background: white;"><h2>Không có sản phẩm nào để thanh toán!</h2></div>
            </c:if>
            <c:if test="${not empty sessionScope.cart && sessionScope.cart.totalQuantity > 0}">
                <form action="checkout" method="POST">
                    <div class="checkout-wrapper">
                        <div class="billing-details">
                            <h3>Thông tin giao hàng</h3>
                            <div class="form-group">
                                <label>Họ và Tên</label>
                                <input type="text" value="${sessionScope.acc.fullname}" readonly>
                            </div>
                            <div class="form-group">
                                <label for="address">Địa chỉ *</label>
                                <input type="text" id="address" name="address" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">Số điện thoại *</label>
                                <input type="text" id="phone" name="phone" required>
                            </div>
                        </div>

                        <div class="order-summary">
                            <h3>Đơn hàng của bạn</h3>
                            <table style="width: 100%;">
                                <c:forEach items="${sessionScope.cart.items.values()}" var="item">
                                    <tr>
                                        <td>${item.product.name} x ${item.quantity}</td>
                                        <td style="text-align: right;"><fmt:formatNumber value="${item.totalPrice}" type="number"/>đ</td>
                                    </tr>
                                </c:forEach>
                                <tr style="font-weight: bold; border-top: 1px solid #eee; padding-top: 10px;">
                                    <td>Tổng cộng</td>
                                    <td style="text-align: right; color: #dc3545;"><fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number"/>đ</td>
                                </tr>
                            </table>
                            <button type="submit" class="btn-place-order" style="margin-top: 20px;">ĐẶT HÀNG</button>
                        </div>
                    </div>
                </form>
            </c:if>
        </div>
    </div>
    <jsp:include page="footer.jsp"/>
</body>
</html>