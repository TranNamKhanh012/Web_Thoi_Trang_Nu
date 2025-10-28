<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đặt lại mật khẩu</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <%-- Copy style từ login.jsp --%>
    <style>
        .page-container { margin-top: 135px; background-color: #f7f7f7; padding: 50px 0; }
        .auth-form { width: 400px; margin: 0 auto; background: white; padding: 30px; border: 1px solid #eee; text-align: center; }
        .auth-form h2 { margin-bottom: 20px; font-size: 24px; }
        .form-group { margin-bottom: 15px; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; }
        .btn-submit { width: 100%; padding: 12px; background: #222; color: white; border: none; cursor: pointer; font-weight: bold; }
        .error-message { color: red; margin-bottom: 15px; }
        .form-disabled { pointer-events: none; opacity: 0.5; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="page-container">
        <div class="container">
            <div class="auth-form">
                <h2>ĐẶT LẠI MẬT KHẨU</h2>

                <c:if test="${not empty error}">
                    <p class="error-message">${error}</p>
                </c:if>

                <%-- Chỉ hiển thị form nếu token hợp lệ (không có lỗi) --%>
                <form action="reset-password" method="POST" class="${not empty error ? 'form-disabled' : ''}">
                    <%-- Input ẩn để gửi token đi --%>
                    <input type="hidden" name="token" value="${token}">

                    <div class="form-group">
                        <input type="password" name="newPassword" placeholder="Mật khẩu mới" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
                    </div>
                    <button type="submit" class="btn-submit">ĐẶT LẠI MẬT KHẨU</button>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>