<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cổng thanh toán</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; }
        .payment-gateway { width: 400px; padding: 30px; background: white; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; }
        .payment-gateway h2 { margin-bottom: 20px; }
        .payment-gateway p { font-size: 24px; font-weight: bold; color: #dc3545; }
        .payment-actions button { width: 100%; padding: 15px; border: none; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn-success { background-color: #28a745; color: white; }
    </style>
</head>
<body>
    <div class="payment-gateway">
        <h2>Cổng thanh toán ảo</h2>
        <p>
            <fmt:formatNumber value="${param.total}" type="number"/>đ
        </p>
        <div class="payment-actions">
            <%-- Về sau, nút này sẽ gọi đến 1 controller để cập nhật trạng thái đơn hàng --%>
            <a href="payment-success?orderId=${param.orderId}"><button class="btn-success">Thanh toán thành công</button></a>
        </div>
    </div>
</body>
</html>