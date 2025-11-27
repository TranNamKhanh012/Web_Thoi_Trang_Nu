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
            .page-container {
                margin-top: 135px;
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
                color: #dc3545;
            }
            /* Tái sử dụng grid layout từ home.jsp */
            .product-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 30px;
            }
            /* (Copy các style .product-card, .product-image, .product-info... từ home.jsp nếu cần) */
            /* --- Thanh Lọc/Sắp xếp (Thiết kế lại) --- */
            .filter-sort-bar {
                display: flex;

                align-items: center;
                background: #fff;
                padding: 15px 25px; /* Tăng padding */
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08); /* Thêm bóng mờ rõ hơn */
                margin-bottom: 30px;
                flex-wrap: wrap; /* Xuống dòng nếu không đủ chỗ */
                gap: 20px;
            }

            /* Nhóm bên trái (Lọc giá) */
            .filter-group {
                display: flex;
                align-items: center;
                gap: 15px; /* Khoảng cách giữa "Chọn mức giá" và các checkbox */
                flex-wrap: wrap;
            }
            .filter-group h4 { /* Tiêu đề "Chọn mức giá" */
                font-size: 14px;
                font-weight: bold;
                margin: 0;
                white-space: nowrap;
                color: #333;
            }
            .filter-options { /* Chứa các checkbox */
                display: flex;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
            }
            .filter-options label {
                margin: 0;
                font-size: 14px;
                color: #555;
                cursor: pointer;
                white-space: nowrap;
            }
            .filter-options input[type="checkbox"] {
                margin-right: 5px;
                vertical-align: middle;
            }

            /* Nhóm bên phải (Sắp xếp + Nút) */
            .sort-apply-group {
                display: flex;
                align-items: center;
                gap: 15px; /* Khoảng cách giữa dropdown và nút */
            }
            .sort-group {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .sort-group label {
                font-size: 14px;
                font-weight: bold;
                margin: 0;
                white-space: nowrap;
                color: #333;
            }
            /* Style lại dropdown */
            .sort-group select,
            #category-select {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
                background-color: #fff;
                font-size: 14px;
            }
            /* Style lại nút */
            .btn-apply-filter {
                padding: 9px 20px; /* Chỉnh lại padding cho cao bằng dropdown */
                background: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                font-size: 14px;
                /* Bỏ margin-left: auto */
            }
            /* --- CSS Phân trang (Sao chép từ products.jsp) --- */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                list-style: none;
                padding: 0;
                margin-top: 40px;
            }
            .pagination li {
                margin: 0 5px;
            }
            .pagination li a {
                display: block;
                padding: 8px 14px;
                text-decoration: none;
                color: #007bff;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                transition: all 0.2s;
            }
            .pagination li a:hover {
                background-color: #f4f4f4;
            }
            .pagination li.active a {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }
            .pagination li.disabled a {
                color: #aaa;
                pointer-events: none;
                border-color: #eee;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>

        <div class="page-container">
            <div class="container">
                <div class="breadcrumbs">
                    <a href="home">Trang chủ</a> > Khuyến mãi
                </div>
                <%-- >>> THÊM THANH LỌC/SẮP XẾP <<< --%>
                <form action="promotions" method="GET" class="filter-sort-bar">
                    <div class="filter-group">
                        <h4>Chọn mức giá:</h4>
                        <div class="filter-options">
                            <label><input type="checkbox" name="priceRange" value="0-200000" ${selectedPriceRanges.contains('0-200000') ? 'checked' : ''}> Dưới 200.000đ</label>
                            <label><input type="checkbox" name="priceRange" value="200000-400000" ${selectedPriceRanges.contains('200000-400000') ? 'checked' : ''}> 200.000đ - 400.000đ</label>
                            <label><input type="checkbox" name="priceRange" value="400000-600000" ${selectedPriceRanges.contains('400000-600000') ? 'checked' : ''}> 400.000đ - 600.000đ</label>
                            <label><input type="checkbox" name="priceRange" value="600000-800000" ${selectedPriceRanges.contains('600000-800000') ? 'checked' : ''}> 600.000đ - 800.000đ</label>
                            <label><input type="checkbox" name="priceRange" value="800000-100000000" ${selectedPriceRanges.contains('800000-100000000') ? 'checked' : ''}> 800.000đ - 1.000.000đ</label>
                            <label><input type="checkbox" name="priceRange" value="1000000-150000000" ${selectedPriceRanges.contains('1000000-150000000') ? 'checked' : ''}> Trên 1.000.000đ</label>
                        </div>
                    </div>
                        
                    <div class="sort-apply-group">
                        <div class="sort-group">
                            <label for="sort-select">Sắp xếp theo:</label>
                            <select id="sort-select" name="sort" onchange="this.form.submit()">
                                <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                <option value="oldest" ${selectedSort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Giá: Tăng dần</option>
                                <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Giá: Giảm dần</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="category-select" style="font-weight: bold; font-size: 14px; color: #333;">Danh mục:</label>
                            <select id="category-select" name="cid" onchange="this.form.submit()">
                                <option value="0" ${activeCid == 0 ? 'selected' : ''}>Tất cả sản phẩm</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat.id}" ${cat.id == activeCid ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn-apply-filter">Áp dụng</button>
                    </div>
                </form>
                <%-- <<< KẾT THÚC THANH LỌC/SẮP XẾP >>> --%>
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
                <%-- >>> THÊM PHẦN PHÂN TRANG <<< --%>
                <ul class="pagination">
                    <%-- Nút Lùi --%>
                    <li class="${currentPage == 1 ? 'disabled' : ''}">
                        <c:url var="prevUrl" value="promotions">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:forEach var="range" items="${selectedPriceRanges}"><c:param name="priceRange" value="${range}"/></c:forEach>
                            <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                        </c:url>
                        <a href="${prevUrl}">&laquo;</a>
                    </li>
                    <%-- Nút số --%>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="${currentPage == i ? 'active' : ''}">
                            <c:url var="pageUrl" value="promotions">
                                <c:param name="page" value="${i}"/>
                                <c:forEach var="range" items="${selectedPriceRanges}"><c:param name="priceRange" value="${range}"/></c:forEach>
                                <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                            </c:url>
                            <a href="${pageUrl}">${i}</a>
                        </li>
                    </c:forEach>
                    <%-- Nút Tới --%>
                    <li class="${currentPage == totalPages ? 'disabled' : ''}">
                        <c:url var="nextUrl" value="promotions">
                            <c:param name="page" value="${currentPage + 1}"/>
                            <c:forEach var="range" items="${selectedPriceRanges}"><c:param name="priceRange" value="${range}"/></c:forEach>
                            <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                        </c:url>
                        <a href="${nextUrl}">&raquo;</a>
                    </li>
                </ul>
                <%-- <<< KẾT THÚC PHÂN TRANG >>> --%>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>
    </body>
</html>