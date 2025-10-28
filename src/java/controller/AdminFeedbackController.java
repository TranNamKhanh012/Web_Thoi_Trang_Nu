package controller;

import dao.FeedbackDAO;
import entity.Feedback;
import entity.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminFeedbackController", urlPatterns = {"/admin/feedback"})
public class AdminFeedbackController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("acc");
        if (adminUser == null || !"admin".equals(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        String action = request.getParameter("action");
        String id_raw = request.getParameter("id");
        String status = request.getParameter("status");

        // Xử lý cập nhật trạng thái (ví dụ: đánh dấu là đã đọc)
        if ("update_status".equals(action) && id_raw != null && status != null) {
            try {
                int id = Integer.parseInt(id_raw);
                feedbackDAO.updateFeedbackStatus(id, status);
            } catch (NumberFormatException e) { e.printStackTrace(); }
            response.sendRedirect(request.getContextPath() + "/admin/feedback"); // Tải lại trang
            return;
        }

        // Mặc định: Hiển thị danh sách
        List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("activePage", "feedback"); // Đánh dấu sidebar

        request.getRequestDispatcher("/admin/feedback_list.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response); // POST cũng có thể dùng để cập nhật status
    }
}