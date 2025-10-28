package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductSizeDAO;
import entity.Category;
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
            CategoryDAO categoryDAO = new CategoryDAO();
            ProductSizeDAO sizeDAO = new ProductSizeDAO(); // KHỞI TẠO DAO MỚI

            Product product = productDAO.getProductById(productId);
            List<Category> categoryList = categoryDAO.getAllCategories();
            List<ProductSize> sizeList = sizeDAO.getSizesByProductId(productId); // LẤY SIZE

            request.setAttribute("productDetail", product);
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("sizeList", sizeList); // GỬI SIZE SANG JSP
            
            request.getRequestDispatcher("detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Xử lý trường hợp 'pid' không phải là số
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}