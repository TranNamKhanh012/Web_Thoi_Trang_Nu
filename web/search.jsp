<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Kết quả tìm kiếm cho "${searchKeyword}"</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    
    <style>
        .page-container { margin-top: 135px; background: #f9f9f9; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
        .breadcrumbs a { color: #333; }
        .search-result-title { font-size: 18px; font-weight: bold; margin-bottom: 30px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    
    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="home">Trang chủ</a> > Kết quả tìm kiếm
            </div>
            
            <h3 class="search-result-title">
                Có ${productList.size()} kết quả tìm kiếm phù hợp cho "${searchKeyword}"
            </h3>
            
            <%-- Tái sử dụng grid layout từ trang chủ/sản phẩm --%>
            <div class="product-grid">
                <c:forEach items="${productList}" var="p">
                    <div class="product-card">
                        <div class="product-image">
                            <a href="detail?pid=${p.id}">
                                <img src="${p.imageUrl}" alt="${p.name}">
                            </a>
                            <c:if test="${p.salePrice > 0 && p.salePrice < p.originalPrice}">
                                <span class="product-discount">-<fmt:formatNumber value="${(p.originalPrice - p.salePrice) / p.originalPrice}" type="percent" maxFractionDigits="0"/></span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><a href="detail?pid=${p.id}">${p.name}</a></h3>
                            <div class="product-price">
                                <span class="sale-price">
                                    <fmt:formatNumber value="${p.salePrice > 0 ? p.salePrice : p.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                </span>
                                <c:if test="${p.salePrice > 0 && p.salePrice < p.originalPrice}">
                                    <span class="original-price">
                                        <fmt:formatNumber value="${p.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                    </span>
                                </c:if>
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