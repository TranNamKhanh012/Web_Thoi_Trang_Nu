package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import entity.Category;
import entity.Product;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.DayOfWeek;
import java.time.LocalDate;
import service.PromotionService;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // 1. Lấy Top Bán Chạy
        List<Product> topSellingProducts = productDAO.getTopSellingProducts(8);

        // 2. Lấy danh sách Category
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        // 3. Lấy sản phẩm Mới nhất
        List<Product> latestProducts = productDAO.getLatestProducts(8);

        // 2. === LOGIC KHUYẾN MÃI TỰ ĐỘNG (ADMIN CẤU HÌNH) ===
        // Gọi Service để kiểm tra xem hôm nay có phải ngày khuyến mãi không
        boolean isSpecialDay = PromotionService.isPromotionActive();
        
        if (isSpecialDay) {
            // Lấy mức giảm giá từ cấu hình (ví dụ 0.15 nếu admin chỉnh 15%)
            double discountRate = PromotionService.getDiscountRate();

            // Áp dụng giảm giá cho list sản phẩm mới
            for (Product p : latestProducts) {
                double currentPrice = p.getSalePrice() > 0 ? p.getSalePrice() : p.getOriginalPrice();
                p.setSalePrice(currentPrice * (1.0 - discountRate));
            }
            // Áp dụng giảm giá cho list sản phẩm bán chạy
            for (Product p : topSellingProducts) {
                double currentPrice = p.getSalePrice() > 0 ? p.getSalePrice() : p.getOriginalPrice();
                p.setSalePrice(currentPrice * (1.0 - discountRate));
            }
        }
        
        // Gửi cờ báo hiệu sang JSP
        request.setAttribute("isSpecialDay", isSpecialDay);
        // ===========================================
        // ĐẶT DỮ LIỆU LÊN REQUEST
        // Dòng này cực kỳ quan trọng, tên "topSellingProducts" phải chính xác
        request.setAttribute("topSellingProducts", topSellingProducts);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("latestProducts", latestProducts);
        
        request.setAttribute("activePage", "home");
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}