<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập bằng QR Code</title>
    <%-- Thư viện tạo QR Code bằng Javascript (Chạy cực nhanh và ổn định) --%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            text-align: center; 
            padding-top: 50px; 
            background: #f4f4f4; 
        }
        .qr-card { 
            background: white; 
            padding: 40px; 
            border-radius: 15px; 
            display: inline-block; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.1); 
            max-width: 400px;
            width: 90%;
        }
        h2 { color: #333; margin-bottom: 10px; }
        .guide-text { color: #666; margin-bottom: 25px; font-size: 14px; }
        
        /* Chỗ để hiển thị mã QR */
        #qrcode {
            display: flex;
            justify-content: center;
            margin: 20px auto;
        }
        
        .status-box {
            margin-top: 20px;
            padding: 10px;
            border-radius: 5px;
            font-weight: bold;
            font-size: 16px;
        }
        .status-waiting { color: #007bff; background-color: #e7f1ff; }
        .status-success { color: #28a745; background-color: #d4edda; }
    </style>
</head>
<body>

    <div class="qr-card">
        <h2>Quét mã để đăng nhập</h2>
        <p class="guide-text">Mở camera hoặc Zalo trên điện thoại để quét</p>
        
        <%-- 
           CẤU HÌNH IP:
           Thay '192.168.1.X' bằng IP thật của máy bạn (Mở CMD gõ ipconfig để xem).
        --%>
        <c:set var="myIP" value="10.143.120.176" /> <%-- <<< SỬA IP CỦA BẠN TẠI ĐÂY --%>
        <c:set var="port" value="8080" />
        
        <%-- Link mà điện thoại sẽ truy cập --%>
        <c:set var="confirmUrl" value="http://${myIP}:${port}${pageContext.request.contextPath}/confirm-qr?token=${qrToken}" />
        
        <%-- Khung chứa mã QR (JS sẽ vẽ vào đây) --%>
        <div id="qrcode"></div>
        
        <div id="statusBox" class="status-box status-waiting">
            <i class="fa fa-spinner fa-spin"></i> Đang chờ quét...
        </div>
    </div>

    <script>
        // 1. TẠO MÃ QR
        // Lấy đường dẫn từ biến JSP
        var urlToEncode = "${confirmUrl}";
        
        // Dùng thư viện QRCode.js để vẽ
        var qrcode = new QRCode(document.getElementById("qrcode"), {
            text: urlToEncode,
            width: 200,
            height: 200,
            colorDark : "#000000",
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });

        // 2. KIỂM TRA TRẠNG THÁI LIÊN TỤC (Long Polling)
        let token = "${qrToken}";
        
        function checkLoginStatus() {
            fetch("check-qr?token=" + token)
                .then(response => response.text())
                .then(status => {
                    console.log("Status: " + status);
                    
                    if (status.trim() === "SUCCESS") {
                        // Thành công!
                        let box = document.getElementById("statusBox");
                        box.className = "status-box status-success";
                        box.innerHTML = "✅ Đăng nhập thành công! Đang chuyển hướng...";
                        
                        setTimeout(() => {
                            window.location.href = "home"; // Vào trang chủ
                        }, 1000);
                    } else {
                        // Chưa xong, đợi 2s hỏi tiếp
                        setTimeout(checkLoginStatus, 2000);
                    }
                })
                .catch(err => console.error(err));
        }

        // Bắt đầu kiểm tra
        checkLoginStatus();
    </script>
</body>
</html>