package controller;

import dao.ProductDAO;
import entity.Product;
import entity.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminInventoryController", urlPatterns = {"/admin/inventory"})
public class AdminInventoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Kiểm tra quyền Admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        ProductDAO dao = new ProductDAO();
        
        // Lấy danh sách hàng tồn kho lâu ngày
        List<Product> slowMovingProducts = dao.getSlowMovingProducts();
        
        // Tính tổng giá trị tồn kho của đám hàng "ế" này (để Admin biết đang bị chôn bao nhiêu vốn)
        double totalValue = 0;
        for (Product p : slowMovingProducts) {
            // Giá vốn ước tính = Giá gốc * Số lượng tồn
            totalValue += p.getOriginalPrice() * p.getSoldQuantity(); 
        }

        request.setAttribute("productList", slowMovingProducts);
        request.setAttribute("totalSlowValue", totalValue);
        request.setAttribute("activePage", "inventory"); // Để active menu sidebar

        request.getRequestDispatcher("inventory.jsp").forward(request, response);
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