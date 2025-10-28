<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cửa hàng</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    
    <%-- Thêm CSS MỚI cho layout trang này --%>
    <style>
        .page-container {
            margin-top: 145px;
            padding: 20px 0;
        }
        /* Bỏ layout flex 2 cột */
        .shop-wrapper {
            display: block; 
        }
        .breadcrumbs {
            margin-bottom: 25px; /* Tăng margin */
            color: #888;
            font-size: 14px; /* Thêm font-size */
        }
        .breadcrumbs a {
            color: #333;
        }

        /* === CSS CHO THANH LỌC DANH MỤC MỚI === */
        .category-filter-bar {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px 25px;
            margin-bottom: 40px;
        }
        .category-filter-bar .sidebar-title {
            display: none; /* Ẩn tiêu đề "DANH MỤC SẢN PHẨM" đi cho gọn */
        }
        .category-filter-bar .category-list {
            display: flex; /* Dàn các mục thành hàng ngang */
            justify-content: center; /* Căn giữa */
            align-items: center;
            gap: 15px; /* Khoảng cách giữa các mục */
            flex-wrap: wrap; /* Tự động xuống dòng nếu không đủ chỗ */
        }
        .category-filter-bar .category-list li {
            margin-bottom: 0;
        }
        .category-filter-bar .category-list a {
            color: #333;
            font-weight: 500;
            padding: 8px 18px;
            border-radius: 20px; /* Bo tròn thành hình viên thuốc */
            border: 1px solid transparent;
            transition: all 0.3s ease;
        }
        .category-filter-bar .category-list a:hover {
            border-color: #ccc;
            color: #007bff;
        }
        /* Style cho mục đang được chọn (active) */
        .category-filter-bar .category-list a.active {
            background-color: #007bff;
            color: white;
            font-weight: bold;
            border-color: #007bff;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>

    <div class="page-container">
        <div class="container shop-wrapper">

            <%-- NỘI DUNG CHÍNH --%>
            <main class="product-content">
                <div class="breadcrumbs">
                    <a href="home">Trang chủ</a> > Cửa hàng
                </div>
                
                <%-- THANH LỌC DANH MỤC (ĐÃ ĐƯỢC DI CHUYỂN LÊN ĐÂY) --%>
                <div class="category-filter-bar">
                    <h3 class="sidebar-title">DANH MỤC SẢN PHẨM</h3>
                    <ul class="category-list">
                        <li>
                            <a href="products" class="${activeCid == 0 ? 'active' : ''}">Tất cả sản phẩm</a>
                        </li>
                        <c:forEach items="${categoryList}" var="c">
                            <li>
                                <a href="products?cid=${c.id}" class="${activeCid == c.id ? 'active' : ''}">${c.name}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                
                <%-- Grid hiển thị sản phẩm --%>
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
            </main>
        </div>
    </div>

    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>