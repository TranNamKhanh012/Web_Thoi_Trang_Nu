<%-- 
    File   : home.jsp
    Author : yourname
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp"></jsp:include>

<section class="banner">
    <div class="banner-content">
        <p>Fashion</p>
    </div>
</section>
<main>
    <div class="container">
        <%-- 1. Khối Chính sách & Cam kết --%>
        <section class="policy-bar">
            <div class="policy-item">
                <img src="https://i.imgur.com/gB4gV2H.png" alt="Van chuyen icon">
                <div>
                    <h4>Vận chuyển MIỄN PHÍ</h4>
                    <p>Trong khu vực. TPHCM</p>
                </div>
            </div>
            <div class="policy-item">
                <img src="https://i.imgur.com/uN0T2y1.png" alt="Doi tra icon">
                <div>
                    <h4>Đổi trả MIỄN PHÍ</h4>
                    <p>Trong vòng 30 NGÀY</p>
                </div>
            </div>
            <div class="policy-item">
                <img src="https://i.imgur.com/S8z5f6E.png" alt="Thanh toan icon">
                <div>
                    <h4>Tiến hành THANH TOÁN</h4>
                    <p>Với nhiều PHƯƠNG THỨC</p>
                </div>
            </div>
            <div class="policy-item">
                <img src="https://i.imgur.com/B9dJ0u5.png" alt="Hoan tien icon">
                <div>
                    <h4>100% HOÀN TIỀN</h4>
                    <p>Nếu sản phẩm lỗi</p>
                </div>
            </div>
        </section>

        <%-- 2. Khối Top Bán Chạy --%>
        <section class="product-showcase">
            <h2 class="section-title">#Top Bán Chạy</h2>

            <div class="product-grid">
                <%-- Vòng lặp này phải gọi đúng tên biến "topSellingProducts" --%>
                <c:forEach items="${topSellingProducts}" var="p">
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
        </section>

        <%-- 3. Khối Thời Trang MỚI NHẤT --%>
        <section class="product-showcase">

            <%-- Sửa tiêu đề tại đây --%>
            <h2 class="section-title">#Thời trang Mới nhất</h2>
            <div class="product-grid">
                <%-- 
                  SỬ DỤNG DANH SÁCH "latestProducts" MÀ CONTROLLER ĐÃ GỬI SANG
                --%>
                <c:forEach items="${latestProducts}" var="p">
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
        </section>
        
    </div>
</main>

<jsp:include page="footer.jsp"></jsp:include>