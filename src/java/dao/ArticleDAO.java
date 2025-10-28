package dao;

import context.DBContext;
import entity.Article;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {

    /**
     * Lấy tất cả bài viết, sắp xếp mới nhất lên đầu.
     */
    public List<Article> getAllArticles() {
        List<Article> list = new ArrayList<>();
        String query = "SELECT * FROM articles ORDER BY created_date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Article a = new Article();
                a.setId(rs.getInt("id"));
                a.setTitle(rs.getString("title"));
                a.setImageUrl(rs.getString("image_url"));
                a.setCreatedDate(rs.getTimestamp("created_date"));
                // Lấy nội dung tóm tắt (ví dụ 150 ký tự đầu)
                String content = rs.getString("content");
                if (content.length() > 150) {
                    content = content.substring(0, 150) + "...";
                }
                a.setContent(content); // Dùng content để lưu tóm tắt
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy chi tiết 1 bài viết bằng ID.
     */
    public Article getArticleById(int id) {
        String query = "SELECT * FROM articles WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Article a = new Article();
                    a.setId(rs.getInt("id"));
                    a.setTitle(rs.getString("title"));
                    a.setContent(rs.getString("content")); // Lấy đầy đủ nội dung
                    a.setImageUrl(rs.getString("image_url"));
                    a.setCreatedDate(rs.getTimestamp("created_date"));
                    return a;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // Thêm bài viết mới
    public void addArticle(String title, String content, String imageUrl, int authorId) {
        String query = "INSERT INTO articles (title, content, image_url, author_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, imageUrl);
            ps.setInt(4, authorId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật bài viết
    public void updateArticle(int id, String title, String content, String imageUrl) {
        String query = "UPDATE articles SET title = ?, content = ?, image_url = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, imageUrl);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Xóa bài viết
    public void deleteArticle(int id) {
        String query = "DELETE FROM articles WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}