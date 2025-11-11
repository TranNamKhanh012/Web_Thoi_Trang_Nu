package controller;

import dao.OrderDAO;
import entity.Order;
import entity.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders"})
public class AdminOrderController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("acc");
        // Kiểm tra quyền admin
        if (adminUser == null || !"admin".equals(adminUser.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        String action = request.getParameter("action");
        String orderId_raw = request.getParameter("oid");
        String newStatus = request.getParameter("status");

        // Xử lý CẬP NHẬT TRẠNG THÁI
        if (action != null && action.equals("update_status") && orderId_raw != null && newStatus != null) {
            try {
                int orderId = Integer.parseInt(orderId_raw);
                orderDAO.updateOrderStatus(orderId, newStatus);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders"); // Tải lại trang
            return; 
        }
        
        // Mặc định: Hiển thị danh sách đơn hàng
        List<Order> orderList = orderDAO.getAllOrders();
        request.setAttribute("orderList", orderList);
        request.setAttribute("activePage", "orders");
        request.getRequestDispatcher("order_list.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể dùng doPost để xử lý tìm kiếm/lọc sau này
        processRequest(request, response);
    }
}