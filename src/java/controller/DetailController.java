package controller;

// import dao.CategoryDAO; // Không cần thiết trong logic mới
import dao.ProductDAO;
import dao.ProductSizeDAO;
// import entity.Category; // Không cần thiết
import entity.Product;
import entity.ProductSize;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

            // === SỬA LỖI QUAN TRỌNG: KIỂM TRA NULL ===
            if (product == null) {
                // Nếu không tìm thấy sản phẩm (pid không hợp lệ), chuyển về trang chủ
                response.sendRedirect("home");
                return; // Dừng thực thi
            }
            // =======================================

            // 2. Lấy danh sách size
            List<ProductSize> sizeList = sizeDAO.getSizesByProductId(productId);
            
            // 3. THÊM MỚI: LẤY SẢN PHẨM LIÊN QUAN
            // (Sử dụng hàm getRelatedProducts bạn đã thêm vào ProductDAO)
            List<Product> relatedProducts = productDAO.getRelatedProducts(
                    product.getCategoryId(), // Lấy ID danh mục từ sản phẩm
                    product.getId()          // Lấy ID sản phẩm hiện tại để loại trừ
            );

            // 4. Gửi tất cả dữ liệu sang JSP
            request.setAttribute("productDetail", product);
            request.setAttribute("sizeList", sizeList);
            request.setAttribute("relatedProducts", relatedProducts); // Gửi danh sách liên quan
            
            request.getRequestDispatcher("detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Xử lý trường hợp 'pid' không phải là số (ví dụ: detail?pid=abc)
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}