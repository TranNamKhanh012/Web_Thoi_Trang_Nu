package controller;

import dao.CategoryDAO;
import dao.FeedbackDAO; // Thêm import
import entity.Category;
import entity.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ContactController", urlPatterns = {"/contact"})
public class ContactController extends HttpServlet {

    // Xử lý hiển thị trang (GET)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Lấy danh mục cho header
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activePage", "contact"); // Đánh dấu trang active

        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }

    // Xử lý gửi form (POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đọc Tiếng Việt

        // 1. Kiểm tra xem người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            // Nếu chưa, đẩy về trang đăng nhập
            response.sendRedirect("login");
            return;
        }

        // 2. Lấy dữ liệu từ form (Không cần lấy name/email nữa)
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        int userId = user.getId(); // Lấy ID từ session

        // 3. Lưu vào CSDL
        FeedbackDAO dao = new FeedbackDAO();
        dao.insertFeedback(userId, subject, message);

        // 4. Thông báo thành công và chuyển hướng
        request.setAttribute("successMsg", "Cảm ơn bạn đã gửi phản hồi! Chúng tôi sẽ xem xét sớm.");
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }
}