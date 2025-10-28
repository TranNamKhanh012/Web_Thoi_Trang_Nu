package controller;

import dao.OrderDAO;
import entity.Cart;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    // Hiển thị trang checkout
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Bắt buộc phải đăng nhập để vào trang checkout
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    // Xử lý khi người dùng "Đặt hàng"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null || cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("home"); // Không cho phép đặt hàng nếu chưa đăng nhập hoặc giỏ rỗng
            return;
        }

        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.createOrder(user, cart, address, phone);

        if (orderId != -1) {
            // Nếu tạo đơn hàng thành công, xóa giỏ hàng cũ và chuyển đến trang thanh toán ảo
            session.removeAttribute("cart");
            response.sendRedirect("payment.jsp?orderId=" + orderId + "&total=" + cart.getTotalMoney());
        } else {
            // Nếu có lỗi, quay lại giỏ hàng
            response.sendRedirect("cart");
        }
    }
}