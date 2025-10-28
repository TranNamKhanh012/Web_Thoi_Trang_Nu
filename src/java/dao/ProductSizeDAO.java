package dao;

import context.DBContext;
import entity.ProductSize;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductSizeDAO {
    
    public List<ProductSize> getSizesByProductId(int productId) {
        List<ProductSize> list = new ArrayList<>();
        String query = "SELECT * FROM product_sizes WHERE product_id = ? AND stock > 0 ORDER BY size";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductSize psz = new ProductSize();
                    psz.setId(rs.getInt("id"));
                    psz.setProductId(rs.getInt("product_id"));
                    psz.setSize(rs.getString("size"));
                    psz.setStock(rs.getInt("stock"));
                    list.add(psz);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Dán vào bên trong class ProductSizeDAO
    public int getStockForSize(int productId, String size) {
        String query = "SELECT stock FROM product_sizes WHERE product_id = ? AND size = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ps.setString(2, size);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("stock");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu không tìm thấy hoặc lỗi
    }
    // Dán vào bên trong class ProductSizeDAO
    public int sumTotalStock() {
        String query = "SELECT SUM(stock) FROM product_sizes";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1); // Trả về tổng tồn kho
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu có lỗi
    }
}