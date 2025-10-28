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

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Lấy category ID từ URL (parameter ?cid=...)
        String categoryId_raw = request.getParameter("cid");
        int categoryId = 0;
        try {
            if (categoryId_raw != null) {
                categoryId = Integer.parseInt(categoryId_raw);
            }
        } catch (NumberFormatException e) {
            System.out.println(e);
        }
        String sortBy = request.getParameter("sort"); // Ví dụ: sort=price
        String sortOrder = request.getParameter("order"); // Ví dụ: order=asc

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        List<Product> productList;
        // Dựa vào categoryId để gọi DAO tương ứng
        if (categoryId == 0) {
            // Nếu không có cid, lấy tất cả sản phẩm
            productList = productDAO.getAllProducts();
        } else {
            // Nếu có cid, lọc sản phẩm theo category
            productList = productDAO.getProductsByCategoryId(categoryId);
        }
        
        // Lấy danh sách tất cả các category để hiển thị ở sidebar
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        // Gửi dữ liệu lên trang JSP
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activeCid", categoryId); // Gửi cid đang active để tô đậm link

        request.setAttribute("activePage", "products");
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}