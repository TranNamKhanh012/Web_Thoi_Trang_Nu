package dao;

import context.DBContext;
import entity.Cart;
import entity.CartItem;
import entity.Order;
import entity.OrderDetail;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    // Phương thức quan trọng: Tạo đơn hàng mới
    // Sử dụng Transaction để đảm bảo tính toàn vẹn dữ liệu
    public int createOrder(User user, Cart cart, String shippingAddress, String phoneNumber) {
    String insertOrderSQL = "INSERT INTO orders (user_id, total_money, shipping_address, status) VALUES (?, ?, ?, 'pending')";
    // CẬP NHẬT SQL: Thêm cột 'size'
    String insertOrderDetailSQL = "INSERT INTO order_details (order_id, product_id, quantity, price_at_purchase, size) VALUES (?, ?, ?, ?, ?)";
    
    Connection conn = null;
    try {
        conn = DBContext.getConnection();
        conn.setAutoCommit(false);
        
        try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
            psOrder.setInt(1, user.getId());
            psOrder.setDouble(2, cart.getFinalTotal());
            psOrder.setString(3, shippingAddress);
            psOrder.executeUpdate();
            
            try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int orderId = generatedKeys.getInt(1);
                    
                    for (CartItem item : cart.getItems().values()) {
                        try (PreparedStatement psDetail = conn.prepareStatement(insertOrderDetailSQL)) {
                            psDetail.setInt(1, orderId);
                            psDetail.setInt(2, item.getProduct().getId());
                            psDetail.setInt(3, item.getQuantity());
                            psDetail.setDouble(4, item.getProduct().getSalePrice());
                            psDetail.setString(5, item.getSize()); // THÊM SIZE
                            psDetail.executeUpdate();
                        }
                    }
                    conn.commit();
                    return orderId;
                }
            }
        }
    } catch (Exception e) {
            // Nếu có lỗi, rollback tất cả các thay đổi
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return -1; // Trả về -1 nếu có lỗi
    }
    // Dán vào bên trong class OrderDAO
    public void updateOrderStatus(int orderId, String status) {
        String query = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Dán 2 phương thức này vào bên trong class OrderDAO

public List<Order> getOrdersByUserId(int userId) {
    List<Order> orderList = new ArrayList<>();
    String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalMoney(rs.getDouble("total_money"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setStatus(rs.getString("status"));
                // Lấy chi tiết cho đơn hàng này
                order.setDetails(getOrderDetailsByOrderId(order.getId()));
                orderList.add(order);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return orderList;
}

public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
    List<OrderDetail> detailList = new ArrayList<>();
    String query = "SELECT od.*, p.name as productName, p.image_url as productImageUrl "
                 + "FROM order_details od "
                 + "JOIN products p ON od.product_id = p.id "
                 + "WHERE od.order_id = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPriceAtPurchase(rs.getDouble("price_at_purchase"));
                detail.setProductName(rs.getString("productName"));
                detail.setProductImageUrl(rs.getString("productImageUrl"));
                detailList.add(detail);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return detailList;
}
    // Dán vào bên trong class OrderDAO
public int countNewOrders() {
    String query = "SELECT COUNT(*) FROM orders WHERE status = 'pending'";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}

// Hàm tính doanh thu chung
private double calculateRevenue(String dateCondition) {
    String query = "SELECT SUM(total_money) FROM orders WHERE status = 'completed' AND " + dateCondition;
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getDouble(1);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return 0.0;
}

public double calculateRevenueToday() {
    // CURDATE() lấy ngày hiện tại (YYYY-MM-DD)
    return calculateRevenue("DATE(order_date) = CURDATE()");
}

public double calculateRevenueThisWeek() {
    // YEARWEEK(order_date, 1) lấy năm và tuần (tuần bắt đầu từ thứ 2)
    return calculateRevenue("YEARWEEK(order_date, 1) = YEARWEEK(CURDATE(), 1)");
}

public double calculateRevenueThisMonth() {
    // YEAR(order_date) = YEAR(CURDATE()) AND MONTH(order_date) = MONTH(CURDATE())
    return calculateRevenue("YEAR(order_date) = YEAR(CURDATE()) AND MONTH(order_date) = MONTH(CURDATE())");
}

// Lấy doanh thu 7 ngày gần nhất (trả về Map<Ngày, DoanhThu>)
    public Map<String, Double> getRevenueLast7Days() {
        Map<String, Double> revenueMap = new LinkedHashMap<>(); // LinkedHashMap giữ thứ tự
        String query = "SELECT DATE(order_date) as order_day, SUM(total_money) as daily_revenue " +
                       "FROM orders " +
                       "WHERE status = 'completed' AND order_date >= CURDATE() - INTERVAL 6 DAY " + // Lấy từ 6 ngày trước đến nay
                       "GROUP BY DATE(order_date) " +
                       "ORDER BY order_day ASC"; // Sắp xếp theo ngày tăng dần

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            // Khởi tạo 7 ngày gần nhất với doanh thu 0
            LocalDate today = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            for (int i = 6; i >= 0; i--) {
                revenueMap.put(today.minusDays(i).format(formatter), 0.0);
            }

            // Cập nhật doanh thu từ kết quả query
            while (rs.next()) {
                String orderDay = rs.getString("order_day");
                double dailyRevenue = rs.getDouble("daily_revenue");
                revenueMap.put(orderDay, dailyRevenue); // Ghi đè giá trị 0 nếu có doanh thu
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueMap;
    }
    // Dán vào bên trong class OrderDAO
    public List<Order> getAllOrders() {
        List<Order> orderList = new ArrayList<>();
        // Lấy thêm fullname từ bảng users
        String query = "SELECT o.*, u.fullname "
                     + "FROM orders o "
                     + "JOIN users u ON o.user_id = u.id "
                     + "ORDER BY o.order_date DESC"; // Sắp xếp mới nhất lên đầu
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalMoney(rs.getDouble("total_money"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setStatus(rs.getString("status"));
                // Lấy tên khách hàng (cần thêm trường fullname vào Order.java)
                // order.setUserFullname(rs.getString("fullname")); 
                orderList.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }
    public Order getOrderByIdAndUser(int orderId, int userId) {
     Order order = null;
     String query = "SELECT * FROM orders WHERE id = ? AND user_id = ?";
     try (Connection conn = DBContext.getConnection();
          PreparedStatement ps = conn.prepareStatement(query)) {

         ps.setInt(1, orderId);
         ps.setInt(2, userId);

         try (ResultSet rs = ps.executeQuery()) {
             if (rs.next()) {
                 order = new Order();
                 order.setId(rs.getInt("id"));
                 order.setUserId(rs.getInt("user_id"));
                 order.setOrderDate(rs.getTimestamp("order_date"));
                 order.setTotalMoney(rs.getDouble("total_money"));
                 order.setShippingAddress(rs.getString("shipping_address"));
                 order.setStatus(rs.getString("status"));

                 // Lấy chi tiết các sản phẩm trong đơn hàng này
                 order.setDetails(getOrderDetailsByOrderId(order.getId()));
             }
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return order;
 }
    // Dán hàm này vào bên trong class OrderDAO
    public Order getOrderById(int orderId) {
        Order order = null;
        String query = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalMoney(rs.getDouble("total_money"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setStatus(rs.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }
    // Thêm vào OrderDAO.java
    public double calculateTotalRevenue() {
        String query = "SELECT SUM(total_money) FROM orders WHERE status = 'completed'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }
    // ... (Các hàm calculateRevenue khác)

    // --- THÊM HÀM NÀY ---
    public double calculateRevenueThisYear() {
        // Tính tổng tiền các đơn hàng hoàn thành trong năm hiện tại
        String condition = "YEAR(order_date) = YEAR(CURDATE())";
        // Tái sử dụng hàm calculateRevenue(condition) nếu bạn đã có (như trong code cũ)
        // Hoặc viết full câu query như dưới đây:
        String query = "SELECT SUM(total_money) FROM orders WHERE status = 'completed' AND " + condition;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }
}