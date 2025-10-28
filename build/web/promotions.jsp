<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Khuyến mãi - ShopFashion</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .page-container { margin-top: 135px; background: #f9f9f9; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
        .breadcrumbs a { color: #333; }
        .page-title { text-align: center; font-size: 32px; font-weight: 700; margin-bottom: 40px; color: #dc3545; }
        /* Tái sử dụng grid layout từ home.jsp */
        .product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 30px; }
        /* (Copy các style .product-card, .product-image, .product-info... từ home.jsp nếu cần) */
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>

    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="home">Trang chủ</a> > Khuyến mãi
            </div>
            <h1 class="page-title">🔥 SẢN PHẨM KHUYẾN MÃI 🔥</h1>

            <div class="product-grid">
                 <c:if test="${empty saleProductList}">
                     <p style="grid-column: 1 / -1; text-align: center; padding: 30px;">Hiện chưa có sản phẩm nào đang giảm giá.</p>
                 </c:if>

                <c:forEach items="${saleProductList}" var="p">
                    <div class="product-card">
                        <div class="product-image">
                            <a href="detail?pid=${p.id}">
                                <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}"> <%-- Thêm context path cho ảnh --%>
                            </a>
                            <%-- Hiển thị % giảm giá --%>
                            <span class="product-discount">-<fmt:formatNumber value="${(p.originalPrice - p.salePrice) / p.originalPrice}" type="percent" maxFractionDigits="0"/></span>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><a href="detail?pid=${p.id}">${p.name}</a></h3>
                            <div class="product-price">
                                <span class="sale-price">
                                    <fmt:formatNumber value="${p.salePrice}" type="number" maxFractionDigits="0"/>đ
                                </span>
                                <%-- Luôn hiển thị giá gốc vì đây là trang sale --%>
                                <span class="original-price">
                                    <fmt:formatNumber value="${p.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                </span>
                            </div>
                            <a href="detail?pid=${p.id}" class="add-to-cart-btn" style="text-align: center;">Xem chi tiết</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>