package controller;

import dao.ProductDAO;
import dao.OrderDAO;
import dao.UserDAO; // Đã thêm
import entity.CartItem; // Đã thêm
import entity.Order;
import entity.OrderDetail; // Đã thêm
import entity.Product; // Đã thêm
import entity.User;
import java.io.IOException;
import java.util.ArrayList; // Đã thêm
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
        String orderId_raw = request.getParameter("oid"); // Tên param của bạn là 'oid'
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
        
        // Xử lý XEM CHI TIẾT
        if (action != null && action.equals("view") && orderId_raw != null) {
             try {
                int orderId = Integer.parseInt(orderId_raw);
                UserDAO userDAO = new UserDAO();
                ProductDAO productDAO = new ProductDAO();

                // 1. Lấy thông tin đơn hàng chính
                Order order = orderDAO.getOrderById(orderId); 
                
                // === SỬA LỖI 1: KIỂM TRA ĐƠN HÀNG NULL ===
                if (order == null) {
                    session.setAttribute("errorMsg", "Không tìm thấy đơn hàng có ID = " + orderId);
                    response.sendRedirect(request.getContextPath() + "/admin/orders");
                    return;
                }
                // =======================================

                // 2. Lấy thông tin khách hàng
                User customer = userDAO.getUserById(order.getUserId()); 
                
                // 3. Lấy danh sách chi tiết sản phẩm
                List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId); 
                
                // 4. Chuyển đổi sang List<CartItem>
                List<CartItem> orderItems = new ArrayList<>();
                for (OrderDetail od : details) {
                    
                    // Chú ý: Dòng này gọi hàm getProductById(int)
                    Product p = productDAO.getProductById(od.getProductId()); 
                    
                    // === SỬA LỖI 2 (DÒNG 101): KIỂM TRA SẢN PHẨM NULL ===
                    if (p == null) {
                        // Nếu sản phẩm đã bị xóa, tạo một sản phẩm "giả" để hiển thị
                        p = new Product();
                        p.setId(od.getProductId());
                        p.setName("[Sản phẩm đã bị xóa]");
                        p.setImageUrl("images/placeholder.jpg"); // Cần có ảnh placeholder
                        p.setSalePrice(od.getPriceAtPurchase()); // Lấy giá lúc mua
                    }
                    // ==============================================
                    
                    CartItem item = new CartItem(p, od.getQuantity(), od.getSize());
                    
                    // Ghi đè giá (chỉ khi sản phẩm không phải là "giả")
                    if (!"[Sản phẩm đã bị xóa]".equals(p.getName())) {
                         item.getProduct().setSalePrice(od.getPriceAtPurchase()); 
                    }
                    
                    orderItems.add(item);
                }
                
                // 5. Gửi tất cả dữ liệu sang JSP
                request.setAttribute("order", order);
                request.setAttribute("customer", customer);
                request.setAttribute("orderItems", orderItems);
                
                // 6. Forward sang trang detail
                request.setAttribute("activePage", "orders"); 
                request.getRequestDispatcher("order_detail.jsp").forward(request, response);
                return; // Dừng lại để forward

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Lỗi khi tải chi tiết đơn hàng: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
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
        processRequest(request, response);
    }
}