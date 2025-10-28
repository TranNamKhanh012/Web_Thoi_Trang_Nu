package controller;

import com.google.gson.Gson;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.ProductSizeDAO;
import dao.UserDAO;
import entity.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin"})
public class AdminDashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        // Kiểm tra admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }

        try { // Thêm try-catch để bắt lỗi nếu có
            // Khởi tạo các DAO
            ProductDAO productDAO = new ProductDAO();
            OrderDAO orderDAO = new OrderDAO();
            UserDAO userDAO = new UserDAO();
            ProductSizeDAO sizeDAO = new ProductSizeDAO();

            // Lấy dữ liệu thống kê
            int totalProducts = productDAO.countTotalProducts();
            int totalSold = productDAO.sumTotalSoldQuantity();
            int totalStock = sizeDAO.sumTotalStock();
            int newOrders = orderDAO.countNewOrders();
            int totalUsers = userDAO.countTotalUsers();
            double revenueToday = orderDAO.calculateRevenueToday();
            double revenueWeek = orderDAO.calculateRevenueThisWeek();
            double revenueMonth = orderDAO.calculateRevenueThisMonth();
            Map<String, Double> revenueLast7Days = orderDAO.getRevenueLast7Days();
            List<String> chartLabels = new ArrayList<>(revenueLast7Days.keySet());
            List<Double> chartData = new ArrayList<>(revenueLast7Days.values());

            // Gửi dữ liệu sang JSP
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalSold", totalSold);
            request.setAttribute("totalStock", totalStock);
            request.setAttribute("newOrders", newOrders);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("revenueToday", revenueToday);
            request.setAttribute("revenueWeek", revenueWeek);
            request.setAttribute("revenueMonth", revenueMonth);
            // Đảm bảo Gson đã được thêm vào Libraries
            request.setAttribute("chartLabels", new Gson().toJson(chartLabels));
            request.setAttribute("chartData", new Gson().toJson(chartData));

            request.getRequestDispatcher("admin/admin_dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            // In lỗi ra console để debug
            e.printStackTrace();
            // Có thể chuyển hướng đến trang lỗi hoặc trang chủ
            // response.sendRedirect("errorPage.jsp");
            throw new ServletException("Error fetching dashboard data", e); // Ném lỗi để Tomcat ghi log
        }
    }

    // === PHẦN BỊ THIẾU ===
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response); // Gọi processRequest cho GET
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response); // Gọi processRequest cho POST (nếu cần)
    }
    // === KẾT THÚC PHẦN BỊ THIẾU ===

}