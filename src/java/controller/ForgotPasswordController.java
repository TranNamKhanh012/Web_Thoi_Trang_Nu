package controller;

import dao.UserDAO;
import entity.User;
import java.io.IOException;
import java.util.UUID; // Dùng để tạo token ngẫu nhiên
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        } else {
            // Tạo token ngẫu nhiên
            String token = UUID.randomUUID().toString();
            userDAO.updateResetToken(email, token);

            // *** MÔ PHỎNG GỬI EMAIL ***
            // Thay vì gửi email, chúng ta hiển thị token và link đặt lại mật khẩu
            String resetLink = request.getContextPath() + "/reset-password?token=" + token;
            request.setAttribute("message", "Yêu cầu thành công! Mã khôi phục của bạn là:");
            request.setAttribute("token", token); // Hiển thị token
            request.setAttribute("resetLink", resetLink); // Hiển thị link (để test)

            System.out.println("DEBUG: Reset token for " + email + " is: " + token); // In ra console
            System.out.println("DEBUG: Reset link: " + resetLink);

            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}