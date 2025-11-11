package controller;

import dao.OrderDAO;
import entity.Order;
import entity.OrderDetail;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter; // Import
import java.text.NumberFormat; // Import
import java.util.Locale; // Import
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "InvoiceController", urlPatterns = {"/download-invoice"})
public class InvoiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        String orderId_raw = request.getParameter("orderId");

        // Bắt buộc đăng nhập
        if (user == null || orderId_raw == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderId_raw);
            OrderDAO orderDAO = new OrderDAO();
            
            // Lấy đơn hàng và kiểm tra xem nó có thuộc về user này không
            Order order = orderDAO.getOrderByIdAndUser(orderId, user.getId());

            if (order == null) {
                // Nếu đơn hàng không tồn tại hoặc không phải của user này
                response.sendRedirect("order-history"); // Quay về lịch sử
                return;
            }

            // --- TẠO FILE .TXT ---
            
            // 1. Thiết lập Header cho Response
            response.setContentType("text/plain"); // Kiểu file là text
            response.setCharacterEncoding("UTF-8"); // Hỗ trợ Tiếng Việt
            response.setHeader("Content-Disposition", "attachment; filename=\"hoadon_" + orderId + ".txt\""); // Tên file tải về

            // Dùng NumberFormat để định dạng tiền tệ
            Locale localeVN = new Locale("vi", "VN");
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);

            // 2. Ghi nội dung vào file
            try (PrintWriter out = response.getWriter()) {
                out.println("     HOA DON BAN HANG");
                out.println("---------------------------------");
                out.println("Ma don hang: #" + order.getId());
                out.println("Ngay dat: " + order.getOrderDate());
                out.println("Khach hang: " + user.getFullname()); // Lấy từ session hoặc order
                out.println("Email: " + user.getEmail());
                out.println("Dia chi giao hang: " + order.getShippingAddress());
                out.println("Trang thai: " + order.getStatus());
                out.println("---------------------------------");
                out.println("CHI TIET SAN PHAM:");
                out.println();

                for (OrderDetail item : order.getDetails()) {
                    out.println("Ten SP: " + item.getProductName());
                    out.println("Size: " + item.getSize());
                    out.println("So luong: " + item.getQuantity());
                    out.println("Don gia: " + currencyFormatter.format(item.getPriceAtPurchase()));
                    out.println("---");
                }

                out.println("---------------------------------");
                out.println("TONG TIEN: " + currencyFormatter.format(order.getTotalMoney()));
                out.println("---------------------------------");
                out.println("Cam on ban da mua hang!");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("order-history");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}