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

@WebServlet(name = "PromotionController", urlPatterns = {"/promotions"})
public class PromotionController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Lấy danh sách sản phẩm giảm giá
        List<Product> saleProductList = productDAO.getOnSaleProducts();

        // Lấy danh mục cho header
        List<Category> categoryList = categoryDAO.getAllCategories();

        // Gửi dữ liệu sang JSP
        request.setAttribute("saleProductList", saleProductList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activePage", "promo"); // Đánh dấu trang active

        request.getRequestDispatcher("promotions.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}