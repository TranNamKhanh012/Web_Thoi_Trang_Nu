<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Giới thiệu - ShopFashion</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    
    <style>
        .page-container {
            margin-top: 135px;
            background: #f9f9f9;
            padding: 40px 0 80px 0; /* Thêm padding dưới */
        }
        .page-container .container {
            display: block; /* Ghi đè flexbox để nội dung xếp dọc */
        }
        .breadcrumbs {
            margin-bottom: 25px;
            color: #888;
            font-size: 14px;
        }
        .breadcrumbs a {
            color: #333;
        }
        .about-content {
            max-width: 900px; /* Giới hạn chiều rộng cho dễ đọc */
            margin: 0 auto; /* Căn giữa */
            line-height: 1.8; /* Giãn dòng */
            font-size: 16px;
            color: #555;
        }
        .about-content h2 {
            font-size: 28px;
            font-weight: 700;
            color: #222;
            margin-bottom: 20px;
        }
        .about-content p {
            margin-bottom: 20px;
        }
        .about-content img {
            width: 100%;
            border-radius: 8px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>

    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="home">Trang chủ</a> > Giới thiệu
            </div>
            
            <div class="about-content">
                <h2>VỀ CHÚNG TÔI - SHOP FASHION</h2>
                
                <p>
                    Chào mừng bạn đến với **Shop Fashion** (lấy cảm hứng từ "Thời trang 03"), cửa hàng chuyên về thời trang, nơi khách hàng có thể tìm thấy những sản phẩm thời trang đa dạng và phong cách. Với một bộ sưu tập đa dạng từ áo sơ mi, váy đầm, quần jeans đến phụ kiện thời trang, chúng tôi cam kết mang đến cho khách hàng những sản phẩm chất lượng và phong cách mới nhất.
                </p>
                <p>
                    Được ra đời với sứ mệnh "Định hình phong cách của bạn", chúng tôi hiểu rằng thời trang không chỉ là quần áo bạn mặc, mà còn là cách bạn thể hiện bản thân. Với không gian mua sắm thoải mái và nhân viên phục vụ chuyên nghiệp, chúng tôi luôn sẵn sàng đáp ứng nhu cầu thời trang của khách hàng. Hãy đến với Shop Fashion để trải nghiệm mua sắm thú vị và tìm kiếm những bộ trang phục phù hợp với phong cách của bạn.
                </p>
                
                <img src="images/banner5.jpg" alt="Cửa hàng thời trang của chúng tôi">
                
                <h3>SỨ MỆNH & TẦM NHÌN</h3>
                <p>
                    **Sứ mệnh:** Không ngừng sáng tạo và cập nhật các xu hướng mới nhất, chúng tôi mong muốn mang đến cho khách hàng Việt Nam những sản phẩm thời trang chất lượng cao với mức giá hợp lý. Chúng tôi tin rằng mọi người đều xứng đáng được cảm thấy tự tin và xinh đẹp trong trang phục của mình.
                </p>
                <p>
                    **Tầm nhìn:** Trở thành thương hiệu thời trang được yêu thích và tin cậy hàng đầu tại Việt Nam, xây dựng một cộng đồng nơi thời trang gắn kết mọi người và là nguồn cảm hứng cho phong cách sống hiện đại, năng động.
                </p>

                <h3>GIÁ TRỊ CỐT LÕI</h3>
                <ul>
                    <li><strong>Chất lượng là ưu tiên hàng đầu:</strong> Mỗi sản phẩm trước khi đến tay khách hàng đều qua một quy trình kiểm tra chất lượng nghiêm ngặt, từ chất liệu vải, đường may đến kiểu dáng.</li>
                    <li><strong>Khách hàng là trọng tâm:</strong> Mọi hoạt động của chúng tôi đều xoay quanh trải nghiệm của bạn. Đội ngũ nhân viên chuyên nghiệp luôn sẵn sàng tư vấn và hỗ trợ bạn tìm được sản phẩm ưng ý nhất.</li>
                    <li><strong>Đổi mới liên tục:</strong> Thị trường thời trang luôn vận động. Chúng tôi cam kết không ngừng học hỏi và đổi mới để mang đến những bộ sưu tập độc đáo và hợp thời nhất.</li>
                </ul>
                
                <p style="margin-top: 20px;">
                    Hãy để **Shop Fashion** đồng hành cùng bạn trên hành trình khẳng định phong cách cá nhân. Cảm ơn bạn đã tin tưởng và lựa chọn chúng tôi!
                </p>
            </div>
            
        </div>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>