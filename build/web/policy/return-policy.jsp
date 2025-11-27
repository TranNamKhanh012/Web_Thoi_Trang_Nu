<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <%-- (Copy toàn bộ thẻ <head> từ file shipping-policy.jsp) --%>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${pageTitle} - ShopFashion</title>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        /* (Copy toàn bộ <style> từ file shipping-policy.jsp) */
        .page-container { margin-top: 135px; background: #fff; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
        .breadcrumbs a { color: #333; }
        .policy-content { max-width: 800px; margin: 0 auto; line-height: 1.8; font-size: 16px; color: #555; }
        .policy-content h2 { font-size: 28px; margin-bottom: 20px; }
        .policy-content h3 { font-size: 22px; margin-top: 30px; margin-bottom: 15px; }
        .policy-content p { margin-bottom: 15px; }
        .policy-content ul { margin-left: 20px; margin-bottom: 15px; }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp"/>
    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a> > ${pageTitle}
            </div>
            
            <div class="policy-content">
                <h2>${pageTitle}</h2>
                
                <h3>1. ĐIỀU KIỆN ĐỔI TRẢ</h3>
                <p>ShopFashion hỗ trợ đổi trả sản phẩm trong vòng **30 ngày** kể từ ngày nhận hàng với các điều kiện sau:</p>
                <ul>
                    <li>Sản phẩm còn nguyên tem, mác, chưa qua sử dụng, giặt ủi, không bị dính bẩn hoặc hư hỏng.</li>
                    <li>Sản phẩm bị lỗi kỹ thuật do nhà sản xuất (lỗi đường may, phai màu, hỏng khóa kéo...).</li>
                    <li>Sản phẩm giao sai về số lượng, mẫu mã, hoặc size so với đơn đặt hàng.</li>
                    <li>Không áp dụng đổi trả đối với các sản phẩm phụ kiện, đồ lót.</li>
                </ul>

                <h3>2. QUY TRÌNH ĐỔI TRẢ</h3>
                <p><strong>Bước 1:</strong> Liên hệ Hotline hoặc Fanpage của ShopFashion, cung cấp Mã đơn hàng và lý do đổi trả.</p>
                <p><strong>Bước 2:</strong> Đóng gói sản phẩm cẩn thận, gửi về địa chỉ kho hàng của chúng tôi (sẽ được nhân viên CSKH cung cấp).</p>
                <p><strong>Bước 3:</strong> Sau khi nhận được hàng, ShopFashion sẽ tiến hành kiểm tra sản phẩm. Nếu đủ điều kiện, chúng tôi sẽ thực hiện đổi sản phẩm mới hoặc hoàn tiền cho quý khách trong vòng 3-5 ngày làm việc.</p>

                <h3>3. CHI PHÍ ĐỔI TRẢ</h3>
                <ul>
                    <li>**ShopFashion chịu 100% phí vận chuyển** nếu lỗi thuộc về nhà sản xuất hoặc do ShopFashion giao nhầm.</li>
                    <li>**Khách hàng vui lòng thanh toán phí vận chuyển 2 chiều** nếu có nhu cầu đổi sang sản phẩm khác (khác size, khác màu, khác mẫu) theo ý muốn.</li>
                </ul>
            </div>
        </div>
    </div>
    <jsp:include page="../footer.jsp"/>
</body>
</html>