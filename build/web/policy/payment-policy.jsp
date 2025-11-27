<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${pageTitle} - ShopFashion</title>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/> <%-- Chú ý đường dẫn ../css/ --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .page-container { margin-top: 135px; background: #fff; padding: 40px 0 80px 0; }
        .page-container .container { display: block; } /* Sửa lỗi layout do .container chung */
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
            
            <p>Để mang lại trải nghiệm mua sắm tiện lợi nhất, ShopFashion cung cấp các phương thức thanh toán linh hoạt sau:</p>

            <h3>1. THANH TOÁN KHI NHẬN HÀNG (COD)</h3>
            <p>Quý khách hàng sẽ thanh toán bằng tiền mặt trực tiếp cho nhân viên giao hàng sau khi đã kiểm tra sản phẩm.</p>
            <p>Chúng tôi áp dụng hình thức COD cho tất cả các đơn hàng trên toàn quốc.</p>

            <h3>2. THANH TOÁN TRỰC TUYẾN QUA CỔNG VNPay</h3>
            <p>Chúng tôi chấp nhận thanh toán an toàn và bảo mật thông qua cổng VNPay. Quý khách có thể sử dụng:</p>
            <ul>
                <li>Thẻ ATM nội địa (Đã đăng ký Internet Banking).</li>
                <li>Thẻ tín dụng/ghi nợ quốc tế (Visa, MasterCard, JCB, Amex).</li>
                <li>Ví điện tử VNPay.</li>
            </ul>
            <p>Sau khi chọn "Đặt hàng", hệ thống sẽ chuyển bạn đến giao diện thanh toán an toàn của VNPay để hoàn tất giao dịch.</p>
        </div>
    </div>
</div>
<jsp:include page="../footer.jsp"/>
</body>
</html>