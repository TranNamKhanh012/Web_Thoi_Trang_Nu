<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    footer .container {
        display: block !important; 
    }
</style>
<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-column">
                <p>Trần Nam Khánh - 22103100056</p>
                <p>Bùi Đức Nam - 22103100039</p>
                <p>Phạm Văn  - 22103100057</p>
                <p>thoitrang03@gmail.com</p>
                <p>0123456789</p>
                <p>Facebook</p>
            </div>
            <div class="footer-column">
                <h4>VỀ CHÚNG TÔI</h4>
                <ul>
                    <li><a href="home" class="${activePage == 'home' ? 'active' : ''}">Trang chủ</a></li>
                    <li><a href="about" class="${activePage == 'about' ? 'active' : ''}">Giới thiệu</a></li>
                    <li class="has-dropdown"><a href="products" class="${activePage == 'products' ? 'active' : ''}">Sản phẩm</a></li>
                    <li><a href="news" class="${activePage == 'news' ? 'active' : ''}">Tin tức</a></li>
                    <li><a href="contact" class="${activePage == 'stores' ? 'active' : ''}">Liên hệ & hệ thống cửa hàng</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4>HỖ TRỢ KHÁCH HÀNG</h4>
                <ul>
                    <li><a href="#">Đơn hàng</a></li>
                    <li><a href="#">Chính sách đối tác</a></li>
                    <li><a href="#">Chính sách đổi trả</a></li>
                    <li><a href="#">Chính sách giao hàng</a></li>
                    <li><a href="#">Chính sách thanh toán</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4>TƯ VẤN KHÁCH HÀNG</h4>
                <p>Mua hàng: 0123456789</p>
                <p>Khiếu nại: 0123456789</p>
                <p>Bảo hành: 0123456789</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© Bản quyền thuộc về Thời Trang | Thiết kế bởi Nhom3</p>
        </div>
    </div>
    <a href="#" class="scroll-to-top"><i class="fa-solid fa-arrow-up"></i></a>
</footer>
<!--Start of Tawk.to Script-->
<script type="text/javascript">
var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/690390a9d8bd2d195501a167/1j8quq5it';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();
</script>
<!--End of Tawk.to Script-->
</body>
</html>