<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <style>
        .page-container { margin-top: 135px; background-color: #f7f7f7; padding: 50px 0; }
        .auth-form { width: 400px; margin: 0 auto; background: white; padding: 30px; border: 1px solid #eee; text-align: center; }
        .auth-form h2 { margin-bottom: 20px; font-size: 24px; }
        .form-group { margin-bottom: 15px; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; }
        .btn-submit { width: 100%; padding: 12px; background: #222; color: white; border: none; cursor: pointer; font-weight: bold; }
        .login-link { margin-top: 15px; }
        .error-message { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="page-container">
        <div class="container">
            <div class="auth-form">
                <h2>ĐĂNG KÝ</h2>
    
                <c:if test="${not empty error}">
                    <p class="error-message">${error}</p>
                </c:if>
                <form action="register" method="POST">
                    <div class="form-group">
                        <input type="text" name="ho" placeholder="Họ" required>
                    </div>
                    <div class="form-group">
                        <input type="text" name="ten" placeholder="Tên" required>
                    </div>
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Email" required pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" title="Vui lòng nhập địa chỉ email hợp lệ (ví dụ: example@domain.com)">
                    </div>
                    <div class="form-group">
                        <input type="text" id="phone" name="phone" placeholder="Số điện thoại" required pattern="[0-9]{10}" maxlength="10" title="Số điện thoại phải bao gồm 10 chữ số.">
                    </div>
                    <div class="form-group">
                        <input type="text" name="address" placeholder="Địa chỉ">
                    </div>
                    <div class="form-group">
                        <input type="password" name="pass" placeholder="Mật khẩu" required>
                    </div>
                    <button type="submit" class="btn-submit">ĐĂNG KÝ</button>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>