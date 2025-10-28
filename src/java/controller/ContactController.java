package controller;

import dao.CategoryDAO;
import dao.FeedbackDAO; // Thêm import
import entity.Category;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

        // Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        String errorMsg = null;
        String successMsg = null;

        // --- VALIDATION ĐƠN GIẢN ---
        if (name == null || name.trim().isEmpty()) {
            errorMsg = "Vui lòng nhập họ tên.";
        } else if (email == null || email.trim().isEmpty() || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) { // Regex kiểm tra email đơn giản
            errorMsg = "Vui lòng nhập địa chỉ email hợp lệ.";
        } else if (message == null || message.trim().isEmpty()) {
            errorMsg = "Vui lòng nhập nội dung tin nhắn.";
        }
        // --- KẾT THÚC VALIDATION ---

        if (errorMsg == null) {
            // Nếu không có lỗi -> Lưu vào DB
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            boolean success = feedbackDAO.addFeedback(name.trim(), email.trim(), subject, message.trim());
            if (success) {
                successMsg = "Gửi phản hồi thành công! Chúng tôi sẽ liên hệ lại với bạn sớm.";
            } else {
                errorMsg = "Đã xảy ra lỗi khi gửi phản hồi. Vui lòng thử lại.";
            }
        }

        // --- Gửi lại thông báo và dữ liệu cũ (nếu lỗi) sang JSP ---
        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("oldName", name);
            request.setAttribute("oldEmail", email);
            request.setAttribute("oldSubject", subject);
            request.setAttribute("oldMessage", message);
        }
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            // Không cần gửi lại dữ liệu cũ nếu thành công
        }

        // --- Lấy lại danh mục cho header ---
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activePage", "contact");

        // --- Forward lại trang contact.jsp để hiển thị thông báo ---
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }
}