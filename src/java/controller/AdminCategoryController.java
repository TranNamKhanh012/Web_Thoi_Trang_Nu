package controller;

import dao.CategoryDAO;
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

@WebServlet(name = "AdminCategoryController", urlPatterns = {"/admin/categories"})
public class AdminCategoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Hỗ trợ Tiếng Việt khi POST
        
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("acc");
        if (adminUser == null || !"admin".equals(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        String action = request.getParameter("action");
        String id_raw = request.getParameter("id");
        String name = request.getParameter("name");
        int id = -1;
        if (id_raw != null) {
            try { id = Integer.parseInt(id_raw); } catch (NumberFormatException e) {}
        }

        // Xử lý các action
        if (action != null) {
            switch (action) {
                case "add":
                    if (name != null && !name.trim().isEmpty()) {
                        categoryDAO.addCategory(name.trim());
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                case "delete":
                    if (id != -1) {
                        categoryDAO.deleteCategory(id);
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                case "edit": // Hiển thị form sửa
                    if (id != -1) {
                        Category categoryToEdit = categoryDAO.getCategoryById(id);
                        request.setAttribute("categoryToEdit", categoryToEdit);
                    }
                    break; // Không redirect, để forward đến JSP hiển thị form
                case "update": // Xử lý cập nhật từ form sửa
                    if (id != -1 && name != null && !name.trim().isEmpty()) {
                        categoryDAO.updateCategory(id, name.trim());
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
            }
        }
        
        // Mặc định: Hiển thị danh sách
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activePage", "categories"); // Đánh dấu trang active
        request.getRequestDispatcher("category_list.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response); // Dùng chung processRequest cho cả GET và POST
    }
}