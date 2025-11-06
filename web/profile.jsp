<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thông tin tài khoản</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .page-container { margin-top: 135px; background-color: #f7f7f7; padding: 50px 0; }
        /* Tái sử dụng style từ trang login/register */
        .auth-form {
            width: 500px; /* Rộng hơn 1 chút */
            margin: 0 auto;
            background: white;
            padding: 30px;
            border: 1px solid #eee;
            text-align: center;
        }
        .auth-form h2 { margin-bottom: 25px; font-size: 24px; }
        .form-group { margin-bottom: 20px; text-align: left; } /* Căn lề trái */
        .form-group label {
            display: block;
            margin-bottom: 8px; /* Thêm label */
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px; /* Thêm bo góc */
        }
        .form-group input[readonly] { /* Style cho ô email */
            background-color: #eee;
            cursor: not-allowed;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #007bff; /* Màu xanh */
            color: white;
            border: none;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px; /* Thêm bo góc */
            transition: background-color 0.2s;
        }
        .btn-submit:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="page-container">
        <div class="container">
            <div class="auth-form">
                <h2>THÔNG TIN TÀI KHOẢN</h2>
                
                <form action="profile" method="POST">
                    <div class="form-group">
                        <label for="fullname">Họ và Tên *</label>
                        <input type="text" id="fullname" name="fullname" value="${userDetail.fullname}" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email (Không thể thay đổi)</label>
                        <input type="email" id="email" name="email" value="${userDetail.email}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" value="${userDetail.phoneNumber}">
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" value="${userDetail.address}">
                    </div>
                    
                    <button type="submit" class="btn-submit">LƯU THAY ĐỔI</button>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <%-- Phần script cho toast notification đã có sẵn trong header.jsp --%>
</body>
</html>