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
        
        /* CSS MỚI CHO TAG GIẢM GIÁ */
        .discount-badge {
            background-color: #dc3545;
            color: white;
            font-size: 11px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 4px;
            margin-left: 5px;
            vertical-align: middle;
        }
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
                            <%-- >>> BANNER THÔNG BÁO GIẢM GIÁ CUỐI TUẦN <<< --%>
                            <c:if test="${sessionScope.cart.promotionActive}">
                                <div style="background-color: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #c3e6cb; display: flex; align-items: center;">
                                    <i class="fa-solid fa-gift" style="font-size: 24px; margin-right: 15px;"></i>
                                    <div>
                                        <strong>HAPPY DAY!</strong><br>
                                        Đơn hàng của bạn đang được <b>GIẢM THÊM ${sessionScope.cart.promotionPercent}%</b> (Đã áp dụng vào giá sản phẩm). Chúc bạn cuối tuần vui vẻ!
                                    </div>
                                </div>
                            </c:if>
                            
                            <form action="cart" method="POST">
                                <table class="cart-table">
                                    <thead>
                                        <tr>
                                            <th colspan="2">Sản phẩm</th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th>Thành tiền</th>
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
                                                
                                                <%-- CỘT GIÁ (ĐÃ CẬP NHẬT HIỂN THỊ GIẢM GIÁ) --%>
                                                <td class="product-price">
                                                    <%-- Nếu là cuối tuần, hiển thị giá gốc và tag giảm giá --%>
                                                    <c:if test="${sessionScope.cart.promotionActive}">
                                                        <div style="margin-bottom: 4px;">
                                                            <span style="text-decoration: line-through; color: #999; font-size: 13px;">
                                                                <fmt:formatNumber value="${item.product.salePrice}" type="number"/>đ
                                                            </span>
                                                            <span class="discount-badge">-10%</span>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <%-- Giá thực tế (đã giảm hoặc giữ nguyên) --%>
                                                    <span style="color: #dc3545; font-weight: bold; font-size: 16px;">
                                                        <fmt:formatNumber value="${item.effectivePrice}" type="number"/>đ
                                                    </span>
                                                </td>

                                                <td>
                                                    <div class="quantity-selector">
                                                        <input type="number" name="quantity" value="${item.quantity}" min="1" style="width: 60px; text-align: center; padding: 5px; border: 1px solid #ccc;">
                                                    </div>
                                                </td>
                                                
                                                <%-- THÀNH TIỀN (Giá thực tế x Số lượng) --%>
                                                <td style="color: #dc3545; font-weight: bold;">
                                                    <fmt:formatNumber value="${item.totalPrice}" type="number"/>đ
                                                </td>
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
                        
                        <%-- PHẦN TỔNG KẾT HÓA ĐƠN --%>
                        <div class="cart-summary">
                            <div class="cart-summary-box">
                                <h3 class="summary-title">TỔNG CỘNG GIỎ HÀNG</h3>
                                
                                <%-- Hiển thị thông tin giảm giá --%>
                                <c:if test="${sessionScope.cart.promotionActive}">
                                    <div class="summary-row" style="color: #28a745; font-size: 13px; font-style: italic;">
                                        <span>*Đã áp dụng ưu đãi cuối tuần</span>
                                    </div>
                                </c:if>

                                <div class="summary-row">
                                    <span>Tạm tính</span>
                                    <%-- totalMoney trong Cart đã được tính dựa trên giá sau giảm --%>
                                    <span class="summary-total"><fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number"/>đ</span>
                                </div>
                                
                                <div class="summary-row" style="border-top: 1px solid #eee; padding-top: 15px; margin-top: 10px;">
                                    <span style="font-size: 16px; font-weight: bold;">Tổng thanh toán</span>
                                    <span class="summary-total" style="font-size: 18px;">
                                        <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number"/>đ
                                    </span>
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