<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Kết quả thanh toán</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <style>
        .page-container { margin-top: 135px; padding: 50px 0; text-align: center; }
        .result-box { max-width: 600px; margin: 0 auto; padding: 30px; background: #f9f9f9; border-radius: 8px; }
        .result-box h2 { margin-bottom: 20px; }
        .result-box.success { background-color: #d4edda; color: #155724; }
        .result-box.error { background-color: #f8d7da; color: #721c24; }
        .btn-home { display: inline-block; padding: 12px 25px; background: #007bff; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; margin-top: 20px;}
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>

    <div class="page-container">
        
        <%-- Lấy mã phản hồi từ URL --%>
        <c:set var="vnp_ResponseCode" value="${param.vnp_ResponseCode}"/>

        <c:choose>
            <%-- Nếu thanh toán thành công --%>
            <c:when test="${vnp_ResponseCode == '00'}">
                <div class="result-box success">
                    <h2>Thanh toán thành công!</h2>
                    <p>Cảm ơn bạn đã mua hàng. Đơn hàng #${param.vnp_TxnRef} của bạn đang được xử lý.</p>
                    <p>Số tiền đã thanh toán: <fmt:formatNumber value="${param.vnp_Amount / 100}" type="number"/>đ</p>
                    <a href="${pageContext.request.contextPath}/confirm-order?orderId=${param.vnp_TxnRef}" 
                           class="btn-home" style="background-color: #28a745; margin-top: 15px;">
                           Hoàn Thành
                        </a>
                </div>
            </c:when>
            <%-- Nếu thanh toán thất bại --%>
            <c:otherwise>
                 <div class="result-box error">
                    <h2>Thanh toán thất bại!</h2>
                    <p>Đã xảy ra lỗi trong quá trình thanh toán cho đơn hàng #${param.vnp_TxnRef}.</p>
                    <p>Lý do: ${param.vnp_TransactionStatus}</p> <%-- Hiển thị lý do từ VNPay --%>
                </div>
            </c:otherwise>
        </c:choose>
        
        <%--<a href="${pageContext.request.contextPath}/home" class="btn-home">Quay về trang chủ</a>--%>
    </div>

    <jsp:include page="footer.jsp"/>
</body>
</html>