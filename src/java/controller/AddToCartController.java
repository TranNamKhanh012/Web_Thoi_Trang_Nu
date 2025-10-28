package controller;

import dao.CartDAO;
import dao.ProductDAO;
import dao.ProductSizeDAO;
import entity.Cart;
import entity.CartItem;
import entity.Product;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddToCartController", urlPatterns = {"/add-to-cart"})
public class AddToCartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        String size = request.getParameter("size");
        String pid_raw = request.getParameter("pid");
        String quantity_raw = request.getParameter("quantity");
        String action = request.getParameter("action"); // Lấy action từ nút bấm

        // Kiểm tra phải đăng nhập
        if (user == null) {
            session.setAttribute("errorMsg", "Vui lòng đăng nhập để thực hiện!");
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : "home");
            return;
        }

        // Kiểm tra phải chọn size
        if (size == null || size.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng chọn một kích thước!");
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : "home");
            return;
        }

        boolean success = false; // Biến cờ để kiểm tra thành công
        try {
            int productId = Integer.parseInt(pid_raw);
            int quantity = Integer.parseInt(quantity_raw);

            ProductSizeDAO sizeDAO = new ProductSizeDAO();
            int availableStock = sizeDAO.getStockForSize(productId, size);

            if (quantity > availableStock) {
                session.setAttribute("errorMsg", "Rất tiếc, chỉ còn " + availableStock + " sản phẩm cho size này!");
            } else {
                CartDAO cartDAO = new CartDAO();
                cartDAO.addOrUpdateItem(user.getId(), productId, quantity, size);

                Cart dbCart = cartDAO.getCartByUserId(user.getId());
                session.setAttribute("cart", dbCart);

                // Đánh dấu là thành công
                success = true; 
                // Không đặt session thành công ở đây nữa, chỉ cần chuyển hướng
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Đã xảy ra lỗi. Vui lòng thử lại!");
        }

        // KIỂM TRA ACTION VÀ CHUYỂN HƯỚNG
        if (success && "buy_now".equals(action)) {
            // Nếu thành công VÀ bấm nút "MUA NGAY" -> Chuyển đến checkout
            response.sendRedirect("checkout"); 
        } else if (success && "add_to_cart".equals(action)) {
             // Nếu thành công VÀ bấm nút "THÊM VÀO GIỎ" -> Chuyển đến giỏ hàng
            session.setAttribute("successMsg", "Đã thêm sản phẩm vào giỏ hàng!"); // Đặt thông báo ở đây
            response.sendRedirect("cart");
        } else {
            // Nếu thất bại (hết hàng, lỗi...) -> Quay lại trang cũ
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : "home");
        }
    }
}