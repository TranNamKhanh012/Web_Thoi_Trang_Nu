<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quên mật khẩu</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <%-- Copy style từ login.jsp --%>
    <style>
        .page-container { margin-top: 135px; background-color: #f7f7f7; padding: 50px 0; }
        .auth-form { width: 400px; margin: 0 auto; background: white; padding: 30px; border: 1px solid #eee; text-align: center; }
        .auth-form h2 { margin-bottom: 20px; font-size: 24px; }
        .form-group { margin-bottom: 15px; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; }
        .btn-submit { width: 100%; padding: 12px; background: #222; color: white; border: none; cursor: pointer; font-weight: bold; }
        .auth-links { text-align: right; margin-top: 15px; }
        .error-message { color: red; margin-bottom: 15px; }
        .success-message { color: green; margin-bottom: 10px; font-weight: bold;}
        .token-display { background: #eee; padding: 10px; margin: 10px 0; font-family: monospace; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="page-container">
        <div class="container">
            <div class="auth-form">
                <h2>QUÊN MẬT KHẨU</h2>
                <p>Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.</p>

                <c:if test="${not empty error}"><p class="error-message">${error}</p></c:if>
                <c:if test="${not empty message}"><p class="success-message">${message}</p></c:if>
                <%-- Hiển thị token (chỉ để mô phỏng) --%>
                <c:if test="${not empty token}"><p class="token-display">${token}</p></c:if>
                <%-- Hiển thị link (chỉ để mô phỏng) --%>
                <c:if test="${not empty resetLink}"><p><a href="${resetLink}">Đi đến trang đặt lại mật khẩu</a></p></c:if>

                <form action="forgot-password" method="POST">
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Email" required>
                    </div>
                    <button type="submit" class="btn-submit">GỬI YÊU CẦU</button>
                </form>
                <div class="auth-links">
                    <a href="login">Quay lại đăng nhập</a>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>