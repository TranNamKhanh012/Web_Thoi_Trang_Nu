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
    main {
    background-color: #fff;
    }
    .page-container {
        margin-top: 135px;
        padding: 40px 0 80px 0;
    }
    /* Đảm bảo container xếp dọc */
    .page-container .container { display: block; }

    /* --- Breadcrumbs --- */
    .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
    .breadcrumbs a { color: #333; }

    /* --- Thanh lọc Danh mục (HIỆN LẠI) --- */
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
    /* --- Breadcrumbs (Keep these) --- */
    .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
    .breadcrumbs a { color: #333; }

    /* --- Product Grid & Card Styles (Keep these or use from style.css) --- */
    .product-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; }
    .product-card { background: #fff; border: 1px solid #dee2e6; border-radius: 8px; overflow: hidden; transition: transform 0.3s ease, box-shadow 0.3s ease; display: flex; flex-direction: column; }
    .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
    .product-image { position: relative; overflow: hidden; }
    .product-image img { width: 100%; display: block; transition: transform 0.4s ease;  object-fit: cover;}
    .product-card:hover .product-image img { transform: scale(1.05); }
    .product-discount { position: absolute; top: 10px; right: 10px; background-color: #dc3545; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
    .product-info { padding: 15px; text-align: left; display: flex; flex-direction: column; flex-grow: 1; }
    .product-name { font-size: 15px; font-weight: 600; color: #333; height: 40px; overflow: hidden; margin-bottom: 8px; }
    .product-name a { color: inherit; text-decoration: none; }
    .product-name a:hover { color: #007bff; }
    .product-price { margin-bottom: 12px; margin-top: auto; }
    .sale-price { font-size: 18px; font-weight: 700; color: #dc3545; margin-right: 8px; display: inline-block; white-space: nowrap; }
    .original-price { font-size: 14px; color: #888; text-decoration: line-through; display: inline-block; white-space: nowrap;}
    .add-to-cart-btn { display: block; width: 100%; padding: 10px; background-color: #007bff; color: #fff; border: none; border-radius: 4px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background-color 0.3s ease; text-decoration: none; text-align: center;}
    .add-to-cart-btn:hover { background-color: #0056b3; }

    /* Hide old filter bars if they exist */
    .category-filter-bar, .filter-bar { display: none; }
    /* Sửa lại CSS này nếu bạn muốn chữ "Danh mục" có style đồng bộ */
.sort-group label,
.filter-group > label { /* Thêm selector này */
    font-size: 14px;
    font-weight: bold;
    margin: 0;
    white-space: nowrap;
    color: #333;
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
                        <c:forEach items="${categoryList}" var="cat">
                            <c:if test="${cat.id == activeCid}"> > ${cat.name} </c:if>
                        </c:forEach>
                    </div>

                    <%-- THANH LỌC DANH MỤC (HIỆN LẠI) --%>
                    <div class="category-filter-bar">
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

                    <%-- Thay thế thẻ <form> cũ bằng code này --%>
                    <form action="products" method="GET" class="filter-sort-bar">

                        <div class="filter-group">
                            <h4>Chọn mức giá:</h4>
                            <div class="filter-options">
                                 <label><input type="checkbox" name="priceRange" value="0-200000" ${selectedPriceRanges.contains('0-200000') ? 'checked' : ''}> Dưới 200.000đ</label>
                                 <label><input type="checkbox" name="priceRange" value="200000-400000" ${selectedPriceRanges.contains('200000-400000') ? 'checked' : ''}> 200k - 400k</label>
                                 <label><input type="checkbox" name="priceRange" value="400000-600000" ${selectedPriceRanges.contains('400000-600000') ? 'checked' : ''}> 400k - 600k</label>
                                 <label><input type="checkbox" name="priceRange" value="600000-800000" ${selectedPriceRanges.contains('600000-800000') ? 'checked' : ''}> 600k - 800k</label>
                                 <label><input type="checkbox" name="priceRange" value="800000-100000000" ${selectedPriceRanges.contains('800000-100000000') ? 'checked' : ''}> Trên 800.000đ</label>
                            </div>
                        </div>
                        <button type="submit" class="btn-apply-filter">Áp dụng</button>    
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
                            <select id="category-select" name="cid" onchange="this.form.submit()"> <%-- Đặt tên là "cid" và tự động gửi khi thay đổi --%>
                                <option value="0" ${activeCid == 0 ? 'selected' : ''}>Tất cả sản phẩm</option>
                                <c:forEach items="${categoryList}" var="cat">
                                    <option value="${cat.id}" ${cat.id == activeCid ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                     
                        </div>
                    </form>
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