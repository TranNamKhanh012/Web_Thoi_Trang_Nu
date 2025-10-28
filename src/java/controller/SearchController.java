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

@WebServlet(name = "SearchController", urlPatterns = {"/search"})
public class SearchController extends HttpServlet {

    // Sử dụng doPost để xử lý Tiếng Việt (UTF-8)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String keyword = request.getParameter("keyword");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        // Lấy danh sách sản phẩm tìm được
        List<Product> productList = productDAO.searchByName(keyword);
        
        // Lấy danh sách category cho header
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        // Gửi dữ liệu sang trang search.jsp
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("searchKeyword", keyword); // Gửi cả từ khóa để hiển thị
        
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }
}