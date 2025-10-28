<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tin tức - ShopFashion</title>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .page-container { margin-top: 135px; background: #f9f9f9; padding: 40px 0 80px 0; }
        .page-container .container { display: block; }
        .breadcrumbs { margin-bottom: 25px; color: #888; font-size: 14px; }
        .breadcrumbs a { color: #333; }
        .page-title { text-align: center; font-size: 32px; font-weight: 700; margin-bottom: 40px; }
        
        .article-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
        .article-card { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .article-card img { width: 100%; height: 200px; object-fit: cover; }
        .article-info { padding: 20px; }
        .article-info h3 { font-size: 18px; font-weight: 600; margin-bottom: 10px; height: 48px; }
        .article-info h3 a:hover { color: #007bff; }
        .article-info p { font-size: 14px; color: #666; margin-bottom: 15px; }
        .article-info .read-more { font-weight: bold; color: #007bff; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="page-container">
        <div class="container">
            <div class="breadcrumbs">
                <a href="home">Trang chủ</a> > Tin tức
            </div>
            <h1 class="page-title">Blog & Tin Tức</h1>
            
            <div class="article-grid">
                <c:forEach items="${articleList}" var="a">
                    <div class="article-card">
                        <a href="article?id=${a.id}"><img src="${a.imageUrl}" alt="${a.title}"></a>
                        <div class="article-info">
                            <h3><a href="article?id=${a.id}">${a.title}</a></h3>
                            <p>${a.content}</p> <%-- Đây là nội dung tóm tắt từ DAO --%>
                            <a href="article?id=${a.id}" class="read-more">Đọc thêm...</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp"/>
</body>
</html>