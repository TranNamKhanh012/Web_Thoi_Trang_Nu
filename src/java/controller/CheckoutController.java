package controller;

import dao.OrderDAO;
import entity.Cart;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import context.VNPayConfig;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    // Hiển thị trang checkout
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Bắt buộc phải đăng nhập để vào trang checkout
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    // Xử lý khi người dùng "Đặt hàng"
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("acc");
    Cart cart = (Cart) session.getAttribute("cart");

    if (user == null || cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect("home");
        return;
    }

    String address = request.getParameter("address");
    String phone = request.getParameter("phone");

    OrderDAO orderDAO = new OrderDAO();
    // 1. TẠO ĐƠN HÀNG TRONG DATABASE (status: 'pending')
    int orderId = orderDAO.createOrder(user, cart, address, phone);

    if (orderId == -1) {
        // Lỗi khi tạo đơn hàng
        response.sendRedirect("cart");
        return;
    }

    // 2. TẠO URL THANH TOÁN VNPay
    
    // Mã tham chiếu giao dịch, gán bằng orderId cho dễ quản lý
    String vnp_TxnRef = String.valueOf(orderId); 
    String vnp_OrderInfo = "Thanh toan don hang #" + orderId;
    String vnp_OrderType = "other"; // Mã danh mục hàng hóa
    String vnp_BankCode = ""; // Để trống để khách chọn ngân hàng
    
    // Tổng số tiền (VNPay yêu cầu * 100 và bỏ phần thập phân)
    long amount = (long) cart.getTotalMoney() * 100;
    
    Map<String, String> vnp_Params = new HashMap<>();
    vnp_Params.put("vnp_Version", "2.1.0");
    vnp_Params.put("vnp_Command", "pay");
    vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
    vnp_Params.put("vnp_Amount", String.valueOf(amount));
    vnp_Params.put("vnp_CurrCode", "VND");
    vnp_Params.put("vnp_BankCode", vnp_BankCode);
    vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
    vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
    vnp_Params.put("vnp_OrderType", vnp_OrderType);
    vnp_Params.put("vnp_Locale", "vn");
    vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
    vnp_Params.put("vnp_IpAddr", VNPayConfig.getIpAddress(request));

    // Thời gian tạo giao dịch
    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
    String vnp_CreateDate = formatter.format(new Date());
    vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

    // Xây dựng chuỗi hash
    List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
    Collections.sort(fieldNames);
    StringBuilder hashData = new StringBuilder();
    StringBuilder query = new StringBuilder();
    Iterator<String> itr = fieldNames.iterator();
    while (itr.hasNext()) {
        String fieldName = itr.next();
        String fieldValue = vnp_Params.get(fieldName);
        if ((fieldValue != null) && (fieldValue.length() > 0)) {
            // Build hash data
            hashData.append(fieldName);
            hashData.append('=');
            hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
            // Build query
            query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
            query.append('=');
            query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
            if (itr.hasNext()) {
                query.append('&');
                hashData.append('&');
            }
        }
    }
    String queryUrl = query.toString();
    String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
    queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
    String paymentUrl = VNPayConfig.vnp_Url + "?" + queryUrl;

    // 3. CHUYỂN HƯỚNG SANG CỔNG THANH TOÁN VNPay
    // Không xóa giỏ hàng ở đây, chỉ xóa sau khi IPN xác nhận
    response.sendRedirect(paymentUrl);
}
}