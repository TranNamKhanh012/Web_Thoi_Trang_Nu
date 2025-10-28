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