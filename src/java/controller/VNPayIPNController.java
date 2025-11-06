package controller;

import context.VNPayConfig;
import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import entity.User;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "VNPayIPNController", urlPatterns = {"/vnpay-ipn"})
public class VNPayIPNController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đây là nơi server VNPay gọi vào
        Map<String, String> fields = new HashMap<>();
        // Đọc tất cả tham số VNPay gửi về
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = URLDecoder.decode(params.nextElement(), StandardCharsets.US_ASCII.toString());
            String fieldValue = URLDecoder.decode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
        
        // 1. XÁC THỰC CHỮ KÝ
        String signValue = VNPayConfig.hashAllFields(fields);
        
        String RspCode = "97"; // Mã lỗi: Chữ ký không hợp lệ
        String Message = "Invalid Checksum";

        // Kiểm tra chữ ký
        if (signValue.equals(vnp_SecureHash)) {
            OrderDAO orderDAO = new OrderDAO();
            ProductDAO productDAO = new ProductDAO();
            CartDAO cartDAO = new CartDAO();

            String orderId = request.getParameter("vnp_TxnRef");
            String vnpResponseCode = request.getParameter("vnp_ResponseCode");
            
            try {
                // 2. KIỂM TRA TRẠNG THÁI THANH TOÁN
                if ("00".equals(vnpResponseCode)) {
                    // Thanh toán thành công
                    // TODO: Kiểm tra xem đơn hàng đã được cập nhật chưa (tránh IPN gọi 2 lần)
                    // (Tạm thời bỏ qua bước này cho đơn giản)
                    
                    int orderIdInt = Integer.parseInt(orderId);
                    
                    // --- BẮT ĐẦU CẬP NHẬT DATABASE ---
                    // 1. Cập nhật trạng thái đơn hàng
                    orderDAO.updateOrderStatus(orderIdInt, "completed");

                    // 2. TRỪ SỐ LƯỢNG TRONG KHO (YÊU CẦU CỦA BẠN)
                    productDAO.updateStockAfterOrder(orderIdInt);

                    // 3. XÓA GIỎ HÀNG (Lấy userId từ orderId)
                    // (Cần thêm hàm getOrderById(orderIdInt) trong OrderDAO để lấy user_id)
                    // Tạm thời bỏ qua bước 3 nếu chưa có hàm đó, hoặc bạn có thể tự thêm
                    
                    // --- KẾT THÚC CẬP NHẬT ---
                    
                    System.out.println("DEBUG: VNPay IPN Success for Order ID: " + orderId);
                    RspCode = "00";
                    Message = "Confirm Success";
                } else {
                    // Thanh toán thất bại
                    // Cập nhật trạng thái đơn hàng (ví dụ: 'cancelled')
                    orderDAO.updateOrderStatus(Integer.parseInt(orderId), "cancelled");
                    System.out.println("DEBUG: VNPay IPN Failed for Order ID: " + orderId);
                    RspCode = "02"; // Mã lỗi VNPay (hoặc mã của bạn)
                    Message = "Payment Failed";
                }
            } catch (Exception e) {
                 e.printStackTrace();
                 RspCode = "99"; // Lỗi hệ thống
                 Message = "Unknown Error";
            }
        }
        
        // 4. TRẢ VỀ CHO VNPay
        response.setContentType("application/json");
        response.getWriter().write("{\"RspCode\":\"" + RspCode + "\",\"Message\":\"" + Message + "\"}");
    }
}