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
            
            <p>ShopFashion luôn chào đón các cơ hội hợp tác kinh doanh để cùng nhau phát triển và mang những sản phẩm thời trang chất lượng đến gần hơn với người tiêu dùng Việt Nam.</p>

            <h3>1. HỢP TÁC CUNG CẤP SẢN PHẨM (B2B)</h3>
            <p>Chúng tôi tìm kiếm các nhà sản xuất, xưởng may, và các thương hiệu thời trang uy tín trong và ngoài nước có mong muốn phân phối sản phẩm trên nền tảng của ShopFashion.</p>
            <p><strong>Yêu cầu:</strong> Sản phẩm có chất lượng tốt, nguồn gốc rõ ràng, mẫu mã đa dạng và phù hợp với xu hướng.</p>

            <h3>2. CHÍNH SÁCH CHIẾT KHẤU</h3>
            <p>Chúng tôi cam kết mang đến mức chiết khấu hấp dẫn và cạnh tranh, dựa trên số lượng và giá trị đơn hàng, đảm bảo lợi ích cho cả hai bên.</p>

            <h3>3. HỢP TÁC TRUYỀN THÔNG (KOLs/INFLUENCERS)</h3>
            <p>Nếu bạn là một Influencer, Blogger thời trang và có chung định hướng phong cách với chúng tôi, đừng ngần ngại liên hệ để cùng nhau tạo nên những chiến dịch truyền thông sáng tạo và hiệu quả.</p>
            
            <p>Mọi chi tiết về hợp tác, vui lòng gửi thông tin và portfolio (nếu có) về địa chỉ email: <strong>partners@shopfashion.com</strong>.</p>
        </div>
    </div>
</div>
<jsp:include page="../footer.jsp"/>
</body>
</html>