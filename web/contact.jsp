<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Liên hệ - ShopFashion</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    
    <style>
        .page-container { margin-top: 135px; background-color: #fff; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
        .breadcrumbs a { color: #333; }
        .contact-header { text-align: center; margin-bottom: 30px; }
        .contact-header h2 { font-size: 28px; font-weight: 700; color: #222; margin-bottom: 15px; }
        .contact-header p { font-size: 16px; color: #555; line-height: 1.7; }
        .map-wrapper { width: 100%; height: 450px; border: 1px solid #ddd; margin-bottom: 40px;}
        .map-wrapper iframe { width: 100%; height: 100%; border: none; }

        /* === CSS CHO FORM LIÊN HỆ === */
        .contact-form-section { max-width: 800px; margin: 40px auto 0 auto; }
        .contact-form-section h3 { font-size: 24px; text-align: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; }
        .form-group textarea { min-height: 150px; resize: vertical; }
        .btn-submit { display: block; width: 200px; margin: 20px auto 0 auto; padding: 12px 25px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 16px; }
        .form-message { padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; font-weight: bold;}
        .form-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .form-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>

    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="home">Trang chủ</a> > Liên hệ
            </div>
            
            <div class="contact-header">
                <h2>Bản đồ & thông tin Liên hệ</h2>
                <p>
                    <strong>CÔNG TY TNHH THƯƠNG MẠI MUA SẮM TRỰC TUYẾN LARVA STORE</strong><br>
                    Kho hàng: Khu đất dịch vụ Thôn Lũng 9, Lai Xá, Kim Chung, Hoài Đức, Hà Nội<br>
                    Hotline: 0976 345 080 - 0972 901 560 - 0976 345 030<br>
                    Email: sales.giadungonline@gmail.com
                </p>
            </div>
            
            <div class="map-wrapper">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3725.2169025714797!2d105.84598491090016!3d20.983940780573512!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac41db98b665%3A0x408509d6f5a57e2c!2zMTIzIFAuIFTDom4gTWFpLCBUw6JuIE1haSwgSG_DoG5nIE1haSwgSMOgIE7hu5lpLCBWaeG7h3QgTmFt!5e0!3m2!1svi!2s!4v1760710155449!5m2!1svi!2s"
                    width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>

            <%-- === FORM LIÊN HỆ === --%>
            <div class="contact-form-section">
                <h3>Gửi phản hồi cho chúng tôi</h3>

                <%-- Hiển thị thông báo lỗi/thành công --%>
                <c:if test="${not empty errorMsg}"> <p class="form-message form-error">${errorMsg}</p> </c:if>
                <c:if test="${not empty successMsg}"> <p class="form-message form-success">${successMsg}</p> </c:if>

                <form action="contact" method="POST">
                    <div class="form-group">
                        <label for="name">Họ và Tên *</label>
                        <input type="text" id="name" name="name" value="${oldName}" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" value="${oldEmail}" required>
                    </div>
                    <div class="form-group">
                        <label for="subject">Chủ đề</label>
                        <input type="text" id="subject" name="subject" value="${oldSubject}">
                    </div>
                    <div class="form-group">
                        <label for="message">Nội dung *</label>
                        <textarea id="message" name="message" required>${oldMessage}</textarea>
                    </div>
                    <button type="submit" class="btn-submit">Gửi tin nhắn</button>
                </form>
            </div>
            
        </div>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>