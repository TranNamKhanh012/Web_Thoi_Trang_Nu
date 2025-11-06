package controller;

import dao.CategoryDAO;
import dao.UserDAO;
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

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    // Hiển thị trang thông tin
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Bắt buộc đăng nhập
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Lấy thông tin đầy đủ nhất từ DB (vì session có thể cũ)
        User userDetail = userDAO.getUserById(user.getId());
        List<Category> categoryList = categoryDAO.getAllCategories();

        request.setAttribute("userDetail", userDetail);
        request.setAttribute("categoryList", categoryList);

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    // Xử lý cập nhật thông tin
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy thông tin từ form
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Cập nhật vào DB
        UserDAO userDAO = new UserDAO();
        userDAO.updateProfile(user.getId(), fullname, phone, address);

        // Cập nhật lại thông tin trong session (quan trọng!)
        User updatedUser = userDAO.getUserById(user.getId());
        session.setAttribute("acc", updatedUser);

        // Gửi thông báo thành công (dùng toast notification đã có)
        session.setAttribute("successMsg", "Cập nhật thông tin thành công!");

        // Tải lại trang profile
        response.sendRedirect("profile");
    }
}