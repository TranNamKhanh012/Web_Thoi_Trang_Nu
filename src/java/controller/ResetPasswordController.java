package controller;

import dao.UserDAO;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByResetToken(token); // Kiểm tra token có hợp lệ không

        if (user == null) {
            request.setAttribute("error", "Mã khôi phục không hợp lệ hoặc đã hết hạn.");
        }
        // Luôn chuyển đến trang reset, nhưng có thể kèm thông báo lỗi
        request.setAttribute("token", token); // Gửi token sang JSP để dùng trong form
        request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByResetToken(token);

        if (user == null) {
            request.setAttribute("error", "Mã khôi phục không hợp lệ hoặc đã hết hạn.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu mới và xóa token
        userDAO.updatePasswordAndClearToken(user.getId(), newPassword);

        // Chuyển hướng về trang đăng nhập với thông báo thành công
        request.getSession().setAttribute("successMsg", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
        response.sendRedirect("login");
    }
}