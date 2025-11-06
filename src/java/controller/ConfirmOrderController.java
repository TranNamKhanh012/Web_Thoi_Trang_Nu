package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import entity.Cart;
import entity.Order; // Cần import
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ConfirmOrderController", urlPatterns = {"/confirm-order"})
public class ConfirmOrderController extends HttpServlet {

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

            // --- THỰC HIỆN LOGIC MÀ IPN LẼ RA SẼ LÀM ---
            
            // 1. Cập nhật trạng thái đơn hàng thành 'completed'
            orderDAO.updateOrderStatus(orderId, "completed");

            // 2. TRỪ SỐ LƯỢNG TRONG KHO
            productDAO.updateStockAfterOrder(orderId);

            // 3. XÓA GIỎ HÀNG TRONG CSDL
            cartDAO.clearCartByUserId(user.getId());
            
            // 4. Cập nhật lại giỏ hàng rỗng trong session
            session.setAttribute("cart", new Cart());
            
            System.out.println("DEBUG (Manual Confirm): Đã trừ kho và xóa giỏ cho Order ID: " + orderId);

            // Chuyển về trang Lịch sử mua hàng (hoặc trang chủ)
            response.sendRedirect("order-history");

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