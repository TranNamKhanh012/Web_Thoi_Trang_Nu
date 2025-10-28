package controller;

import dao.UserDAO;
import entity.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");

    HttpSession session = request.getSession();
    User adminUser = (User) session.getAttribute("acc");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    UserDAO userDAO = new UserDAO();
    String action = request.getParameter("action");
    String id_raw = request.getParameter("uid");
    int id = -1;
    if (id_raw != null) { try { id = Integer.parseInt(id_raw); } catch (NumberFormatException e) {} }

    String keyword = request.getParameter("keyword"); // Lấy từ khóa tìm kiếm

    String forwardPage = "/admin/user_list.jsp";
    request.setAttribute("activePage", "users");

    // Xử lý các action (giữ nguyên logic cũ)
    if (action != null) {
        // ... (switch case cho add, edit, save, delete giữ nguyên) ...
         switch (action) {
            case "add":
                request.setAttribute("userToEdit", new User());
                forwardPage = "/admin/user_form.jsp";
                break;
            case "edit":
                if (id != -1) {
                    User userToEdit = userDAO.getUserById(id);
                    if (userToEdit != null) {
                        request.setAttribute("userToEdit", userToEdit);
                        forwardPage = "/admin/user_form.jsp";
                    } else {
                        session.setAttribute("adminErrorMsg", "Không tìm thấy người dùng với ID=" + id);
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                        return;
                    }
                } else {
                    session.setAttribute("adminErrorMsg", "ID người dùng không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
                break;
            case "save":
                 // ... (logic save giữ nguyên) ...
                 String fullname = request.getParameter("fullname");
                 String email = request.getParameter("email");
                 String phone = request.getParameter("phone");
                 String address = request.getParameter("address");
                 String role = request.getParameter("role");
                 String password = request.getParameter("password");

                 boolean hasError = false;
                 String errorMessage = null;
                 // ... (kiểm tra lỗi giữ nguyên) ...
                 if (fullname == null || fullname.trim().isEmpty() || email == null || email.trim().isEmpty() || role == null || role.isEmpty()) { hasError = true; errorMessage = "Vui lòng điền đầy đủ các trường bắt buộc (*)."; }

                 if (id != -1 && !hasError) { // Chỉ còn phần cập nhật
                     userDAO.updateUser(id, fullname.trim(), email.trim(), phone, address, role);
                     if (password != null && !password.isEmpty()) { userDAO.updateUserPassword(id, password); }
                     session.setAttribute("adminSuccessMsg", "Cập nhật thông tin người dùng thành công!");
                     response.sendRedirect(request.getContextPath() + "/admin/users"); return;
                 } else if (hasError) {
                     request.setAttribute("formError", errorMessage);
                     User tempUser = new User(); tempUser.setId(id); tempUser.setFullname(fullname); tempUser.setEmail(email); tempUser.setPhoneNumber(phone); tempUser.setAddress(address); tempUser.setRole(role);
                     request.setAttribute("userToEdit", tempUser);
                     forwardPage = "/admin/user_form.jsp";
                 }
                break; // Kết thúc case "save"
            case "delete":
                if (id != -1 && adminUser.getId() != id) {
                    userDAO.deleteUser(id);
                    session.setAttribute("adminSuccessMsg", "Xóa người dùng thành công!");
                } else if (adminUser.getId() == id) {
                    session.setAttribute("adminErrorMsg", "Không thể tự xóa tài khoản admin đang đăng nhập!");
                } else {
                     session.setAttribute("adminErrorMsg", "ID người dùng không hợp lệ để xóa!");
                }
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            default: // Nếu action không hợp lệ, thì hiển thị danh sách
                 List<User> userList;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    userList = userDAO.searchUsers(keyword.trim());
                    request.setAttribute("searchKeyword", keyword); // Gửi lại keyword để hiển thị
                } else {
                    userList = userDAO.getAllUsers();
                }
                request.setAttribute("userList", userList);
                break; // Thoát switch
        }

    } else {
        // Mặc định HOẶC KHI CÓ TÌM KIẾM (không có action cụ thể)
        List<User> userList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Nếu có keyword, thực hiện tìm kiếm
            userList = userDAO.searchUsers(keyword.trim());
            request.setAttribute("searchKeyword", keyword); // Gửi lại keyword để hiển thị trong ô input
        } else {
            // Nếu không có keyword, lấy tất cả
            userList = userDAO.getAllUsers();
        }
        request.setAttribute("userList", userList);
    }

    // Forward đến trang JSP tương ứng
    request.getRequestDispatcher(forwardPage).forward(request, response);
}

    // doGet và doPost vẫn giữ nguyên, gọi processRequest
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}