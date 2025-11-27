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
    <jsp:include page="../header.jsp"/> <%-- Chú ý đường dẫn ../header.jsp --%>
    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a> > ${pageTitle}
            </div>
            
            <div class="policy-content">
                <h2>${pageTitle}</h2>
                
                <h3>1. PHẠM VI GIAO HÀNG</h3>
                <p>ShopFashion hỗ trợ giao hàng trên toàn quốc. Chúng tôi liên kết với các đơn vị vận chuyển uy tín (Giao Hàng Nhanh, Viettel Post, v.v.) để đảm bảo sản phẩm đến tay bạn một cách nhanh chóng và an toàn nhất.</p>

                <h3>2. THỜI GIAN GIAO HÀNG (DỰ KIẾN)</h3>
                <ul>
                    <li><strong>Nội thành Hà Nội & TP. Hồ Chí Minh:</strong> 1-2 ngày làm việc.</li>
                    <li><strong>Các tỉnh thành khác:</strong> 3-5 ngày làm việc.</li>
                </ul>
                <p>Thời gian giao hàng không tính Chủ Nhật và các ngày Lễ, Tết. Thời gian có thể thay đổi do ảnh hưởng của thời tiết hoặc các sự kiện bất khả kháng.</p>

                <h3>3. PHÍ VẬN CHUYỂN</h3>
                <ul>
                    <li><strong>Đồng giá 30.000đ</strong> cho tất cả các đơn hàng trên toàn quốc.</li>
                    <li><strong>Miễn phí vận chuyển (FREESHIP)</strong> cho các đơn hàng có giá trị từ 500.000đ trở lên.</li>
                </ul>

                <h3>4. KIỂM TRA HÀNG (ĐỒNG KIỂM)</h3>
                <p>Để đảm bảo quyền lợi, quý khách hàng được phép kiểm tra sản phẩm (đúng mẫu mã, số lượng, size, màu sắc) trước khi nhận hàng. Quý khách vui lòng không thử đồ. Nếu phát hiện sai sót, quý khách vui lòng liên hệ ngay hotline của chúng tôi để được hỗ trợ.</p>
            </div>
        </div>
    </div>
    <jsp:include page="../footer.jsp"/> <%-- Chú ý đường dẫn ../footer.jsp --%>
</body>
</html>