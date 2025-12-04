<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%-- Sửa Title để tránh lỗi nếu productDetail null --%>
        <title>${not empty productDetail ? productDetail.name : 'Chi tiết sản phẩm'}</title>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>

        <style>
            .page-container .container {
                display: block;
            }
            .page-container {
                margin-top: 135px;
                background-color: #f9f9f9;
                padding: 40px 0;
            }
            .breadcrumbs {
                margin-bottom: 20px;
                color: #888;
            }
            .breadcrumbs a {
                color: #333;
            }
            .product-detail-wrapper {
                display: flex;
                gap: 40px;
                background-color: white;
                padding: 30px;
                border-radius: 8px;
            }
            .product-image-section {
                flex: 1;
            }
            .product-image-section img {
                width: 100%;
                border-radius: 8px;
            }
            .product-info-section {
                flex: 1.2;
            }
            .product-info-section .product-name {
                font-size: 23px;
                font-weight: 600;
                margin-bottom: 15px;
            }
            .product-info-section .price-section {
                margin-bottom: 20px;
            }
            /* SỬA LỖI GIÁ XUỐNG DÒNG: Dùng display: inline-block */
            .product-info-section .sale-price,
            .product-info-section .original-price {
                display: inline-block; /* Giữ giá và 'đ' trên cùng dòng */
                white-space: nowrap; /* Ngăn không cho tự động xuống dòng */
            }
            .product-info-section .sale-price {
                font-size: 32px;
                color: #dc3545;
                font-weight: bold;
            }
            .product-info-section .original-price {
                font-size: 18px;
                color: #888;
                text-decoration: line-through;
                margin-left: 15px;
            }
            .product-info-section .stock-status {
                font-size: 14px;
                color: #28a745;
                font-weight: bold;
                margin-left: 15px;
            }
            .size-selector {
                margin: 20px 0;
            }
            .size-selector h4 {
                font-size: 16px;
                margin-bottom: 10px;
            }
            .size-options button {
                width: 40px;
                height: 40px;
                margin-right: 10px;
                border: 1px solid #ccc;
                background: white;
                cursor: pointer;
                font-weight: bold;
            }
            .size-options button.active {
                border-color: #000;
                background: #000;
                color: white;
            }
            .quantity-selector {
                display: flex;
                align-items: center;
                margin: 25px 0;
            }
            .quantity-selector button {
                width: 35px;
                height: 35px;
                border: 1px solid #ccc;
                background-color: #fff;
                cursor: pointer;
                font-size: 20px;
            }
            .quantity-selector input {
                width: 50px;
                height: 35px;
                text-align: center;
                border: 1px solid #ccc;
                border-left: none;
                border-right: none;
                font-size: 16px;
            }
            .action-buttons button {
                width: 100%;
                padding: 15px;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                margin-bottom: 10px;
            }
            .btn-add-to-cart {
                background-color: #ffc107;
                color: #212529;
            }
            .btn-buy-now {
                background-color: #0056b3;
                color: white;
            }
            .social-share {
                margin-top: 25px;
            }
            .social-share a {
                margin-right: 10px;
                font-size: 20px;
                color: #555;
            }
            .product-promises {
                width: 280px;
                flex-shrink: 0;
            }
            .promise-item {
                margin-bottom: 20px;
            }
            .promise-item h4 {
                font-size: 16px;
                font-weight: bold;
            }
            .promise-item p {
                font-size: 14px;
                color: #666;
                line-height: 1.5;
            }
            .product-info-section .sold-quantity {
                font-size: 16px;
                color: #555;
                margin-left: 15px;
                border-left: 2px solid #eee;
                padding-left: 15px;
            }
            /* === CSS CHO SẢN PHẨM LIÊN QUAN === */
            .related-products-section {
                background-color: #fff;
                padding: 30px;
                margin-top: 30px;
                border-radius: 8px;
            }
            .related-products-section h2 {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 25px;
                text-align: center;
            }

            /* Tái sử dụng .product-list, giả sử nó đã có display: grid */
            /* Nếu chưa có, bạn có thể dùng CSS từ file style.css */
            .product-list {
                display: grid;
                grid-template-columns: repeat(4, 1fr); /* 4 sản phẩm trên 1 hàng */
                gap: 20px;
            }
            .product-item {
                text-align: center;
                border: 1px solid #eee;
                padding: 15px;
                border-radius: 5px;
                transition: box-shadow 0.3s ease;
            }
            .product-item:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }
            .product-item img {
                width: 100%;
                aspect-ratio: 1 / 1.2;
                object-fit: cover;
                margin-bottom: 10px;
            }
            .product-item .product-name {
                font-size: 16px;
                font-weight: 500;
                margin-bottom: 10px;
                color: #333;
                /* Cắt ngắn tên nếu quá dài (2 dòng) */
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
                height: 48px; /* (2 dòng x 24px line-height) */
            }
            .product-item .product-price .sale-price {
                font-size: 16px;
                font-weight: bold;
                color: #dc3545;
            }
            .product-item .product-price .original-price {
                font-size: 13px;
                color: #888;
                text-decoration: line-through;
                margin-left: 8px;
            }
            .discount-badge {
                background-color: #dc3545;
                color: white;
                font-size: 13px;
                font-weight: bold;
                padding: 3px 8px;
                border-radius: 4px;
                margin-left: 10px;
                vertical-align: text-bottom;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>

        <div class="page-container">
            <div class="container">
                <div class="breadcrumbs">
                    <a href="home">Trang chủ</a> > <a href="products">Cửa hàng</a> >
                    <%-- Kiểm tra trước khi hiển thị tên --%>
                    ${not empty productDetail ? productDetail.name : 'Sản phẩm không tồn tại'}
                </div>

                <%-- Kiểm tra nếu productDetail bị null --%>
                <c:if test="${empty productDetail}">
                    <div style="text-align: center; padding: 50px; background: white;">
                        <h2>Sản phẩm không tồn tại hoặc đã bị xóa.</h2>
                        <a href="products" class="btn-action">QUAY LẠI CỬA HÀNG</a>
                    </div>
                </c:if>

                <%-- Chỉ hiển thị nếu có productDetail --%>
                <c:if test="${not empty productDetail}">
                    <div class="product-detail-wrapper">
                        <div class="product-image-section">
                            <%-- Kiểm tra imageUrl --%>
                            <img src="${not empty productDetail.imageUrl ? productDetail.imageUrl : 'images/placeholder.jpg'}" alt="${productDetail.name}">
                            <%-- (Bạn cần tạo một ảnh placeholder.jpg trong thư mục images) --%>
                        </div>

                        <div class="product-info-section">
                            <h1 class="product-name">${productDetail.name}</h1>
                            <%-- >>> BANNER THÔNG BÁO (Nằm ngay trên tên SP hoặc giá) <<< --%>
                            <c:if test="${isSpecialDay}">
                                <div style="background-color: #ffeeba; color: #856404; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 14px; border: 1px solid #ffeeba;">
                                    <i class="fa-solid fa-gift"></i> <strong>HAPPY DAY: </strong> Giảm thêm ${sessionScope.cart.promotionPercent}%.
                                </div>
                            </c:if>

                            <div class="price-section">
                                <%-- Giá bán (Đã được giảm nếu là ngày KM) --%>
                                <span class="sale-price" style="color: #dc3545; font-size: 28px; font-weight: bold;">
                                    <fmt:formatNumber value="${productDetail.salePrice}" type="number" maxFractionDigits="0"/>đ
                                </span>

                                <%-- Nếu là ngày KM: Hiện giá gốc gạch ngang + Badge --%>
                                <c:if test="${isSpecialDay}">
                                    <span class="original-price" style="text-decoration: line-through; color: #888; font-size: 16px; margin-left: 10px;">
                                        <fmt:formatNumber value="${productDetail.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                    </span>
                                    
                                </c:if>

                                <%-- Nếu KHÔNG phải ngày KM nhưng vẫn có sale thường --%>
                                <c:if test="${!isSpecialDay && productDetail.originalPrice > productDetail.salePrice}">
                                    <span class="original-price" style="text-decoration: line-through; color: #888; font-size: 16px; margin-left: 10px;">
                                        <fmt:formatNumber value="${productDetail.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                    </span>
                                </c:if>

                                <span class="sold-quantity">Đã bán: ${productDetail.soldQuantity}</span>
                            </div>

                            <div class="size-selector">
                                <h4>Kích thước: <span id="selected-size-text"></span></h4>
                                <div class="size-options">
                                    <c:forEach items="${sizeList}" var="s">
                                        <%-- Thêm data-stock để lưu số lượng tồn --%>
                                        <button type="button" class="size-btn" data-size="${s.size}" data-stock="${s.stock}">
                                            ${s.size}
                                        </button>
                                    </c:forEach>
                                </div>
                                <%-- Dòng hiển thị trạng thái tồn kho --%>
                                <p id="stock-status-text" style="margin-top: 10px; font-weight: bold;"></p>
                            </div>

                            <form action="add-to-cart" method="POST">
                                <input type="hidden" name="pid" value="${productDetail.id}">
                                <%-- THÊM INPUT ẨN CHO SIZE --%>
                                <input type="hidden" name="size" id="selected-size-input" value="">

                                <div class="quantity-selector">
                                    <button type="button" onclick="handleQuantityChange(-1)">-</button>
                                    <input type="text" id="quantity-input" name="quantity" value="1" readonly>
                                    <button type="button" onclick="handleQuantityChange(1)">+</button>
                                </div>
                                <div class="action-buttons">
                                    <button type="submit" class="btn-add-to-cart" name="action" value="add_to_cart">THÊM VÀO GIỎ HÀNG</button>
                                    <button type="submit" class="btn-buy-now" name="action" value="buy_now">MUA NGAY</button>
                                </div>
                            </form>

                            <div class="social-share">
                                <a href="https://www.facebook.com/trannamkhanh011204" target="_blank">
                                    <i class="fab fa-facebook-f"></i>
                                </a>
                                <a href="#"><i class="fab fa-twitter"></i></a>
                                <a href="#"><i class="fab fa-pinterest"></i></a>
                                <a href="https://www.instagram.com/khanhtran655/" target="_blank">
                                    <i class="fab fa-instagram"></i>
                                </a>
                            </div>
                        </div>

                        <aside class="product-promises">
                            <div class="promise-item"><h4>Giao hàng trong 24h</h4><p>Đơn hàng trên 500.000đ</p></div>
                            <div class="promise-item"><h4>Ưu đãi khi mua hàng</h4><p>Giảm giá 50.000đ khi mua từ 3 sản phẩm</p></div>
                            <div class="promise-item"><h4>Bảo đảm chất lượng</h4><p>Sản phẩm bảo đảm chất lượng</p></div>
                            <div class="promise-item"><h4>Hỗ trợ 24/7</h4><p>Hotline: 0123456789</p></div>
                            <div class="promise-item"><h4>Sản phẩm chính hãng</h4><p>Sản phẩm nhập khẩu từ Trung Quốc</p></div>
                        </aside>
                    </div>
                </c:if>
            </div>
            <%-- === BẮT ĐẦU PHẦN SẢN PHẨM LIÊN QUAN === --%>
            <c:if test="${not empty relatedProducts}">
                <div class="container" style="margin-top: 30px;"> <%-- Thêm container mới --%>
                    <div class="related-products-section">
                        <h2>Có thể bạn cũng thích</h2>

                        <div class="product-list">
                            <%-- Lặp qua danh sách sản phẩm liên quan --%>
                            <c:forEach items="${relatedProducts}" var="p">
                                <div class="product-item">
                                    <a href="detail?pid=${p.id}">
                                        <img src="${p.imageUrl}" alt="${p.name}">
                                    </a>
                                    <h3 class="product-name">${p.name}</h3>
                                    <div class="product-price">
                                        <span class="sale-price"><fmt:formatNumber value="${p.salePrice}" type="number"/>đ</span>
                                        <c:if test="${p.originalPrice > p.salePrice}">
                                            <span class="original-price"><fmt:formatNumber value="${p.originalPrice}" type="number"/>đ</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                    </div>
                </div>
            </c:if>
            <%-- === KẾT THÚC PHẦN SẢN PHẨM LIÊN QUAN === --%>
        </div>

        <jsp:include page="footer.jsp"/>
        <script type="text/javascript">
            // Hàm xử lý nút +/- (giữ nguyên)
            function handleQuantityChange(change) {
                const quantityInput = document.getElementById('quantity-input');
                let currentValue = parseInt(quantityInput.value);
                let newValue = currentValue + change;
                if (newValue < 1) {
                    newValue = 1;
                }
                quantityInput.value = newValue;
            }

            // Cập nhật JavaScript chọn size
            document.addEventListener("DOMContentLoaded", function () {
                const sizeOptions = document.querySelector('.size-options');
                const sizeButtons = document.querySelectorAll('.size-btn');
                const selectedSizeText = document.getElementById('selected-size-text');
                const selectedSizeInput = document.getElementById('selected-size-input');
                const stockStatusText = document.getElementById('stock-status-text'); // Lấy thẻ p hiển thị tồn kho

                // Hàm cập nhật hiển thị tồn kho
                function updateStockStatus(stock) {
                    if (stock > 0) {
                        // HIỂN THỊ SỐ LƯỢNG CỤ THỂ
                        stockStatusText.textContent = "✓ Còn lại " + stock + " sản phẩm";
                        stockStatusText.style.color = "#28a745"; // Màu xanh
                        // Bật nút thêm vào giỏ hàng (nếu đang bị tắt)
                        document.querySelector('.btn-add-to-cart').disabled = false;
                    } else {
                        stockStatusText.textContent = "✕ Hết hàng";
                        stockStatusText.style.color = "#dc3545"; // Màu đỏ
                        // Tắt nút thêm vào giỏ hàng
                        document.querySelector('.btn-add-to-cart').disabled = true;
                    }
                }

                // Tự động chọn size đầu tiên và cập nhật trạng thái
                if (sizeButtons.length > 0) {
                    sizeButtons[0].click(); // Giả lập click
                    const initialStock = parseInt(sizeButtons[0].dataset.stock);
                    updateStockStatus(initialStock);
                } else {
                    // Trường hợp sản phẩm không có size nào
                    stockStatusText.textContent = "✕ Hết hàng";
                    stockStatusText.style.color = "#dc3545";
                    // Tắt nút thêm vào giỏ hàng
                    document.querySelector('.btn-add-to-cart').disabled = true;
                }

                // Xử lý khi bấm nút chọn size
                sizeOptions.addEventListener('click', function (e) {
                    if (e.target.tagName === 'BUTTON') {
                        sizeButtons.forEach(btn => btn.classList.remove('active'));
                        e.target.classList.add('active');

                        const selectedSize = e.target.dataset.size;
                        const selectedStock = parseInt(e.target.dataset.stock);

                        selectedSizeText.textContent = selectedSize;
                        selectedSizeInput.value = selectedSize;
                        updateStockStatus(selectedStock); // Cập nhật hiển thị tồn kho
                    }
                });
            });
        </script>
    </body>
</html>