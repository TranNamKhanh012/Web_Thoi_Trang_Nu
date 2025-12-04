package controller;

import dao.QrDAO;
import dao.UserDAO; // DAO lấy thông tin User
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "QrCheckController", urlPatterns = {"/check-qr"})
public class QrCheckController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        QrDAO dao = new QrDAO();
        
        // Kiểm tra trạng thái
        String result = dao.checkStatus(token); // Trả về "PENDING" hoặc "CONFIRMED:5"
        
        if (result.startsWith("CONFIRMED")) {
            // Đã được quét! -> Tự động đăng nhập cho máy tính
            String[] parts = result.split(":");
            int userId = Integer.parseInt(parts[1]);
            
            // Lấy thông tin User từ ID (Bạn cần có hàm này trong UserDAO)
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId); // Giả sử hàm này tồn tại
            
            // Tạo Session
            HttpSession session = request.getSession();
            session.setAttribute("acc", user);
            
            response.getWriter().write("SUCCESS"); // Báo cho JS biết là xong rồi
        } else {
            response.getWriter().write("WAITING"); // Báo JS đợi tiếp
        }
    }
}