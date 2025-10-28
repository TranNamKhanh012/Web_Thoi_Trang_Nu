package controller;

import dao.CartDAO;
import dao.UserDAO;
import entity.Cart;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển đến trang login.jsp khi người dùng truy cập /login
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkLogin(email, pass);
        
        if (user == null) {
            // Đăng nhập thất bại
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Đăng nhập thành công, lưu thông tin vào session
            HttpSession session = request.getSession();
            // --- LOGIC MỚI: GỘP VÀ TẢI GIỎ HÀNG ---
            CartDAO cartDAO = new CartDAO();
            Cart sessionCart = (Cart) session.getAttribute("cart");
            
            // 1. Gộp giỏ hàng Guest (nếu có) vào giỏ hàng DB
            cartDAO.mergeSessionCartToDb(sessionCart, user.getId());
            
            // 2. Tải giỏ hàng từ DB lên session
            Cart dbCart = cartDAO.getCartByUserId(user.getId());
            session.setAttribute("cart", dbCart);
            session.setAttribute("acc", user);
            response.sendRedirect("home");
        }
    }
}