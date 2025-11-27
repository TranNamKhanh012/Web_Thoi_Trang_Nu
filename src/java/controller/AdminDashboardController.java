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

        try {
            // Khởi tạo các DAO
            ProductDAO productDAO = new ProductDAO();
            OrderDAO orderDAO = new OrderDAO();
            UserDAO userDAO = new UserDAO();
            ProductSizeDAO sizeDAO = new ProductSizeDAO();

            // 1. Lấy các số liệu thống kê cơ bản
            int totalProducts = productDAO.countTotalProducts();
            int totalSold = productDAO.sumTotalSoldQuantity();
            int totalStock = sizeDAO.sumTotalStock();
            int newOrders = orderDAO.countNewOrders();
            int totalUsers = userDAO.countTotalUsers();

            // 2. Lấy số liệu doanh thu
            double revenueToday = orderDAO.calculateRevenueToday();
            double revenueWeek = orderDAO.calculateRevenueThisWeek();
            double revenueMonth = orderDAO.calculateRevenueThisMonth();
            
            // --- THAY ĐỔI: LẤY DOANH THU NĂM ---
            double revenueYear = orderDAO.calculateRevenueThisYear(); 
            double revenueTotal = orderDAO.calculateTotalRevenue(); 

            // 3. --- TÍNH THUẾ THEO LUẬT VIỆT NAM (1.5%) ---
            // Thuế khoán cho hộ kinh doanh: 1% GTGT + 0.5% TNCN = 1.5%
            double taxRate = 0.015; 
            // SỬA: Tính trên doanh thu NĂM nay
            double estimatedTaxYear = revenueYear * taxRate; 
            double estimatedTaxTotal = revenueTotal * taxRate;

            // 4. Lấy dữ liệu biểu đồ
            Map<String, Double> revenueLast7Days = orderDAO.getRevenueLast7Days();
            List<String> chartLabels = new ArrayList<>(revenueLast7Days.keySet());
            List<Double> chartData = new ArrayList<>(revenueLast7Days.values());

            // 5. Gửi dữ liệu sang JSP
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalSold", totalSold);
            request.setAttribute("totalStock", totalStock);
            request.setAttribute("newOrders", newOrders);
            request.setAttribute("totalUsers", totalUsers);
            
            request.setAttribute("revenueToday", revenueToday);
            request.setAttribute("revenueWeek", revenueWeek);
            request.setAttribute("revenueMonth", revenueMonth);
            request.setAttribute("revenueTotal", revenueTotal); // Gửi thêm tổng doanh thu

            // Gửi dữ liệu thuế
            request.setAttribute("revenueYear", revenueYear); 
            request.setAttribute("revenueTotal", revenueTotal);
            request.setAttribute("estimatedTaxYear", estimatedTaxYear); // Thuế năm nay
            request.setAttribute("estimatedTaxTotal", estimatedTaxTotal);

            request.setAttribute("chartLabels", new Gson().toJson(chartLabels));
            request.setAttribute("chartData", new Gson().toJson(chartData));

            request.getRequestDispatcher("admin/admin_dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error fetching dashboard data", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}