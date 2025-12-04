<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp"></jsp:include>

<%-- THÊM CSS CHO SLIDER TẠI ĐÂY --%>
<style>
    /* --- Banner Slider --- */
    .banner {
        /* Dùng CSS cũ của bạn, nhưng đảm bảo nó hoạt động như container */
        margin-top: 135px; /* Giả sử chiều cao header của bạn là 135px */
        width: 100%;
        position: relative;
        overflow: hidden; /* Ẩn các slide khác */
        height: 500px; /* Đặt chiều cao cho banner, bạn có thể thay đổi */
        background-color: #f0f0f0; /* Màu nền chờ trong khi tải ảnh */
    }

    .slider-inner {
        height: 100%;
        display: flex; /* Sắp xếp các slide theo hàng ngang */
        /* transition: transform 0.7s ease-in-out; Hiệu ứng trượt */
    }

    .slide {
        min-width: 100%;
        height: 100%;
        display: none; /* Ẩn tất cả slide ban đầu */
        animation: fadeEffect 1.5s; /* Hiệu ứng mờ/hiện */
    }

    .slide.active {
        display: block; /* Chỉ hiện slide active */
    }

    @keyframes fadeEffect {
        from {
            opacity: .4
        }
        to {
            opacity: 1
        }
    }

    .slide img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* Cắt ảnh vừa vặn với khung, không bị méo */
    }

    /* Nút điều hướng */
    .prev, .next {
        cursor: pointer;
        position: absolute;
        top: 50%;
        width: auto;
        padding: 16px;
        margin-top: -22px;
        color: white;
        font-weight: bold;
        font-size: 24px;
        transition: 0.3s ease;
        border-radius: 0 3px 3px 0;
        user-select: none;
        background-color: rgba(0,0,0,0.4);
        border: none;
        z-index: 10;
    }
    .next {
        right: 0;
        border-radius: 3px 0 0 3px;
    }
    .prev:hover, .next:hover {
        background-color: rgba(0,0,0,0.7);
    }

    /* Dấu chấm */
    .dots-container {
        text-align: center;
        position: absolute;
        bottom: 20px;
        width: 100%;
        z-index: 10;
    }
    .dot {
        cursor: pointer;
        height: 12px;
        width: 12px;
        margin: 0 5px;
        background-color: rgba(255, 255, 255, 0.5);
        border-radius: 50%;
        display: inline-block;
        transition: background-color 0.3s ease;
    }
    .dot.active, .dot:hover {
        background-color: #ffffff;
    }
    /* CSS Tag Giảm giá mới */
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

<%-- SỬA LẠI SECTION BANNER --%>
<section class="banner">
    <div class="slider-inner">
        <%-- Slide 1 --%>
        <div class="slide active">
            <%-- Thay bằng link ảnh của bạn --%>
            <img src="images/banner7.jpg" alt="Banner 1"> 
        </div>
        <%-- Slide 2 --%>
        <div class="slide">
            <%-- Thay bằng link ảnh của bạn --%>
            <img src="images/banner8.jpg" alt="Banner 2"> 
        </div>
        <%-- Slide 3 --%>
        <div class="slide">
            <%-- Thay bằng link ảnh của bạn --%>
            <img src="images/banner9.jpg" alt="Banner 3">
        </div>
    </div>
    <%-- Nút điều hướng --%>
    <button class="prev" onclick="moveSlide(-1)">&#10094;</button>
    <button class="next" onclick="moveSlide(1)">&#10095;</button>
    <%-- Dấu chấm --%>
    <div class="dots-container">
        <span class="dot active" onclick="currentSlide(1)"></span>
        <span class="dot" onclick="currentSlide(2)"></span>
        <span class="dot" onclick="currentSlide(3)"></span>
    </div>
</section>

<main>
    <div class="container">
        <%-- >>> CHÈN BANNER VÀO ĐÂY <<< --%>
        <c:if test="${isSpecialDay}">
            <div style="background-color: #ffeeba; color: #856404; padding: 20px; margin-bottom: 30px; border-radius: 8px; text-align: center; border: 1px solid #ffeeba; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                <h3 style="margin: 0; font-size: 24px; text-transform: uppercase;">🎉 Happy Day! 🎉</h3>
                <p style="margin: 5px 0 0 0; font-size: 16px;">
                    Duy nhất hôm nay: <strong>GIẢM THÊM ${sessionScope.cart.promotionPercent}%</strong> cho toàn bộ sản phẩm.
                </p>
            </div>
        </c:if>
        <%-- >>> KẾT THÚC BANNER <<< --%>
        <%-- 1. Khối Chính sách & Cam kết (GIỮ NGUYÊN) --%>
        <section class="policy-bar">
            <div class="policy-item">
                <img src="images/icon_vanchuyen.jpg" alt="Van chuyen icon">
                <div>
                    <h4>Vận chuyển MIỄN PHÍ</h4>
                    <p>Trong khu vực. Hà Nội</p>
                </div>
            </div>
            <div class="policy-item">
                <img src="images/icon_doitra.jpg" alt="Doi tra icon">
                <div>
                    <h4>Đổi trả MIỄN PHÍ</h4>
                    <p>Trong vòng 30 NGÀY</p>
                </div>
            </div>
            <div class="policy-item">
                <img src="images/icon_thanhtoan.jpg" alt="Thanh toan icon">
                <div>
                    <h4>Tiến hành THANH TOÁN</h4>
                    <p>Với nhiều PHƯƠNG THỨC</p>
                </div>
            </div>
            <div class="policy-item">
                <img src="images/icon_hoantien.jpg" alt="Hoan tien icon">
                <div>
                    <h4>100% HOÀN TIỀN</h4>
                    <p>Nếu sản phẩm lỗi</p>
                </div>
            </div>
        </section>
        <%-- 2. Khối Top Bán Chạy (GIỮ NGUYÊN) --%>
        <section class="product-showcase">
            <h2 class="section-title">Top Bán Chạy</h2>
            <div class="product-grid">
                <c:forEach items="${topSellingProducts}" var="p">
                    <div class="product-card">
                        <div class="product-image">
                            <a href="detail?pid=${p.id}">
                                <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}">
                            </a>
                            <c:if test="${p.salePrice > 0 && p.salePrice < p.originalPrice}">
                                <span class="product-discount">-<fmt:formatNumber value="${(p.originalPrice - p.salePrice) / p.originalPrice}" type="percent" maxFractionDigits="0"/></span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><a href="detail?pid=${p.id}">${p.name}</a></h3>
                            <div class="product-price">
                                <%-- LOGIC HIỂN THỊ GIÁ MỚI (Bao gồm Happy Weekend) --%>
                                <span class="sale-price" style="color: #dc3545; font-weight: bold; font-size: 18px;">
                                    <fmt:formatNumber value="${p.salePrice > 0 ? p.salePrice : p.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                </span>

                                <%-- Nếu là ngày khuyến mãi, hiển thị giá gốc gạch ngang và badge --%>
                                <c:if test="${isSpecialDay}">
                                    <div style="margin-top: 5px;">
                                        <span class="original-price" style="text-decoration: line-through; color: #888; font-size: 13px;">
                                            <fmt:formatNumber value="${p.originalPrice}" type="number"/>đ
                                        </span>
                                    </div>
                                </c:if>

                                <%-- Logic cũ: Nếu không phải ngày KM nhưng sản phẩm có sale sẵn --%>
                                <c:if test="${!isSpecialDay && p.salePrice > 0 && p.salePrice < p.originalPrice}">
                                    <span class="original-price" style="text-decoration: line-through; color: #888; font-size: 14px; margin-left: 8px;">
                                        <fmt:formatNumber value="${p.originalPrice}" type="number"/>đ
                                    </span>
                                </c:if>
                            </div>
                            <a href="detail?pid=${p.id}" class="add-to-cart-btn" style="text-align: center;">Xem chi tiết</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <%-- 3. Khối Thời Trang MỚI NHẤT (GIỮ NGUYÊN) --%>
        <section class="product-showcase">
            <h2 class="section-title">Thời trang Mới nhất</h2>
            <div class="product-grid">
                <c:forEach items="${latestProducts}" var="p">
                    <div class="product-card">
                        <div class="product-image">
                            <a href="detail?pid=${p.id}">
                                <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}">
                            </a>
                            <c:if test="${p.salePrice > 0 && p.salePrice < p.originalPrice}">
                                <span class="product-discount">-<fmt:formatNumber value="${(p.originalPrice - p.salePrice) / p.originalPrice}" type="percent" maxFractionDigits="0"/></span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><a href="detail?pid=${p.id}">${p.name}</a></h3>
                            <div class="product-price">
                                <%-- LOGIC HIỂN THỊ GIÁ MỚI (Bao gồm Happy Weekend) --%>
                                <span class="sale-price" style="color: #dc3545; font-weight: bold; font-size: 18px;">
                                    <fmt:formatNumber value="${p.salePrice > 0 ? p.salePrice : p.originalPrice}" type="number" maxFractionDigits="0"/>đ
                                </span>

                                <%-- Nếu là ngày khuyến mãi, hiển thị giá gốc gạch ngang và badge --%>
                                <c:if test="${isSpecialDay}">
                                    <div style="margin-top: 5px;">
                                        <span class="original-price" style="text-decoration: line-through; color: #888; font-size: 13px;">
                                            <fmt:formatNumber value="${p.originalPrice}" type="number"/>đ
                                        </span>
                                    </div>
                                </c:if>

                                <%-- Logic cũ: Nếu không phải ngày KM nhưng sản phẩm có sale sẵn --%>
                                <c:if test="${!isSpecialDay && p.salePrice > 0 && p.salePrice < p.originalPrice}">
                                    <span class="original-price" style="text-decoration: line-through; color: #888; font-size: 14px; margin-left: 8px;">
                                        <fmt:formatNumber value="${p.originalPrice}" type="number"/>đ
                                    </span>
                                </c:if>
                            </div>
                            <a href="detail?pid=${p.id}" class="add-to-cart-btn" style="text-align: center;">Xem chi tiết</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

    </div>
</main>

<jsp:include page="footer.jsp"></jsp:include>

<%-- THÊM JAVASCRIPT CHO SLIDER VÀO CUỐI TRANG --%>
<script>
    let slideIndex = 1;
    let autoSlideInterval;

    showSlides(slideIndex);
    startAutoSlide(); // Bắt đầu tự động chạy slide

    // Hàm bắt đầu/reset tự động chạy
    function startAutoSlide() {
        if (autoSlideInterval)
            clearInterval(autoSlideInterval);
        autoSlideInterval = setInterval(() => moveSlide(1), 5000); // Tự động chuyển slide mỗi 5 giây
    }

    // Hàm chuyển slide (cho nút prev/next)
    function moveSlide(n) {
        showSlides(slideIndex += n);
        startAutoSlide(); // Reset lại hẹn giờ
    }

    // Hàm đến slide cụ thể (cho dấu chấm)
    function currentSlide(n) {
        showSlides(slideIndex = n);
        startAutoSlide(); // Reset lại hẹn giờ
    }

    // Hàm hiển thị slide chính
    function showSlides(n) {
        let i;
        let slides = document.getElementsByClassName("slide");
        let dots = document.getElementsByClassName("dot");

        if (n > slides.length) {
            slideIndex = 1
        } // Quay lại slide đầu
        if (n < 1) {
            slideIndex = slides.length
        } // Về slide cuối

        // Ẩn tất cả slide
        for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
            slides[i].classList.remove("active");
        }

        // Bỏ active tất cả dấu chấm
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(" active", "");
        }

        // Hiển thị slide và dấu chấm hiện tại
        slides[slideIndex - 1].style.display = "block";
        slides[slideIndex - 1].classList.add("active");
        dots[slideIndex - 1].className += " active";
    }
</script>

</body>
</html>