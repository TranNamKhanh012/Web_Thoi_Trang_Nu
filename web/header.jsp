<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .header-top .user-actions {
            display: flex;
            align-items: center;
        }
        
        /* === CSS CHO TOAST NOTIFICATION === */
        .toast-notification {
            position: fixed;
            top: 150px; /* Ngay dưới header */
            right: 20px;
            padding: 15px 20px;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 1002;
            font-weight: bold;
            display: none; /* Ẩn mặc định */
            transition: opacity 0.5s, transform 0.5s;
            opacity: 0;
            transform: translateX(100%);
        }
        .toast-notification.show {
            display: block;
            opacity: 1;
            transform: translateX(0);
        }
        .toast-notification.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .toast-notification.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>

    <header>
        <div class="header-top">
            <div class="container">
                <div class="contact-info">
                    <span><i class="fa-solid fa-phone"></i> HOTLINE: 0941655JQK</span>
                    <span><i class="fa-solid fa-store"></i> HỆ THỐNG CỬA HÀNG</span>
                </div>
                <%-- Sửa thanh tìm kiếm thành 1 form, gửi bằng POST để hỗ trợ Tiếng Việt --%>
                <form class="search-bar" action="search" method="POST">
                    <input type="text" name="keyword" placeholder="Tìm kiếm..." required>
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
                <div class="user-actions">
                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: NẾU ĐÃ ĐĂNG NHẬP (${sessionScope.acc != null}) --%>
                        <c:when test="${sessionScope.acc != null}">
                            <a href="${pageContext.request.contextPath}/profile">XIN CHÀO, ${sessionScope.acc.fullname}</a>
                            <a href="logout">ĐĂNG XUẤT</a>
                        </c:when>

                        <%-- TRƯỜNG HỢP 2: NẾU CHƯA ĐĂNG NHẬP (NGƯỢC LẠI) --%>
                        <c:otherwise>
                            <a href="login">ĐĂNG NHẬP</a>
                        </c:otherwise>
                    </c:choose>
                            <%-- >>> THÊM KHỐI NÀY ĐỂ HIỂN THỊ LINK ADMIN <<< --%>
                            <c:if test="${sessionScope.acc != null && sessionScope.acc.role == 'admin'}">
                                <a href="admin" title="Admin Dashboard"><i class="fa-solid fa-gear"></i> ADMIN</a> 
                                <%-- Bạn có thể chỉ dùng icon <i...> nếu muốn --%>
                            </c:if>
                            <%-- >>> KẾT THÚC KHỐI THÊM <<< --%>
                    <%-- Link GIỎ HÀNG đơn giản --%>
                    <a href="cart"><i class="fa-solid fa-cart-shopping"></i> GIỎ HÀNG 
                        <span>
                            <c:choose>
                                <c:when test="${not empty sessionScope.cart}">${sessionScope.cart.totalQuantity}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                    </a>
                    <%-- 2. Nút Lịch sử mua hàng (ĐÃ THAY ĐỔI) --%>
                    <%-- Chỉ hiển thị khi đã đăng nhập --%>
                    <c:if test="${sessionScope.acc != null}">
                        <a href="order-history"><i class="fa-solid fa-receipt"></i> LỊCH SỬ MUA HÀNG</a>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="header-main">
            <div class="container">
                <a href="home" class="logo">
                    Shop fashion.
                </a>
                <nav class="main-nav">
                    <ul>
                        <li><a href="home" class="${activePage == 'home' ? 'active' : ''}">TRANG CHỦ</a></li>

                        <li><a href="about" class="${activePage == 'about' ? 'active' : ''}">GIỚI THIỆU</a></li>

                        <li class="has-dropdown"><a href="products" class="${activePage == 'products' ? 'active' : ''}">SẢN PHẨM </a></li>

                        <li><a href="news" class="${activePage == 'news' ? 'active' : ''}">TIN TỨC</a></li>

                        <li><a href="contact" class="${activePage == 'contact' ? 'active' : ''}">LIÊN HỆ & HỆ THỐNG CỬA HÀNG</a></li>

                        <li><a href="${pageContext.request.contextPath}/promotions" class="${activePage == 'promo' ? 'active' : ''}"><i class="fa-solid fa-tag"></i> KHUYẾN MÃI</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>
<div id="toast-notification" class="toast-notification"></div>
<%-- Lấy thông báo từ session --%>
    <c:set var="toastMessage" value="${sessionScope.successMsg != null ? sessionScope.successMsg : sessionScope.errorMsg}" />
    <c:set var="toastType" value="${sessionScope.successMsg != null ? 'success' : 'error'}" />

    <%-- Nếu có thông báo, thì chạy script --%>
    <c:if test="${not empty toastMessage}">
        <script type="text/javascript">
            // Chạy script sau khi trang đã tải xong
            document.addEventListener("DOMContentLoaded", function() {
                const toast = document.getElementById('toast-notification');
                
                // 1. Gán nội dung và kiểu thông báo
                toast.textContent = "${toastMessage}";
                toast.classList.add("${toastType}");
                
                // 2. Hiển thị thông báo
                toast.classList.add('show');
                
                // 3. Tự động ẩn sau 5 giây
                setTimeout(function() {
                    toast.classList.remove('show');
                }, 5000); // 5000ms = 5 giây
            });
        </script>
        
        <%-- Xóa thông báo khỏi session để không hiển thị lại --%>
        <c:remove var="successMsg" scope="session"/>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>
</body>
</html>