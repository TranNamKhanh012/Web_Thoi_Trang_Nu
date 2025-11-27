<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${article.title}</title>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <style>
            .page-container {
                margin-top: 135px;
                background: #fff;
                padding: 40px 0 80px 0;
            }
            .page-container .container {
                display: block;
            }
            .breadcrumbs {
                margin-bottom: 25px;
                color: #888;
                font-size: 14px;
            }
            .breadcrumbs a {
                color: #333;
            }

            .article-wrapper {
                max-width: 800px;
                margin: 0 auto;
            }
            .article-wrapper h1 {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 20px;
            }
            .article-wrapper .article-meta {
                font-size: 14px;
                color: #888;
                margin-bottom: 25px;
            }
            .article-wrapper img.cover-image {
                width: 100%;
                height: auto; /* Thêm dòng này */
                aspect-ratio: 16 / 9; /* <<< THÊM DÒNG NÀY: Đặt tỷ lệ 16:9 (widescreen) */
                object-fit: cover; /* <<< THÊM DÒNG NÀY: Cắt ảnh vừa khung, không bị méo */
                border-radius: 8px;
                margin-bottom: 30px;
                background-color: #f0f0f0; /* Thêm màu nền mờ phòng khi ảnh tải chậm */
            }

            .article-content {
                font-size: 16px;
                line-height: 1.8;
                color: #333;
            }
            .article-content p {
                margin-bottom: 20px;
            }
            .article-content h3 {
                font-size: 22px;
                font-weight: 600;
                margin-top: 30px;
                margin-bottom: 15px;
            }/* --- DÁN ĐOẠN NÀY VÀO <style> CỦA article-detail.jsp --- */

            .article-content img {
                /* Đảm bảo ảnh không bao giờ rộng hơn khung chứa (800px) */
                max-width: 100%;

                /* Giữ đúng tỷ lệ khung hình của ảnh */
                height: auto;

                /* Thêm bo góc và khoảng cách cho đẹp (giống ảnh bìa) */
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
                    <a href="home">Trang chủ</a> > <a href="news">Tin tức</a> > ${article.title}
                </div>

                <div class="article-wrapper">
                    <h1>${article.title}</h1>
                    <div class="article-meta">
                        Ngày đăng: <fmt:formatDate value="${article.createdDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    <img src="${article.imageUrl}" alt="${article.title}" class="cover-image">

                    <div class="article-content">
                        <%-- Dòng này cho phép hiển thị HTML bạn đã chèn vào CSDL --%>
                        ${article.content}
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp"/>
    </body>
</html>