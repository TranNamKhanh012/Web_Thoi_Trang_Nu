package dao;

import context.DBContext;
import entity.Cart;
import entity.CartItem;
import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CartDAO {
    
    // Lấy ID giỏ hàng của user, hoặc tạo mới nếu chưa có
    private int getOrCreateCartId(int userId) {
        String findQuery = "SELECT id FROM carts WHERE user_id = ?";
        String createQuery = "INSERT INTO carts (user_id) VALUES (?)";
        try (Connection conn = DBContext.getConnection()) {
            // Thử tìm
            try (PreparedStatement ps = conn.prepareStatement(findQuery)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("id"); // Tìm thấy, trả về ID
                    }
                }
            }
            // Không tìm thấy, tạo mới
            try (PreparedStatement ps = conn.prepareStatement(createQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về ID vừa tạo
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Lỗi
    }
    
    // Tải giỏ hàng từ DB về thành 1 đối tượng Cart
    public Cart getCartByUserId(int userId) {
        Cart cart = new Cart();
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return cart; 
        
        String query = "SELECT ci.*, p.name, p.sale_price, p.original_price, p.image_url "
                     + "FROM cart_items ci "
                     + "JOIN products p ON ci.product_id = p.id "
                     + "WHERE ci.cart_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    
                    int quantity = rs.getInt("quantity");
                    String size = rs.getString("size");
                    
                    CartItem item = new CartItem(p, quantity, size);
                    cart.addItem(item); // Phương thức addItem của Cart đã được cập nhật
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return cart;
    }

    // Thêm/cập nhật sản phẩm trong giỏ hàng DB
    public void addOrUpdateItem(int userId, int productId, int quantity, String size) {
        int cartId = getOrCreateCartId(userId);
        String query = "INSERT INTO cart_items (cart_id, product_id, quantity, size) VALUES (?, ?, ?, ?) "
                     + "ON DUPLICATE KEY UPDATE quantity = quantity + ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setString(4, size);
            ps.setInt(5, quantity); // Lượng cộng thêm
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }    
    // Cập nhật số lượng
    public void updateItemQuantity(int userId, int productId, int quantity, String size) {
        int cartId = getOrCreateCartId(userId);
        String query = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ? AND size = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.setInt(3, productId);
            ps.setString(4, size);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // Xóa sản phẩm
    public void removeItem(int userId, int productId, String size) {
        int cartId = getOrCreateCartId(userId);
        String query = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ? AND size = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.setString(3, size);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // Gộp giỏ hàng session vào DB khi đăng nhập
    public void mergeSessionCartToDb(Cart sessionCart, int userId) {
        if (sessionCart == null || sessionCart.getItems().isEmpty()) return;
        for (CartItem item : sessionCart.getItems().values()) {
            addOrUpdateItem(userId, item.getProduct().getId(), item.getQuantity(), item.getSize());
        }
    }
    // Dán vào bên trong class CartDAO
public void clearCartByUserId(int userId) {
    String getCartId = "SELECT id FROM carts WHERE user_id = ?";
    String deleteItems = "DELETE FROM cart_items WHERE cart_id = ?";
    String deleteCart = "DELETE FROM carts WHERE id = ?";
    
    Connection conn = null;
    try {
        conn = DBContext.getConnection();
        conn.setAutoCommit(false); // Bắt đầu Transaction
        
        int cartId = -1;
        // Lấy cart_id
        try (PreparedStatement psGet = conn.prepareStatement(getCartId)) {
            psGet.setInt(1, userId);
            try (ResultSet rs = psGet.executeQuery()) {
                if (rs.next()) cartId = rs.getInt("id");
            }
        }
        
        if (cartId != -1) {
            // Xóa các items
            try (PreparedStatement psDeleteItems = conn.prepareStatement(deleteItems)) {
                psDeleteItems.setInt(1, cartId);
                psDeleteItems.executeUpdate();
            }
            // Xóa giỏ hàng
            try (PreparedStatement psDeleteCart = conn.prepareStatement(deleteCart)) {
                psDeleteCart.setInt(1, cartId);
                psDeleteCart.executeUpdate();
            }
        }
        
        conn.commit(); // Hoàn tất transaction
        
    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
    }
}
}