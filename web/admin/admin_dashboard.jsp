<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <%-- Sử dụng Font Awesome cho icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <%-- Link tới file CSS chung của Admin (sẽ tạo ở Bước 2) --%>
    <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
    <%-- Thư viện Chart.js (tùy chọn, để vẽ biểu đồ sau này) --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* --- Cài đặt chung & Reset --- */
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7fc; color: #333; }
a { text-decoration: none; color: inherit; }
ul { list-style: none; }

/* --- Layout chính --- */
.admin-layout { display: flex; min-height: 100vh; }

/* --- Sidebar --- */
.admin-sidebar {
    width: 250px;
    background-color: #2c3e50; /* Màu xanh đậm */
    color: #ecf0f1; /* Màu chữ trắng nhạt */
    display: flex;
    flex-direction: column;
    flex-shrink: 0;
}
.sidebar-header {
    padding: 20px;
    text-align: center;
    background-color: #34495e; /* Màu đậm hơn chút */
}
.sidebar-header h2 { font-size: 24px; }
.sidebar-nav ul { padding-top: 20px; }
.sidebar-nav li a {
    display: block;
    padding: 15px 20px;
    color: #bdc3c7; /* Màu chữ xám nhạt */
    transition: background-color 0.3s, color 0.3s;
}
.sidebar-nav li a i { margin-right: 15px; width: 20px; text-align: center; }
.sidebar-nav li a:hover,
.sidebar-nav li a.active {
    background-color: #3498db; /* Màu xanh dương */
    color: #fff;
}

/* --- Main Content --- */
.admin-main-content {
    flex-grow: 1;
    padding: 30px;
    background-color: #f4f7fc; /* Màu nền chính */
}
.admin-header {
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e0e0e0;
}
.admin-header h1 { font-size: 28px; color: #2c3e50; }

/* --- Phần thống kê --- */
.dashboard-stats, .dashboard-finance, .dashboard-chart {
    margin-bottom: 40px;
}
.dashboard-stats h2, .dashboard-finance h2, .dashboard-chart h2 {
    font-size: 20px;
    color: #34495e;
    margin-bottom: 20px;
}
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); /* Responsive grid */
    gap: 20px;
}
.stat-card {
    background-color: #fff;
    border-radius: 8px;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
.stat-info h3 { font-size: 28px; color: #2c3e50; margin-bottom: 5px; }
.stat-info p { color: #7f8c8d; font-size: 14px; }
.stat-icon {
    font-size: 24px;
    color: #fff;
    width: 50px;
    height: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
}
/* Màu cho icon */
.stat-icon.purple { background-color: #9b59b6; }
.stat-icon.blue { background-color: #3498db; }
.stat-icon.orange { background-color: #e67e22; }
.stat-icon.pink { background-color: #e84393; }
.stat-icon.green { background-color: #2ecc71; }
.stat-icon.light-blue { background-color: #1abc9c; }
.stat-icon.yellow { background-color: #f1c40f; }

/* --- Phần biểu đồ --- */
.chart-container {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
    </style>
</head>
<body>
    <div class="admin-layout">
        <%-- SIDEBAR --%>
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>Fashion Admin</h2>
            </div>
            <nav class="sidebar-nav">
                 <ul>
                    <li><a href="${pageContext.request.contextPath}/admin" class="${activePage == 'dashboard' ? 'active' : ''}"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/products" class="${activePage == 'products' ? 'active' : ''}"><i class="fa-solid fa-box"></i> Quản lý Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories" class="${activePage == 'categories' ? 'active' : ''}"><i class="fa-solid fa-tags"></i> Quản lý Danh mục</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users" class="${activePage == 'users' ? 'active' : ''}"><i class="fa-solid fa-users"></i> Quản lý Người dùng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders" class="${activePage == 'orders' ? 'active' : ''}"><i class="fa-solid fa-receipt"></i> Quản lý Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/articles" class="${activePage == 'articles' ? 'active' : ''}"><i class="fa-solid fa-newspaper"></i> Quản lý Bài viết</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/feedback" class="${activePage == 'feedback' ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Quản lý Phản hồi</a></li>
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                </ul>
            </nav>
        </aside>

        <%-- MAIN CONTENT --%>
        <main class="admin-main-content">
            <header class="admin-header">
                <h1>Admin Dashboard</h1>
                <%-- Có thể thêm thông tin admin đăng nhập ở đây --%>
            </header>

            <section class="dashboard-stats">
                <h2>Thống kê tổng quan hệ thống</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${totalProducts}</h3>
                            <p>Sản phẩm</p>
                        </div>
                        <div class="stat-icon purple">
                            <i class="fa-solid fa-shirt"></i>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${totalSold}</h3>
                            <p>Hàng đã bán</p>
                        </div>
                        <div class="stat-icon blue">
                            <i class="fa-solid fa-cart-shopping"></i>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${totalStock}</h3> <%-- SỬA THÀNH BIẾN ĐÚNG --%>
                            <p>Hàng trong kho</p>
                        </div>
                        <div class="stat-icon light-blue"> <%-- Đổi màu icon cho khác --%>
                            <i class="fa-solid fa-warehouse"></i> <%-- Icon kho hàng --%>
                        </div>
                    </div>
                    <%-- >>> KẾT THÚC KHỐI THÊM <<< --%>
                     <div class="stat-card">
                        <div class="stat-info">
                            <h3>${newOrders}</h3>
                            <p>Đơn hàng mới</p>
                        </div>
                        <div class="stat-icon orange">
                             <i class="fa-solid fa-box"></i>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${totalUsers}</h3>
                            <p>Người dùng</p>
                        </div>
                        <div class="stat-icon pink">
                            <i class="fa-solid fa-users"></i>
                        </div>
                    </div>
                </div>
            </section>

            <section class="dashboard-finance">
                <h2>Thống kê tài chính</h2>
                 <div class="stats-grid">
                    <div class="stat-card finance">
                        <div class="stat-info">
                            <%-- Ví dụ dùng fmt:formatNumber --%>
                            <h3><fmt:formatNumber value="${revenueMonth}" type="number"/>đ</h3>
                            <p>Tổng doanh thu (tháng)</p>
                        </div>
                        <div class="stat-icon green">
                            <i class="fa-solid fa-arrow-trend-up"></i>
                        </div>
                    </div>
                    <div class="stat-card finance">
                        <div class="stat-info">
                             <h3><fmt:formatNumber value="${revenueToday}" type="number"/>đ</h3>
                            <p>Doanh thu hôm nay</p>
                        </div>
                        <div class="stat-icon light-blue">
                             <i class="fa-solid fa-briefcase"></i>
                        </div>
                    </div>
                     <div class="stat-card finance">
                        <div class="stat-info">
                             <h3><fmt:formatNumber value="${revenueWeek}" type="number"/>đ</h3>
                            <p>Doanh thu tuần này</p>
                        </div>
                        <div class="stat-icon yellow">
                            <i class="fa-solid fa-calendar-days"></i>
                        </div>
                    </div>
                </div>
            </section>

             <section class="dashboard-chart">
                <h2>Doanh thu 7 ngày gần nhất</h2>
                <div class="chart-container">
                    <%-- Canvas để Chart.js vẽ biểu đồ --%>
                    <canvas id="revenueChart"></canvas>
                </div>
            </section>

        </main>
    </div>

    <script>
        // Lấy dữ liệu JSON từ request attribute mà controller đã gửi sang
        const chartLabels = JSON.parse('${chartLabels}'); 
        const chartData = JSON.parse('${chartData}');

        const ctx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(ctx, {
            type: 'line', 
            data: {
                // Sử dụng dữ liệu động
                labels: chartLabels, 
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    // Sử dụng dữ liệu động
                    data: chartData, 
                    borderColor: 'rgb(75, 192, 192)',
                    tension: 0.1
                }]
            },
            options: { scales: { y: { beginAtZero: true } } }
        });
    </script>
</body>
</html>