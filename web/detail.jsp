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
        .page-container .container { display: block; }
        .page-container { margin-top: 135px; background-color: #f9f9f9; padding: 40px 0; }
        .breadcrumbs { margin-bottom: 20px; color: #888; }
        .breadcrumbs a { color: #333; }
        .product-detail-wrapper { display: flex; gap: 40px; background-color: white; padding: 30px; border-radius: 8px; }
        .product-image-section { flex: 1; }
        .product-image-section img { width: 100%; border-radius: 8px; }
        .product-info-section { flex: 1.2; }
        .product-info-section .product-name { font-size: 23px; font-weight: 600; margin-bottom: 15px; }
        .product-info-section .price-section { margin-bottom: 20px; }
        /* SỬA LỖI GIÁ XUỐNG DÒNG: Dùng display: inline-block */
        .product-info-section .sale-price,
        .product-info-section .original-price {
             display: inline-block; /* Giữ giá và 'đ' trên cùng dòng */
             white-space: nowrap; /* Ngăn không cho tự động xuống dòng */
        }
        .product-info-section .sale-price { font-size: 32px; color: #dc3545; font-weight: bold; }
        .product-info-section .original-price { font-size: 18px; color: #888; text-decoration: line-through; margin-left: 15px; }
        .product-info-section .stock-status { font-size: 14px; color: #28a745; font-weight: bold; margin-left: 15px; }
        .size-selector { margin: 20px 0; }
        .size-selector h4 { font-size: 16px; margin-bottom: 10px; }
        .size-options button { width: 40px; height: 40px; margin-right: 10px; border: 1px solid #ccc; background: white; cursor: pointer; font-weight: bold; }
        .size-options button.active { border-color: #000; background: #000; color: white; }
        .quantity-selector { display: flex; align-items: center; margin: 25px 0; }
        .quantity-selector button { width: 35px; height: 35px; border: 1px solid #ccc; background-color: #fff; cursor: pointer; font-size: 20px; }
        .quantity-selector input { width: 50px; height: 35px; text-align: center; border: 1px solid #ccc; border-left: none; border-right: none; font-size: 16px; }
        .action-buttons button { width: 100%; padding: 15px; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer; margin-bottom: 10px; }
        .btn-add-to-cart { background-color: #ffc107; color: #212529; }
        .btn-buy-now { background-color: #0056b3; color: white; }
        .social-share { margin-top: 25px; }
        .social-share a { margin-right: 10px; font-size: 20px; color: #555; }
        .product-promises { width: 280px; flex-shrink: 0; }
        .promise-item { margin-bottom: 20px; }
        .promise-item h4 { font-size: 16px; font-weight: bold; }
        .promise-item p { font-size: 14px; color: #666; line-height: 1.5; }
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
                        <div class="price-section">
                            <%-- Hiển thị giá --%>
                            <span class="sale-price"><fmt:formatNumber value="${productDetail.salePrice}" type="number" maxFractionDigits="0"/>đ</span>
                            <span class="original-price"><fmt:formatNumber value="${productDetail.originalPrice}" type="number" maxFractionDigits="0"/>đ</span>
                            <%-- Bỏ stockQuantity vì đã chuyển sang product_sizes --%>
                            <%--<span class="stock-status">Còn hàng</span> --%>
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
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-pinterest"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                        </div>
                    </div>

                    <aside class="product-promises">
                        <div class="promise-item"><h4>Giao hàng trong 24h</h4><p>Đơn hàng trên 500.000đ</p></div>
                        <div class="promise-item"><h4>Bảo đảm chất lượng</h4><p>Sản phẩm bảo đảm chất lượng</p></div>
                        <div class="promise-item"><h4>Hỗ trợ 24/7</h4><p>Hotline: 0123456789</p></div>
                        <div class="promise-item"><h4>Sản phẩm chính hãng</h4><p>Sản phẩm nhập khẩu chính hãng</p></div>
                    </aside>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="footer.jsp"/>
    <script type="text/javascript">
        // Hàm xử lý nút +/- (giữ nguyên)
        function handleQuantityChange(change) {
            const quantityInput = document.getElementById('quantity-input');
            let currentValue = parseInt(quantityInput.value);
            let newValue = currentValue + change;
            if (newValue < 1) { newValue = 1; }
            quantityInput.value = newValue;
        }

        // Cập nhật JavaScript chọn size
        document.addEventListener("DOMContentLoaded", function() {
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
            sizeOptions.addEventListener('click', function(e) {
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