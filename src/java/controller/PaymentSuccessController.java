package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import entity.Cart;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PaymentSuccessController", urlPatterns = {"/payment-success"})
public class PaymentSuccessController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        String orderId_raw = request.getParameter("orderId");

        if (user == null || orderId_raw == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderId_raw);
            
            OrderDAO orderDAO = new OrderDAO();
            ProductDAO productDAO = new ProductDAO();
            CartDAO cartDAO = new CartDAO();

            // 1. Cập nhật trạng thái đơn hàng thành 'completed'
            orderDAO.updateOrderStatus(orderId, "completed");

            // 2. Cập nhật số lượng tồn kho và đã bán (SỬA VẤN ĐỀ 2)
            productDAO.updateStockAfterOrder(orderId);

            // 3. Xóa giỏ hàng trong CSDL của user (SỬA VẤN ĐỀ 1)
            cartDAO.clearCartByUserId(user.getId());

            // 4. Cập nhật lại giỏ hàng rỗng trong session
            session.setAttribute("cart", new Cart());

            // Chuyển về trang chủ (hoặc trang cảm ơn)
            response.sendRedirect("home");

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