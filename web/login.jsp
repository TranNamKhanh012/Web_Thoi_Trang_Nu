<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng nhập</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <style>
        .page-container { margin-top: 135px; background-color: #f7f7f7; padding: 50px 0; }
        .auth-form { width: 400px; margin: 0 auto; background: white; padding: 30px; border: 1px solid #eee; text-align: center; }
        .auth-form h2 { margin-bottom: 20px; font-size: 24px; }
        .form-group { margin-bottom: 15px; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; }
        .btn-submit { width: 100%; padding: 12px; background: #222; color: white; border: none; cursor: pointer; font-weight: bold; }
        .auth-links { display: flex; justify-content: space-between; margin-top: 15px; }
        .error-message { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="page-container">
        <div class="container">
            <div class="auth-form">
                <h2>ĐĂNG NHẬP</h2>
                <c:if test="${not empty error}">
                    <p class="error-message">${error}</p>
                </c:if>
                <form action="login" method="POST">
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Email" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="pass" placeholder="Mật khẩu" required>
                    </div>
                    <button type="submit" class="btn-submit">ĐĂNG NHẬP</button>
                </form>
                <div class="auth-links">
                    <a href="forgot-password">Quên mật khẩu?</a>
                    <a href="register">Đăng ký tại đây</a>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>