package dao;

import context.DBContext;
import entity.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    /**
     * Lấy tất cả các danh mục từ database.
     * @return Danh sách các đối tượng Category.
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String query = "SELECT id, name FROM categories ORDER BY name ASC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(new Category(rs.getInt("id"), rs.getString("name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // *** THÊM CÁC PHƯƠNG THỨC MỚI ***

    // Lấy một danh mục theo ID (để sửa)
    public Category getCategoryById(int id) {
        String query = "SELECT id, name FROM categories WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(rs.getInt("id"), rs.getString("name"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Thêm danh mục mới
    public void addCategory(String name) {
        String query = "INSERT INTO categories (name) VALUES (?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); } // Nên bắt SQLException để xử lý lỗi trùng tên
    }

    // Cập nhật tên danh mục
    public void updateCategory(int id, String name) {
        String query = "UPDATE categories SET name = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Xóa danh mục
    public void deleteCategory(int id) {
        // Cảnh báo: Nên kiểm tra xem có sản phẩm nào thuộc danh mục này không trước khi xóa
        // Hoặc xử lý trong DB bằng cách SET NULL khóa ngoại category_id trong bảng products
        String query = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); } // Nên bắt SQLException để xử lý lỗi khóa ngoại
    }
}