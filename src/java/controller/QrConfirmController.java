package controller;

import dao.QrDAO;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "QrConfirmController", urlPatterns = {"/confirm-qr"})
public class QrConfirmController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra xem điện thoại đã đăng nhập chưa
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        
        if (user == null) {
            // Nếu điện thoại chưa đăng nhập, bắt đăng nhập trước
            response.sendRedirect("login.jsp"); 
            return;
        }
        
        // 2. Lấy token từ URL (do mã QR truyền vào)
        String token = request.getParameter("token");
        
        // 3. Xác nhận vào DB
        QrDAO dao = new QrDAO();
        dao.confirmToken(token, user.getId());
        
        // 4. Thông báo cho điện thoại
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print("<h1>Đăng nhập thành công!</h1><p>Máy tính của bạn sẽ tự động chuyển trang.</p>");
    }
}