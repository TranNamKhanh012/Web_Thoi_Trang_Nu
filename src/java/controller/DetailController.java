package controller;

import dao.ProductDAO;
import dao.ProductSizeDAO;
import entity.Product;
import entity.ProductSize;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PromotionService; // Import Service mới

@WebServlet(name = "DetailController", urlPatterns = {"/detail"})
public class DetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            int productId = Integer.parseInt(request.getParameter("pid"));
            
            ProductDAO productDAO = new ProductDAO();
            ProductSizeDAO sizeDAO = new ProductSizeDAO(); 

            // 1. Lấy sản phẩm chính
            Product product = productDAO.getProductById(productId);

            // === KIỂM TRA NULL (QUAN TRỌNG) ===
            if (product == null) {
                // Nếu không tìm thấy sản phẩm, chuyển về trang chủ
                response.sendRedirect("home");
                return;
            }

            // === LOGIC KHUYẾN MÃI TỰ ĐỘNG (DÙNG SERVICE) ===
            // Kiểm tra xem có khuyến mãi không dựa trên cấu hình Admin
            boolean isSpecialDay = PromotionService.isPromotionActive();
            
            if (isSpecialDay) {
                // Lấy % giảm giá từ cấu hình
                double discountRate = PromotionService.getDiscountRate();
                
                // Lấy giá hiện tại (ưu tiên giá sale nếu có, nếu không lấy giá gốc)
                double currentPrice = product.getSalePrice() > 0 ? product.getSalePrice() : product.getOriginalPrice();
                
                // Tính giá mới sau khi giảm thêm
                double newSalePrice = currentPrice * (1.0 - discountRate);
                
                // Ghi đè giá sale để hiển thị
                product.setSalePrice(newSalePrice);
            }
            request.setAttribute("isSpecialDay", isSpecialDay);
            // ===============================================

            // 2. Lấy danh sách size
            List<ProductSize> sizeList = sizeDAO.getSizesByProductId(productId);
            
            // 3. Lấy sản phẩm liên quan
            List<Product> relatedProducts = productDAO.getRelatedProducts(
                    product.getCategoryId(), 
                    product.getId()
            );

            // 4. Gửi dữ liệu sang JSP
            request.setAttribute("productDetail", product);
            request.setAttribute("sizeList", sizeList);
            request.setAttribute("relatedProducts", relatedProducts);
            
            request.getRequestDispatcher("detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}