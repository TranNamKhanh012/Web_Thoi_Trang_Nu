<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Giỏ hàng - ShopFashion</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .page-container { margin-top: 135px; background: #f9f9f9; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .cart-page-wrapper { display: flex; gap: 30px; }
        .cart-details { flex-grow: 1; }
        .cart-summary { width: 350px; flex-shrink: 0; }
        .cart-table { width: 100%; border-collapse: collapse; background: white; }
        .cart-table th, .cart-table td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; vertical-align: middle; }
        .cart-table th { font-size: 14px; text-transform: uppercase; color: #888; }
        .product-info-cell { display: flex; align-items: center; }
        .product-info-cell img { width: 80px; height: 80px; margin-right: 15px; }
        .product-info-cell span { font-size: 15px; }
        .remove-item-btn { color: #888; font-size: 20px; }
        .cart-actions { display: flex; justify-content: space-between; padding: 20px; background: white; border-top: 2px solid #ddd; }
        .btn-action { padding: 12px 25px; border: 1px solid #222; font-weight: bold; }
        .btn-update { background: #6c757d; color: white; border-color: #6c757d; cursor: pointer;}
        .cart-summary-box { background: white; padding: 20px; }
        .summary-title { font-size: 18px; font-weight: bold; margin-bottom: 20px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 15px; }
        .summary-total { font-weight: bold; color: #dc3545; }
        .btn-checkout { display: block; width: 100%; background: #ffc107; color: #212529; padding: 15px; text-align: center; font-weight: bold; border-radius: 5px; margin-top: 20px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="page-container">
        <div class="container">
            <c:choose>
                <c:when test="${empty sessionScope.cart || sessionScope.cart.totalQuantity == 0}">
                    <div style="text-align: center; padding: 50px; background: white;">
                        <h2 style="margin-bottom: 20px;">Giỏ hàng của bạn đang trống!</h2>
                        <a href="products" class="btn-action">TIẾP TỤC MUA SẮM</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cart-page-wrapper">
                        <div class="cart-details">
                            <form action="cart" method="POST">
                                <table class="cart-table">
                                    <thead>
                                        <tr>
                                            <th colspan="2">Sản phẩm</th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th>Tạm tính</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${sessionScope.cart.items.values()}" var="item">
                                            <tr>
                                                <input type="hidden" name="productId" value="${item.product.id}">
                                                <%-- GỬI CẢ SIZE KHI CẬP NHẬT --%>
                                                <input type="hidden" name="size" value="${item.size}">

                                                <%-- LINK XÓA PHẢI GỬI CẢ SIZE --%>
                                                <td><a href="cart?action=remove&pid=${item.product.id}&size=${item.size}" class="remove-item-btn" title="Xóa sản phẩm">&times;</a></td>
                                                <td>
                                                    <div class="product-info-cell">
                                                        <img src="${item.product.imageUrl}" alt="${item.product.name}">
                                                        <div>
                                                            <span>${item.product.name}</span>
                                                            <%-- HIỂN THỊ SIZE ĐÃ CHỌN --%>
                                                            <span style="display: block; font-size: 13px; color: #888;">Size: ${item.size}</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><fmt:formatNumber value="${item.product.salePrice}" type="number"/>đ</td>
                                                <td>
                                                    <div class="quantity-selector">
                                                        <input type="number" name="quantity" value="${item.quantity}" min="1" style="width: 60px; text-align: center; padding: 5px; border: 1px solid #ccc;">
                                                    </div>
                                                </td>
                                                <td style="color: #dc3545; font-weight: bold;"><fmt:formatNumber value="${item.totalPrice}" type="number"/>đ</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="cart-actions">
                                    <a href="products" class="btn-action">← TIẾP TỤC XEM SẢN PHẨM</a>
                                    <button type="submit" class="btn-action btn-update">CẬP NHẬT GIỎ HÀNG</button>
                                </div>
                            </form>
                        </div>
                        
                        <div class="cart-summary">
                            <div class="cart-summary-box">
                                <h3 class="summary-title">TỔNG CỘNG GIỎ HÀNG</h3>
                                <div class="summary-row">
                                    <span>Tạm tính</span>
                                    <span class="summary-total"><fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number"/>đ</span>
                                </div>
                                <div class="summary-row">
                                    <span>Tổng</span>
                                    <span class="summary-total"><fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number"/>đ</span>
                                </div>
                                <a href="checkout" class="btn-checkout">TIẾN HÀNH THANH TOÁN</a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="footer.jsp"/>
</body>
</html>